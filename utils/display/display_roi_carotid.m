function display_roi_carotid(filename, dBRange)
if nargin == 1
    dBRange = 40;
end
%-- Loop over the files
load(filename)

%-- Region of interest for computation of the metrics
if contains(filename, 'fr')
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

%-- Mask for contour plot
mask_background = zeros(size(trf_rec));
mask_tissue = zeros(size(trf_rec));
mask_background(ind_z_roi(1):ind_z_roi(2), ind_x_roi_background(1):ind_x_roi_background(2)) = 1;
mask_tissue(ind_z_roi(1):ind_z_roi(2), ind_x_roi_tissue(1):ind_x_roi_tissue(2)) = 1;

%-- Normalized envelope
env_trf = abs(hilbert(trf_rec));
env_trf = env_trf / max(env_trf(:));

%-- Log compressed bmode
bmode = 20*log10(env_trf);

%-- Display
linewidth = 2;
fontsize = 16;
vrange = [-dBRange,0];
h = figure('Color', [1 1 1]);
imagesc(G_param.x_im*1000, G_param.z_im*1000, bmode);
caxis(vrange)
hold on 
contour(G_param.x_im*1000, G_param.z_im*1000, mask_background, 'g', 'Linewidth', linewidth)
hold on 
contour(G_param.x_im*1000, G_param.z_im*1000, mask_tissue, 'r', 'Linewidth', linewidth)
hold on 
text((G_param.x_im(ind_x_roi_tissue(1)) + G_param.x_im(ind_x_roi_tissue(2)-10))/2*1000,G_param.z_im(ind_z_roi(2)-130)*1000,'1', 'Color', 'red', 'FontSize', 20)
hold on 
text((G_param.x_im(ind_x_roi_background(1)) + G_param.x_im(ind_x_roi_background(2)-10))/2*1000,G_param.z_im(ind_z_roi(2)-130)*1000,'2', 'Color', 'green', 'FontSize', 20)
colormap gray;
axis image;
xlabel 'Lateral dimension [mm]'
ylabel 'Depth [mm]'
set(gca, 'fontsize', fontsize)

