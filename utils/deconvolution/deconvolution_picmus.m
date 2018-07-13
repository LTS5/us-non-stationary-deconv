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
central_frequency = 5.208e6; 
G_param.lambda = double(dataset.c0/central_frequency);
G_param.el_width = 0.27*1e-3;
G_param.c = 1540;

% Crop the raw data to fit the scan
ind_min = 2*round(scan.z_axis(1)/scan.dz);
ind_max = 2*round(scan.z_axis(end)/scan.dz);
dataset.data = dataset.data(ind_min:ind_max, :, :);

%-- Raw data grid
G_param.x = double(dataset.probe_geometry(:,1))';
G_param.t = double(dataset.initial_time+(ind_min:ind_max)/dataset.sampling_frequency);
G_param.z = double(dataset.c0*G_param.t/2);

%-- Image grid
G_param.x_im = double(scan.x_axis)';
G_param.z_im = G_param.z;

%-- RF data
disp('******* Generate the RF image *******')
raw_data = double(dataset.data);
rf = das_forward(G_param, raw_data);
L = size(rf);

%-- Take the envelope of the RF data
env_rf = tools.envelope(rf);

%-- Reshape to the scan grid
env_rf = interp1(G_param.z_im, env_rf, scan.z_axis, 'pchip', 0);

%% Generate the PSF
gamma = [];
if flag_psf_meth == 1
    % Load the prestored PSF
    load 'data/rf_psf_pw_forward.mat';
    
    % Shift the PSF to center it
    psf_crop = psf(128-27:128+27, 193-27:193+27);
    %psf_crop = circshift(psf_crop, [-2 0]);
    
    % Generate the PSF operator
    F = generate_stationary_psf_operator(psf_crop, L);
     
elseif flag_psf_meth == 2
    % Load the estimated PSF
    load 'data/psf_pw_est_sparse.mat';
    
    % Generate the PSF operator
    F = generate_stationary_psf_operator(psf_est, L);
    
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

     % Generate the proposed PSF operator
     F = generate_proposed_mf_psf_operator(G_param, pulse);
     
     % Spectral norm of the operator
     gamma = 6.8834e+03;
else
    error('Wrong PSF method, please specify a number between 1 and 3');
end

%% lp-based deconvolution
res = lp_deconvolution(p, lambda, maximum_iterations, rf, F,  gamma);

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
    image.write_file_mat(filename_out);
end
end