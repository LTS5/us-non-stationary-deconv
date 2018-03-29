function display_bmode_points(path_rf, path_varying, path_estimated, path_constant)
dBRange = 40;

%-- Location of the points
x = [0; -40; -20; 0; 20; 40; 0; 0]/1000;
z = [30; 50*ones(5,1); 70; 90]/1000;
roi_size = [50, 50];
for kk = 1:numel(x)
    close all;
    %-- Considered point
    x_kk = x(kk);
    z_kk = z(kk);
    
    %-- RF image
    load(path_rf)
    env_rf = abs(hilbert(rf_image));
    bmode_rf = 20*log10(env_rf / max(env_rf(:)));
    
    %-- Index of the point
    [~, ind_x] = min(abs(G_param.x_im-x_kk));
    [~, ind_z] = min(abs(G_param.z_im-z_kk));
    roi_x = (ind_x-roi_size(1)/2):(ind_x+roi_size(1)/2);
    roi_z = (ind_z-roi_size(2)/2):(ind_z+roi_size(2)/2);
    
    %-- Bmode image of the ROI
    bmode_rf_point = bmode_rf(roi_z,:);
    bmode_rf_point = bmode_rf_point(:,roi_x);
    
    %-- TRF image - varying PSF
    load(path_varying)
    env_trf = abs(hilbert(trf_rec));
    bmode_trf = 20*log10(env_trf / max(env_trf(:)));
    
    %-- Bmode image of the ROI
    bmode_trf_point = bmode_trf(roi_z,:);
    bmode_trf_point = bmode_trf_point(:,roi_x);
    
    %-- TRF image - constant PSF
    load(path_constant)
    env_trf_cst = abs(hilbert(trf_rec));
    bmode_trf_cst = 20*log10(env_trf_cst / max(env_trf_cst(:)));
    
    %-- Bmode image of the ROI
    bmode_trf_cst_point = bmode_trf_cst(roi_z,:);
    bmode_trf_cst_point = bmode_trf_cst_point(:,roi_x);
    
    %-- TRF image - estimated PSF
    load(path_estimated)
    env_trf_est = abs(hilbert(trf_rec));
    bmode_trf_est = 20*log10(env_trf_est / max(env_trf_est(:)));
    
    %-- Bmode image of the ROI
    bmode_trf_est_point = bmode_trf_est(roi_z,:);
    bmode_trf_est_point = bmode_trf_est_point(:,roi_x);
    
    % Display
    vrange = [-dBRange, 0];
    h = figure('Color', [1 1 1]);
    imagesc(bmode_rf_point);
    shading flat; colormap gray; caxis(vrange); 
    set(gca,'xtick',[]);
    set(gca,'xticklabel',[]);
    set(gca,'ytick',[]);
    set(gca,'yticklabel',[]);
    axis image;
    export_fig(strcat(['rf_sparse_sources_dw_point_', num2str(kk)]), h, '-pdf'); 
    pause(0.5);
    
    h = figure('Color', [1 1 1]);
    imagesc(bmode_trf_point);
    shading flat; colormap gray; caxis(vrange);
    set(gca,'xtick',[]);
    set(gca,'xticklabel',[]);
    set(gca,'ytick',[]);
    set(gca,'yticklabel',[]);
    axis image;
    export_fig(strcat(['trf_varying_sparse_sources_dw_point_', num2str(kk)]), h, '-pdf'); 
    pause(0.5);
    
    h = figure('Color', [1 1 1]);
    imagesc(bmode_trf_est_point);
    shading flat; colormap gray; caxis(vrange);
    set(gca,'xtick',[]);
    set(gca,'xticklabel',[]);
    set(gca,'ytick',[]);
    set(gca,'yticklabel',[]);
    axis image;
    pause(0.5);
    export_fig(strcat(['trf_estimated_sparse_sources_dw_point_', num2str(kk)]), h,  '-pdf'); 
end
end