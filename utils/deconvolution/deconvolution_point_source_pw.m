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
G_param.t = (ind_min:ind_max)/probe.rf_sampling_frequency;
G_param.z = G_param.t*probe.c0/2;
G_param.c = probe.c0;

% Image grid
G_param.lambda = probe.c0/probe.f0;
G_param.z_im = G_param.z(1):G_param.lambda/8:G_param.z(end);
G_param.x_im = G_param.x(1):G_param.lambda/3:G_param.x(end);

% Create the DAS operator
G_param.el_width = probe.width;

% DAS image
disp('******* Generate the RF image *******')
rf_image = das_forward(G_param, rawdata);
env_rf = abs(hilbert(rf_image));
L = size(rf_image);

%% Generate the PSF
gamma =[];
if flag_psf_meth == 1
    % Load the prestored PSF
    load 'data/rf_psf_pw.mat';
    
    % Shift the PSF to center it
    psf = circshift(psf, [-3 1]);
    
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
    
     % Generate the proposed PSF operator
     F = generate_proposed_mf_psf_operator(G_param, pulse);
     
     % Spectral norm of the operator
     gamma = 2.9848e3;
else
    error('Wrong PSF method, please specify a number between 1 and 3');
end

%% lp-based deconvolution
res = lp_deconvolution(p, lambda, maximum_iterations, rf_image, F, gamma);

% Envelope of the TRF image
trf_rec = reshape(res.x, size(rf_image));
env_trf = abs(hilbert(trf_rec));

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
    save(filename_out, 'G_param', 'rf_image', 'trf_rec');
end
end