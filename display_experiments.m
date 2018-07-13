% Example script to display the figures and tables presented in the paper:
% "Towards Fast Non-stationary Deconvolution in Ultrasound Imaging",
% submitted to IEEE Transactions on Computational imaging
% Author: Adrien Besson
% Signal Processing Laboratory 5(LTS5), EPFL
% email address: adrien.besson@epfl.ch
% January 2018

%-- Clear and close everything
clear all;
close all;
clc

addpath(genpath('utils'));
addpath(genpath('picmus'))

% User-defined parameters
flag_experiment = 5;           % Experiment to be displayed: 1=point reflectors diverging wave, 2=point reflectors plane wave, 3=PICMUS, 4=carotids, 5=evaluation times
flag_carotid = 1;              % 1=first carotid, 2=second carotid
p = 1.5;                       % Value of p used for PICMUS experiment, generate the results of Table IV for the corresponding value of p

switch flag_experiment
    case 1
        path_varying = 'results/dw_sparse_sources_varying.mat';
        path_estimated = 'results/dw_sparse_sources_est.mat';
        path_constant = 'results/dw_sparse_sources_constant.mat';
        
        %-- Display B-mode images
        display_bmode({path_varying, path_estimated, path_constant})
        
        %-- Compute the resolution
        compute_resolution_point_source_dw({path_varying, path_estimated, path_constant});
        
    case 2
        path_varying = 'results/pw_sparse_sources_varying.mat';
        path_estimated = 'results/pw_sparse_sources_est.mat';
        path_constant = 'results/pw_sparse_sources_constant.mat';
        
        %-- Display B-mode images
        display_bmode({path_varying, path_estimated, path_constant})
        
        %-- Compute the resolution
        compute_resolution_point_source_pw({path_varying, path_estimated, path_constant});
        
    case 3
        p_path = num2str(p*10);
        path_varying = strcat(['results/picmus_varying_', p_path, '.mat']);
        path_estimated = strcat(['results/picmus_est_', p_path, '.mat']);
        path_constant = strcat(['results/picmus_constant_', p_path, '.mat']);
        
        %-- Compute the metrics
        compute_picmus_metrics({path_varying, path_estimated, path_constant});
        
        %-- Display the lateral PSF
        display_lat_psf({path_varying, path_estimated, path_constant})
        
    case 4
        if flag_carotid == 1
            %-- Display B-mode images
            path_varying = 'results/trf_varying_invivo_1.3.mat';
            path_estimated = 'results/trf_est_invivo_1.3.mat';
            path_constant = 'results/trf_constant_invivo_1.3.mat';
            display_bmode({path_varying, path_estimated, path_constant})
            
            %-- Display ROI
            display_roi_carotid(path_varying);
            
            %-- Compute metrics
            compute_metrics_carotid({path_varying, path_estimated, path_constant});
            
        else
            %-- Display B-mode images
            path_varying = 'results/trf_varying_invivo_fr_1.5.mat';
            path_estimated = 'results/trf_est_invivo_fr_1.5.mat';
            path_constant = 'results/trf_constant_invivo_fr_1.5.mat';
            display_bmode({path_varying, path_estimated, path_constant})
            
            %-- Display ROI
            display_roi_carotid(path_varying);
            
            %-- Compute metrics
            compute_metrics_carotid({path_varying, path_estimated, path_constant});
        end
    case 5
        %-- Load the file
        load('results/comp_times_exp2.mat');
        
        %-- Display
        alpha = 0.5;
        color = [0 0 0.8, alpha];
        h = figure('Color', [1 1 1]);
        plot(list_grid_sizes, ratio_comp_times, '-x', 'LineWidth', 2, 'Color', color)
        grid on
        xlabel 'Grid size [-]'
        ylabel 'Ratio of Computational Times [-]'
        set(gca, 'fontsize', 16);
    otherwise
        error('Wrong value for flag_experiment');
end
