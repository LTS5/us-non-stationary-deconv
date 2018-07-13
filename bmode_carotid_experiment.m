% Reproduce the carotid experiments of Section V.C of the paper
% "Non-stationary Blur Evaluation for Ultrasound Image Restoration",
% submitted to IEEE Transactions on Computational imaging
% Author: Adrien Besson
% Signal Processing Laboratory 5 (LTS5), EPFL
% email address: adrien.besson@epfl.ch
% July 2018
clear all;
close all;
clc

%-- Add path
addpath(genpath('utils'));

%-- Output filename 
list_filename_output = {'results/trf_varying_invivo_fr_1.5.mat','results/trf_est_invivo_fr_1.5.mat', 'results/trf_constant_invivo_fr_1.5.mat'; 'results/trf_varying_invivo_1.3.mat','results/trf_est_invivo_1.3.mat', 'results/trf_constant_invivo_1.3.mat'};

%-- Parameters
flag_carotid_list = [2 1];
flag_psf_meth = [3, 2, 1];
list_p = [1.5, 1.3];
maximum_iterations = 100;
flag_display = 0;
regularization_parameters = [5e-3, 700, 700; 3e-2, 700, 1500];

%-- Loop to generate the B-mode images of the carotids
for kk = 1:numel(flag_carotid_list)
    
    %-- Considered carotid experiment
    flag_carotid = flag_carotid_list(kk);
    
    %-- Considered regularization parameters
    reg_param_caro = regularization_parameters(kk, :);
    
    %-- Considered value of p
    p = list_p(kk);
    
    %-- Considered output filenames
    output_filenames = list_filename_output(kk, :);
    
    for pp = 1:numel(flag_psf_meth)
        %-- Current PSF method
        psf_meth = flag_psf_meth(pp);
        
        %-- Current output filename
        filename_out = output_filenames{pp};
        
        %-- Current regularization parameter
        reg_parameter = reg_param_caro(pp);
        
        %-- Experiment
        deconvolution_carotid(flag_carotid, psf_meth, 0, filename_out, p, reg_parameter, maximum_iterations);

    end
    
    %-- Display B-mode images
    display_bmode(output_filenames)
            
    %-- Compute metrics
    compute_metrics_carotid(output_filenames);
end
