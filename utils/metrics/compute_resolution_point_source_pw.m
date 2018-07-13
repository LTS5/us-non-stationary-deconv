function compute_resolution_point_source_pw(filenameIn)
reflector_pos_x = [0; 0; -15; -7.5; 0; 7.5; 15; 0]/1000;
reflector_pos_z = [10 ; 20; 30*ones(5,1); 40]/1000;

format = '.mat';

for ll=1:numel(filenameIn)
    
    %-- Load the RF image
    load(filenameIn{ll})
    dx_im = G_param.x_im(2) - G_param.x_im(1);
    dz_im = G_param.z_im(2) - G_param.z_im(1);
    
    %-- Compute the B-mode image
    env_rf = abs(trf_rec);
    bmode_rf_c = env_rf;
    
    %-- Indices of the reflectors
    reflector_ind_x = round((reflector_pos_x-G_param.x_im(1))/dx_im);
    reflector_ind_z = round((reflector_pos_z-G_param.z_im(1))/dz_im);

    %-- Output variables
    ax_res = [];
    lat_res = [];
    for kk = 1:numel(reflector_ind_x)
        %-- Select a window for calculation of FWHM
        ind_x_center = reflector_ind_x(kk);
        ind_z_center = reflector_ind_z(kk);
        if (ind_z_center < 0) || (ind_x_center < 0)
            continue
        end

        %-- Get the axis of interest
        window_size_x = 50;
        window_size_z = 50;
        ind_x_axis = (ind_x_center-window_size_x/2):(ind_x_center+window_size_x/2);
        ind_z_axis = (ind_z_center-window_size_z/2):(ind_z_center+window_size_z/2);
        x_axis = G_param.x_im(ind_x_axis);
        z_axis = G_param.z_im(ind_z_axis);

        %-- Get the signal of interest
        sig = bmode_rf_c(ind_z_axis,ind_x_axis);
        [~, ind_max] = max(sig(:));
        [i_z, i_x] = ind2sub(size(sig), ind_max);
        sig_z = sig(:,i_x);
        sig_x = sig(i_z,:);

        %-- Lateral resolution
        coeff = 10;
        nb_sample = length(x_axis);
        nb_interp = nb_sample * coeff;
        x_interp = linspace(x_axis(1),x_axis(end),nb_interp);
        sig_interp = interp1(x_axis,sig_x,x_interp, 'spline', 0);

        ind = find(sig_interp >= (max(sig_interp)/2) );
        idx1 = min(ind);
        idx2 = max(ind);
        lat_res = [lat_res, x_interp(idx2) - x_interp(idx1)];

        %-- Axial resolution
        coeff = 10;
        nb_sample = length(z_axis);
        nb_interp = nb_sample * coeff;
        z_interp = linspace(z_axis(1),z_axis(end),nb_interp);
        sig_interp = interp1(z_axis,sig_z,z_interp,'spline',0);

        ind = find(sig_interp >= (max(sig_interp)/2) );
        idx1 = min(ind);
        idx2 = max(ind);
        ax_res = [ax_res, z_interp(idx2) - z_interp(idx1)];
    end
    filename = strsplit(filenameIn{ll}, '.');
    filename_out = strcat(filename{1}, '_metrics', format);
    save(filename_out, 'ax_res', 'lat_res', 'G_param');
end
