function display_barplots(path_varying, path_estimated, path_constant, flag_color)

    % Load the metrics
    load(path_varying);
    ax_res_plot(1,:) = ax_res;
    lat_res_plot(1,:) = lat_res;
    
    load(path_estimated);
    ax_res_plot(2,:) = ax_res;
    lat_res_plot(2,:) = lat_res;
    
    load(path_constant);
    ax_res_plot(3,:) = ax_res;
    lat_res_plot(3,:) = lat_res;
    
    if flag_color == 1
        color(1,:) = [1 1 0];
        color(2, :) = [1 0.6 0];
        color(3,:) = [1 0 0];
    else
        color(1,:) = [0 0.8 0];
        color(2, :) = [0.3 0.8 0.8];
        color(3,:) = [0 0 1];
    end
    h = figure('Color', [1 1 1]);
    b = bar(ax_res_plot'*1e3);
    ylabel('Axial resolution [mm]')
    %legend('Prop. PSF', 'Est. PSF', 'Sim. PSF', 'Location', 'northoutside', 'Orientation', 'horizontal')
    set(b(:,1), 'FaceColor', color(1,:));
    set(b(:,2), 'FaceColor', color(2,:));
    set(b(:,3), 'FaceColor', color(3,:));
    grid on;
    ax = gca;
    ax.XTickLabel = {'1', '2', '3', '4', '5', '6', '7', '8'};
    ax.FontSize = 16;
    set(gcf, 'PaperPositionMode', 'auto')
    %xtickangle(45);
    
    h = figure('Color', [1 1 1]);
    b=bar(lat_res_plot'*1e3);
    ylabel('Lateral resolution [mm]')
    %legend('Prop. PSF', 'Est. PSF', 'Sim. PSF', 'Location', 'northoutside', 'Orientation', 'horizontal')
    set(b(:,1), 'FaceColor', color(1,:));
    set(b(:,2), 'FaceColor', color(2,:));
    set(b(:,3), 'FaceColor', color(3,:));
    grid on;
    ax = gca;
    ax.XTickLabel = {'1', '2', '3', '4', '5', '6', '7', '8'};
    ax.FontSize = 16;
    set(gcf, 'PaperPositionMode', 'auto')
    %xtickangle(45);
end