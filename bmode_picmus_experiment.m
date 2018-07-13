% Reproduce the PICMUS experiment of Section V.B of the paper
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
list_filename_output = {'results/picmus_varying_15.mat','results/picmus_est_15.mat', 'results/picmus_constant_15.mat'; 'results/picmus_varying_13.mat','results/picmus_est_13.mat', 'results/picmus_constant_13.mat'};

%-- Parameters
flag_psf_meth = [3 2 1];
list_p = [1.5, 1.3];
maximum_iterations = 100;
flag_display = 0;
regularization_parameters = [5e-6, 4.2, 8; 2.5e-5, 1.4, 2.6];

%-- Loop to generate the B-mode images of the carotids
for kk = 1:numel(list_p)
    
    %-- Considered regularization parameters
    reg_param_kk = regularization_parameters(kk, :);
    
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
        reg_parameter = reg_param_kk(pp);
        
        %-- Experiment
        deconvolution_picmus(psf_meth, flag_display, filename_out, p, reg_parameter, maximum_iterations);

    end
  
    %-- Compute the metrics
    compute_picmus_metrics(output_filenames);

    %-- Display the lateral PSF
    display_lat_psf(output_filenames);
end
