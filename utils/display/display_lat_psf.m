function display_lat_psf(filenameIn)
%-- Considered dynamic range

%-- Plot arguments
linestyle = '-';
alpha = 0.8;
color(1,:) = [0 0.8 0, alpha];
color(2, :) = [0.3 0.8 0.8, alpha];
color(3,:) = [0 0 1, alpha];
linewidth = 1.5;
fontsize = 16;

%-- Point-reflector of interest
list_reflector_pos_x = [-15/1000, 0/1000];
list_reflector_pos_z = [14.2/1000, 14.2/1000];

%-- Size of the PSF window
window_size_x = 60;
window_size_z = 60;
for ii = 1:2
    for kk = 1:numel(list_reflector_pos_x)

        %-- New figure for each point
        figure('Color', [1 1 1]);

        %-- Considered point
        reflector_pos_x = list_reflector_pos_x(kk);
        reflector_pos_z = list_reflector_pos_z(kk);

        for ll=1:numel(filenameIn)

            %-- Load the RF image
            image = us_image();
            image.read_file_mat(filenameIn{ll});
            dx_im = image.scan.dx;
            dz_im = image.scan.dz;

            %-- Compute the B-mode image
            env_rf = image.data;
            env_rf = env_rf / max(env_rf(:));
            
            %-- Indices of the reflectors
            reflector_ind_x = round((reflector_pos_x-image.scan.x_axis(1))/dx_im);
            reflector_ind_z = round((reflector_pos_z-image.scan.z_axis(1))/dz_im);

            %-- Select a window for display of the PSF
            ind_x_center = reflector_ind_x;
            ind_z_center = reflector_ind_z;
            if (ind_z_center < 0) || (ind_x_center < 0)
                continue
            end

            %-- Get the axis of interest
            ind_x_axis = (ind_x_center-window_size_x/2):(ind_x_center+window_size_x/2);
            ind_z_axis = (ind_z_center-window_size_z/2):(ind_z_center+window_size_z/2);
            x_axis = image.scan.x_axis(ind_x_axis);
            z_axis = image.scan.z_axis(ind_z_axis);

            %-- Get the signal of interest
            sig = env_rf(ind_z_axis,ind_x_axis);
            [~, ind_max] = max(sig(:));
            [i_z, i_x] = ind2sub(size(sig), ind_max);
            sig_z = sig(:,i_x);
            sig_x = sig(i_z,:);
            
            if ii == 1
                %-- Interpolate the signal
                interp_factor = 10;
                x_up = linspace(x_axis(1), x_axis(end), interp_factor*numel(x_axis));
                sig_x_interp = interp1(x_axis, sig_x, x_up, 'pchip', 0);

                %-- Normalization
                sig_x_interp = sig_x_interp/max(sig_x_interp(:));

                %-- Plot the lateral resolution
                plot(x_up*1000, sig_x_interp,'LineStyle', linestyle, 'Color', color(ll,:), 'LineWidth', linewidth)
                xlim([reflector_pos_x*1000-2, reflector_pos_x*1000 + 2])
                xlabel 'Lateral Dimension [mm]'
                grid on
                hold on
            else
                %-- Interpolate the signal
                interp_factor = 10;
                z_up = linspace(z_axis(1), z_axis(end), interp_factor*numel(z_axis));
                sig_z_interp = interp1(z_axis, sig_z, z_up, 'pchip', 0);

                %-- Normalization
                sig_z_interp = sig_z_interp/max(sig_z_interp(:));

                %-- Plot the lateral resolution
                plot(z_up*1000, sig_z_interp, 'LineStyle', linestyle, 'Color', color(ll,:), 'LineWidth', linewidth)
                xlim([reflector_pos_z*1000-2, reflector_pos_z*1000 + 2])
                xlabel 'Depth [mm]'
                grid on
                hold on
            end
        end
        legend('proposed', 'estimated', 'simulated', 'location', 'northwest');
        set(gca, 'fontsize', fontsize);
%         if contains(filenameIn{1}, '15')
%             suffix = '15';
%         else
%             suffix = '13';
%         end
%             if ii == 1
%                 out_filename = 'results/lateral_resolution';
%             else
%                 out_filename = 'results/axial_resolution';
%             end
%         out_filename = strcat([out_filename,  '_', suffix, '_', num2str(kk), '.pdf']);
%         export_fig(out_filename);
    end

end