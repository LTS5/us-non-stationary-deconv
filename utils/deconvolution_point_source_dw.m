function deconvolution_point_source_dw(flag_psf_meth, flag_display, filename_out, p, lambda, maximum_iterations)
disp('********* Deconvolution of the point source phantom - diverging wave *********');
%% Load the data
% Add the utils folder to the path
addpath(genpath('utils'));

% Load the data set
load 'data/rawdata_sparse_sources_DW_el_focus.mat'

% Select a given data
rawdata = raw_data(:,:,2);
G_param.zn = zn;
G_param.xn = xn(2);

% Select region of interest in the data
z_max = 100/1000;
z_min = 20/1000;
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
G_param.x_im = -45/1000:G_param.lambda/3:45/1000;

% Create the DAS operator
G_param.el_width = probe.width;
disp('******* Build the DAS operator *******')
disp('It may take a long time (several minutes)')
H_das = BuildHprime_DW(G_param);

% DAS image
disp('******* Generate the RF image *******')
rf = reshape(H_das*rawdata(:), [numel(G_param.z_im), numel(G_param.x_im)]);
env_rf = abs(hilbert(rf));
L = size(rf);

%% Generate the PSF
if flag_psf_meth == 1
    % Load the psf
    load 'data/rf_psf_dw.mat';
    psf = rf_image;
    
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
    pulse_pad = zeros(size(G_param.z));
    pulse_pad(1:numel(pulse)) = pulse;
    pulse_pad = circshift(pulse_pad, -round(numel(pulse)/2));
    K_h = circulant(pulse_pad);
    
    % Generate the proposed PSF operator
    F = generate_proposed_psf_operator_dw(K_h, G_param, H_das);
    
else
    error('Wrong PSF method, please specify a number between 1 and 3');
end

%% lp-based deconvolution
disp('******* lp-deconvolution of the RF image *******')
rf_image = rf;
res = lp_deconvolution(p, lambda, maximum_iterations, rf_image, F);

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
    save(filename_out, 'G_param', 'rf', 'trf');
end
end