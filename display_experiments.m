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
flag_experiment = 2;           % Experiment to be displayed: 1=point reflectors diverging wave, 2=point reflectors plane wave, 3=PICMUS, 4=carotids
flag_carotid = 1;              % 1=first carotid, 2=second carotid
p = 1.5;                       % Value of p used for PICMUS experiment, generate the results of Table IV for the corresponding value of p


switch flag_experiment 
    case 1
        path_rf = 'results/dw_sparse_sources_varying.mat';
        path_varying = 'results/dw_sparse_sources_varying.mat';
        path_estimated = 'results/dw_sparse_sources_est.mat';
        path_constant = 'results/dw_sparse_sources_constant.mat';

        %-- Display B-mode images
        display_bmode(path_rf, path_varying, path_estimated, path_constant)

        %-- Display bar plots for resolution
        flag_color = 2;
        path_varying = 'results/dw_sparse_sources_varying_metrics.mat';
        path_estimated = 'results/dw_sparse_sources_est_metrics.mat';
        path_constant = 'results/dw_sparse_sources_constant_metrics.mat';
        display_barplots(path_varying, path_estimated, path_constant, flag_color)
    
    case 2
        %-- Display B-mode images
        path_rf = 'results/pw_sparse_sources_varying.mat';
        path_varying = 'results/pw_sparse_sources_varying.mat';
        path_estimated = 'results/pw_sparse_sources_est.mat';
        path_constant = 'results/pw_sparse_sources_constant.mat';
        display_bmode(path_rf, path_varying, path_estimated, path_constant)

        %-- Display bar plots for resolution
        flag_color = 2;
        path_varying = 'results/pw_sparse_sources_varying_metrics.mat';
        path_estimated = 'results/pw_sparse_sources_est_metrics.mat';
        path_constant = 'results/pw_sparse_sources_constant_metrics.mat';
        display_barplots(path_varying, path_estimated, path_constant, flag_color)
    
    case 3
    %-- Load the values of the resolution
    [a_res_var_14, a_res_var_45, l_res_var_14, l_res_var_45, a_res_cst_14, a_res_cst_45, l_res_cst_14, l_res_cst_45, a_res_est_14, a_res_est_45, l_res_est_14, l_res_est_45, list_contrast] =load_resolution_val(p)

    case 4
        if flag_carotid == 1
            %-- Display B-mode images
            path_rf = 'results/rf_image_invivo.mat';
            path_varying = 'results/trf_varying_invivo_1.3.mat';
            path_estimated = 'results/trf_est_invivo_1.3.mat';
            path_constant = 'results/trf_constant_invivo_1.3.mat';
            display_bmode(path_rf, path_varying, path_estimated, path_constant)
        else
            %-- Display B-mode images
            path_rf = 'results/rf_image_invivo_fr.mat';
            path_varying = 'results/trf_varying_invivo_fr_1.5.mat';
            path_estimated = 'results/trf_est_invivo_fr_1.5.mat';
            path_constant = 'results/trf_constant_invivo_fr_1.5.mat';
            display_bmode(path_rf, path_varying, path_estimated, path_constant)
        end
        
    otherwise
        error('Wrong value for flag_experiment');
end
