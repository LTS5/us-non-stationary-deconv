function h = plot_bmode(x, z, bmode, dBRange)
vrange = [-dBRange,0];

h = figure('Color', [1 1 1]);
imagesc(x*1000, z*1000, bmode);
shading flat; colormap gray; caxis(vrange); colorbar; hold on;
axis image;
xlabel 'Lateral dimension [mm]'
ylabel 'Depth [mm]'

list_tick = -dBRange:10:0;
y_tick_label = cell(size(list_tick));
for kk = 1:numel(list_tick)
    y_tick_label{kk} = strcat([num2str(list_tick(kk)), ' db']);
end
h2 = colorbar;
set(h2,'YTick',list_tick);
set(h2,'YTickLabel',y_tick_label);
set(gca,'YDir','reverse');
set(gca,'fontsize',16);

