function display_bmode(path_rf, path_varying, path_estimated, path_constant)
    dBRange = 40;
    %-- RF image
    load(path_rf)
    env_rf = abs(hilbert(rf_image));
    bmode_rf = 20*log10(env_rf / max(env_rf(:)));

    %-- TRF image - varying PSF
    load(path_varying)
    env_trf = abs(hilbert(trf_rec));
    bmode_trf = 20*log10(env_trf / max(env_trf(:)));

    %-- TRF image - constant PSF
    load(path_constant)
    env_trf_cst = abs(hilbert(trf_rec));
    bmode_trf_cst = 20*log10(env_trf_cst / max(env_trf_cst(:)));

    %-- TRF image - estimated PSF
    load(path_estimated)
    env_trf_est = abs(hilbert(trf_rec));
    bmode_trf_est = 20*log10(env_trf_est / max(env_trf_est(:)));

    % Display
    h = plot_bmode(G_param.x_im*1000, G_param.z_im*1000, bmode_trf, dBRange);
    xlabel('lateral dimension [mm]');
    ylabel('Depth [mm]');
    title('TRF - proposed PSF')
    h = plot_bmode(G_param.x_im*1000, G_param.z_im*1000, bmode_trf_cst, dBRange);
    xlabel('lateral dimension [mm]');
    ylabel('Depth [mm]');
    title('TRF - simulated PSF')
    h = plot_bmode(G_param.x_im*1000, G_param.z_im*1000, bmode_trf_est, dBRange);
    xlabel('lateral dimension [mm]');
    ylabel('Depth [mm]');
    title('TRF - estimated PSF')
    h = plot_bmode(G_param.x_im*1000, G_param.z_im*1000, bmode_rf, dBRange);
    xlabel('lateral dimension [mm]');
    ylabel('Depth [mm]');
    title('RF')
end