function deconvolution_point_source_dw(flag_psf_meth, flag_display, filename_out, p, lambda, maximum_iterations)
disp('********* Deconvolution of the point source phantom - diverging wave *********');
%% Load the data
% Add the utils folder to the path
addpath(genpath('utils'));

% Load the data set
load 'data/rawdata_sparse_sources_DW_el_focus.mat'

% Select a given data
rawdata = raw_data(:,:,2);

% Virtual point source
G_param.zn = zn;
G_param.xn = xn(2);

% Speed of sound
G_param.c = 1540;

% Select region of interest in the data
z_max = 100/1000;
z_min = 20/1000;
ind_min = round(z_min*2/probe.c0*probe.rf_sampling_frequency)+1;
ind_max = round(z_max*2/probe.c0*probe.rf_sampling_frequency);
rawdata = rawdata(ind_min:ind_max,:);

%% Generate the RF image
%-- Wavelength and element width
G_param.lambda = probe.c0/probe.f0;
G_param.el_width = probe.width;

% Rawdata grid
G_param.x = (0:probe.N_elements-1)*probe.pitch;
G_param.x = G_param.x - G_param.x(end/2);
G_param.t = (ind_min:ind_max)/probe.rf_sampling_frequency;
G_param.z = G_param.t*probe.c0/2;

% Image grid
G_param.z_im = G_param.z(1):G_param.lambda/8:G_param.z(end);
G_param.x_im = -45/1000:G_param.lambda/3:45/1000;

% DAS image
disp('******* Generate the RF image *******')
rf = das_dw_forward(G_param, rawdata);
env_rf = abs(hilbert(rf));
L = size(rf);

%% Generate the PSF
gamma = [];
if flag_psf_meth == 1
    % Load the psf
    load 'data/rf_psf_dw.mat';
    psf = rf_image;
    psf = psf/ max(abs(psf(:)));
    psf = psf(534:734,140:340);
    
    % Generate the PSF operator
    F = generate_stationary_psf_operator(psf, L);
    
elseif flag_psf_meth == 2
    load 'data/psf_dw_est.mat'
    
    % Generate the PSF operator
    F = generate_stationary_psf_operator(psf_est, L);
    
elseif flag_psf_meth == 3
    % Create the pulse matrix
    pulse = conv(conv(probe.excitation, probe.impulse_response), probe.impulse_response);
    pulse = pulse / max(abs(pulse));
%     pulse_pad = zeros(size(G_param.z));
%     pulse_pad(1:numel(pulse)) = pulse;
%     pulse_pad = circshift(pulse_pad, -round(numel(pulse)/2));
%     K_h = circulant(pulse_pad);
    
    % Generate the proposed PSF operator
    F = generate_proposed_psf_operator_dw(G_param, pulse);
    
    % Spectral norm of the operator
    gamma = 1/(2.755020e+09); % With 1/r 
    %gamma = 1 / (4.332463e+12); % With 1/r^2 
else
    error('Wrong PSF method, please specify a number between 1 and 3');
end

%% lp-based deconvolution
disp('******* lp-deconvolution of the RF image *******')
rf_image = rf;
res = lp_deconvolution(p, lambda, maximum_iterations, rf_image, F, gamma);

% Envelope of the TRF image
trf_rec = reshape(res.x, size(rf_image));
env_trf = abs(hilbert(trf_rec));

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
    save(filename_out, 'G_param', 'rf', 'trf_rec');
end
end