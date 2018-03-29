function deconvolution_picmus(flag_psf_meth, flag_display, filename_out, p, lambda, maximum_iterations)
% PW imaging - deconvolution with the PICMUS phantom
% Script used to reproduce the results of Section V.B of the paper "Towards fast non-stationary deconvolution in ultrasound imaging"
disp('********* Deconvolution of the PICMUS numerical phantom *********');
%% Load the data
% Add PICMUS path
addpath(genpath('picmus'));
addpath(genpath('utils'));

%-- parameters
signal_selection = 1;       %-- 1: RF | 2: IQ
pht_selection = 1;          %-- 1: numerical | 2: in_vitro_type1 | 3: in_vitro_type2 | 4: in_vitro_type3
transmission_selection = 1; %-- 1: regular | 2: dichotomous
nbPW_number = 1;            %-- An odd value between 1 and 75
dynamic_range = 60;

%-- generate corresponding dataset filename
[filenames] = tools.generate_filenames(signal_selection,pht_selection,transmission_selection,nbPW_number);

%-- data location
url = 'https://www.creatis.insa-lyon.fr/EvaluationPlatform/picmus/dataset/';
local_path = [picmus_path(),'/data/']; % location of example data in this computer

%-- download scanning region file
if (~exist([local_path,filenames.scan],'file'))
    tools.download(filenames.scan, url, local_path);
end

%-- download dataset
if (~exist([local_path,filenames.dataset],'file'))
    tools.download(filenames.dataset, url, local_path);
end

%-- set paths
path_dataset = [picmus_path(),'/data/',filenames.dataset];
path_scan = [picmus_path(),'/data/',filenames.scan];

%-- load scan and dataset
scan = linear_scan();
scan.read_file(path_scan);
dataset = us_dataset();
dataset.read_file(path_dataset);

%% Generate the RF image
%-- Parameters to build the measurement model
central_frequency = 5.208e6; % Probe central frequency
G_param.lambda = double(dataset.c0/central_frequency);
G_param.el_width = 0.27*1e-3;
G_param.ispropagation =0;

%-- Apodization for the DAS operator
G_param.isapodization = 0;
G_param.apodization.window = 'tukey25';
G_param.apodization.f_number = 1.75;

% % Crop the raw data to fit the scan
ind_min = 2*round(scan.z_axis(1)/scan.dz);
ind_max = 2*round(scan.z_axis(end)/scan.dz);
dataset.data = dataset.data(ind_min:ind_max, :, :);

%-- Raw data grid
G_param.x = double(dataset.probe_geometry(:,1))';
time_vector = double(dataset.initial_time+(ind_min:ind_max)/dataset.sampling_frequency);
G_param.z = double(dataset.c0*time_vector/2);

%-- Image grid
G_param.x_im = double(scan.x_axis)';
G_param.z_im = G_param.z;

%-- Build the DAS matrix
disp('******* Build the DAS operator *******')
disp('It may take a long time (several minutes)')
H_das = BuildHprime_PW(G_param);

%-- RF data
disp('******* Generate the RF image *******')
raw_data = double(dataset.data);
rf = reshape(H_das*raw_data(:), [numel(G_param.z_im) numel(G_param.x_im)]);
L = size(rf);

%-- Take the envelope of the RF data
env_rf = tools.envelope(rf);

%-- Reshape to the scan grid
env_rf = interp1(G_param.z_im, env_rf, scan.z_axis, 'pchip', 0);

%% Generate the PSF
if flag_psf_meth == 1
    % Load the prestored PSF
    load 'data/rf_psf_pw.mat';
    psf = rf_image;
    
    % Generate the PSF operator
    F = generate_stationary_psf_operator(psf, L);
     
elseif flag_psf_meth == 2
    % Load the estimated PSF
    load 'data/psf_pw_est_sparse.mat';
    psf = psf_est;
    
    % Generate the PSF operator
    F = generate_stationary_psf_operator(psf, L);
    
elseif flag_psf_meth == 3
    %-- Pulse shape
    bw = 0.67;
    dt = 1/double(dataset.sampling_frequency);
    pulse_duration = 2;
    t0 = (-1/bw/central_frequency): dt : (1/bw/central_frequency);
    impulse_response = gauspuls(t0, central_frequency, bw);
    te = (-pulse_duration/2/central_frequency): dt : (pulse_duration/2/central_frequency);
    excitation = square(2*pi*central_frequency*te+pi/2);
    one_way_ir = conv(impulse_response,excitation);
    pulse = conv(one_way_ir,impulse_response);
    pulse = pulse / max(abs(pulse));
    
    %-- Create the pulse matrix
    pulse_pad = zeros(size(G_param.z));
    pulse_pad(1:numel(pulse)) = pulse;
    pulse_pad = circshift(pulse_pad, -round(numel(pulse)/2));
    K_h = circulant(pulse_pad);
    
    % Generate the proposed PSF operator
    F = generate_proposed_psf_operator(G_param, H_das, K_h);

else
    error('Wrong PSF method, please specify a number between 1 and 3');
end

%% lp-based deconvolution
res = lp_deconvolution(p, lambda, maximum_iterations, rf, F);

% Envelope of the TRF image
env_trf = tools.envelope(res.x);

%-- Reshape to the scan grid
env_trf = interp1(G_param.z_im, env_trf, scan.z_axis, 'pchip', 0);

%-- Generate the image structure
image = us_image('Deconvolution-based beamforming');
image.author = 'Adrien Besson <adrien.besson.epfl@ch>';
image.affiliation = 'Adrien Besson';
image.algorithm = 'Delay-and-Sum (RF version)';
image.scan = scan;
image.number_plane_waves = length(dataset.angles);
image.data = env_trf;
image.transmit_f_number = 0;
image.receive_f_number = 0;
image.transmit_apodization_window = 'none';
image.receive_apodization_window = 'none';

if flag_display == 1
    figure
    imagesc(scan.x_axis*1000, scan.z_axis*1000, 20*log10(env_trf / max(env_trf(:))), [-dynamic_range 0]); colormap gray;
    axis image;
    xlabel('Lateral dimension [mm]');
    ylabel('Depth [mm]')
    title('Deconvolved image')
    figure
    imagesc(scan.x_axis*1000, scan.z_axis*1000, 20*log10(env_rf / max(env_rf(:))), [-dynamic_range 0]); colormap gray;
    axis image;
    xlabel('Lateral dimension [mm]');
    ylabel('Depth [mm]')
    title('RF image')
end
if not(isempty(filename_out))
    image.save(filename_out);
end
end