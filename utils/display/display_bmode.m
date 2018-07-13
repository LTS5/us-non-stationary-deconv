function display_bmode(filename_list, dBRange)
if nargin < 2
    dBRange = 40;
end
title_list = {'TRF - proposed PSF', 'TRF - simulated PSF', 'TRF - estimated PSF'};
for i = 1:numel(filename_list)
    %-- Title of the plot
    if contains(filename_list{i}, 'varying')
        ttl = title_list{1};
    elseif contains(filename_list{i}, 'est')
        ttl = title_list{3};
    else
        ttl = title_list{2};
    end
    
    %-- TRF image
    if contains(filename_list{i}, 'picmus')
        image = us_image();
        image.read_file(filename_list{i})
        env_trf = image.data;
        x = image.scan.x;
        z = image.scan.z;
    else
        load(filename_list{i})
        env_trf = abs(hilbert(trf_rec));
        x = G_param.x_im;
        z = G_param.z_im;
    end
    
    % Log compression
    bmode_trf = 20*log10(env_trf / max(env_trf(:)));
    
    % Display
    h = plot_bmode(x, z, bmode_trf, dBRange);
    %title(ttl)
end
end