function compute_metrics_carotid(filenameIn, dBRange)
if nargin == 1
    dBRange = 40;
end

format = '.mat';
%-- Loop over the files
for ll=1:numel(filenameIn)
    
    %-- Load the RF image
    load(filenameIn{ll})
    
    %-- Region of interest for computation of the metrics
    if contains(filenameIn{ll}, 'fr')
        z_roi = [20, 21.5]*1e-3;
        x_roi_background = [-11.5, -8.5]*1e-3;
        x_roi_tissue = [8.5, 11.5]*1e-3;
    else
        z_roi = [17.5, 19]*1e-3;
        x_roi_background = [8.5, 12]*1e-3;
        x_roi_tissue = [-7.5, -4]*1e-3;
    end
    
    %-- Transform depth lateral dimension into indices
    dx_im = G_param.x_im(2) - G_param.x_im(1);
    dz_im = G_param.z_im(2) - G_param.z_im(1);
    ind_z_roi = round((z_roi - G_param.z_im(1))/dz_im);
    ind_x_roi_background = round((x_roi_background - G_param.x_im(1))/ dx_im);
    ind_x_roi_tissue = round((x_roi_tissue - G_param.x_im(1))/ dx_im);
    
    %-- Normalized envelope
    env_trf = abs(hilbert(trf_rec));
    env_trf = env_trf / max(env_trf(:));
    
    %-- Tissue-to-clutter ratio
    background = env_trf(ind_z_roi(1):ind_z_roi(2),ind_x_roi_background(1):ind_x_roi_background(2));
    tissue = env_trf(ind_z_roi(1):ind_z_roi(2),ind_x_roi_tissue(1):ind_x_roi_tissue(2));
    mu_tissue = mean(tissue(:));
    mu_background = mean(background(:));
    tcr = 20*log10(mu_tissue / mu_background)

    %-- CNR on the B-mode image
    bmode_compressed = 20*log10(env_trf);
    bmode_compressed(bmode_compressed < - dBRange) = -dBRange;
    background_bmode = bmode_compressed(ind_z_roi(1):ind_z_roi(2),ind_x_roi_background(1):ind_x_roi_background(2));
    tissue_bmode = bmode_compressed(ind_z_roi(1):ind_z_roi(2),ind_x_roi_tissue(1):ind_x_roi_tissue(2));
    tissue_linearized = 10.^(tissue_bmode / 20);
    background_linearized = 10.^(background_bmode / 20);
    snr = abs((mean(tissue_linearized(:)) - mean(background_linearized(:)))) / sqrt(var(var(tissue_linearized)) + var(var(background_linearized)))
    
    %-- Save the results
    filename = strsplit(filenameIn{ll}, '.');
    filename_out = strcat(filename{1}, '_metrics', format);
    save(filename_out, 'snr', 'tcr', 'G_param');
end