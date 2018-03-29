function deconvolution_point_source_pw(flag_psf_meth, flag_display, filename_out, p, lambda, maximum_iterations)
% PW imaging - deconvolution with the point-source phantom
% Script used to reproduce the results of Section V.A of the paper "Towards fast non-stationary deconvolution in ultrasound imaging"
disp('********* Deconvolution of the point source phantom - plane wave *********');
%% Load the data
% Add the right path
addpath(genpath('utils'));

% Load the data set
load 'data/rawdata_sparse_sources_PW.mat';

% Select a given data
G_param.angle = 0;
rawdata = raw_data(:,:,2);

% Select region of interest in the data
z_max = 45/1000;
z_min = 5/1000;
ind_min = round(z_min*2/probe.c0*probe.rf_sampling_frequency)+1;
ind_max = round(z_max*2/probe.c0*probe.rf_sampling_frequency);
rawdata = rawdata(ind_min:ind_max,:);

%% Generate the RF image
% Rawdata grid
G_param.x = (0:probe.N_elements-1)*probe.pitch;
G_param.x = G_param.x - G_param.x(end/2);
G_param.z = (ind_min:ind_max)*probe.c0/2/probe.rf_sampling_frequency;

% Image grid
G_param.lambda = probe.c0/probe.f0;
G_param.z_im = G_param.z(1):G_param.lambda/8:G_param.z(end);
G_param.x_im = G_param.x(1):G_param.lambda/3:G_param.x(end);

% Create the DAS operator
G_param.el_width = probe.width;
disp('******* Build the DAS operator *******')
disp('It may take a long time (several minutes)')
H_das = BuildHprime_PW(G_param);

% DAS image
disp('******* Generate the RF image *******')
rf = reshape(H_das*rawdata(:), [numel(G_param.z_im), numel(G_param.x_im)]);
env_rf = abs(hilbert(rf));
L = size(rf);

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
    
    % Generate the PSF operator
    F = generate_stationary_psf_operator(psf_est, L);
    
elseif flag_psf_meth == 3
    % Pulse shape
    pulse = conv(conv(probe.excitation, probe.impulse_response), probe.impulse_response);
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
trf = reshape(res.x, size(rf));
env_trf = abs(hilbert(trf));

% Display
if flag_display == 1
    figure
    imagesc(G_param.x_im*1000, G_param.z_im*1000, 20*log10(env_trf / max(env_trf(:))), [-40 0]); colormap gray;
    axis image;
    xlabel('Lateral dimension [mm]');
    ylabel('Depth [mm]')
    title('Deconvolved image')
    figure
    imagesc(G_param.x_im*1000, G_param.z_im*1000, 20*log10(env_rf / max(env_rf(:))), [-40 0]); colormap gray;
    axis image;
    xlabel('Lateral dimension [mm]');
    ylabel('Depth [mm]')
    title('RF image')
end
if not(isempty(filename_out))
    save(filename_out, 'G_param', 'rf', 'trf');
end
end