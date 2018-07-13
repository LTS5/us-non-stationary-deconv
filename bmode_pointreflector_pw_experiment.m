% Reproduce the plane wave point-source experiment of Section V.A of the paper
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
list_filename_output = {'results/pw_sparse_sources_varying.mat', 'results/pw_sparse_sources_est.mat', 'results/pw_sparse_sources_constant.mat'};

%-- Parameters
flag_psf_meth = [3, 2, 1];
p = 1;
maximum_iterations = 100;
flag_display = 0;
regularization_parameters = [0.09, 150, 250];

for pp = 1:numel(flag_psf_meth)
    %-- Current PSF method
    psf_meth = flag_psf_meth(pp);
    
    %-- Current output filename
    filename_out = list_filename_output{pp};
    
    %-- Current regularization parameter
    reg_parameter = regularization_parameters(pp);
    
    %-- Experiment
    deconvolution_point_source_pw(psf_meth, flag_display, filename_out, p, reg_parameter, maximum_iterations);
end

%-- Display B-mode images
display_bmode(list_filename_output)

%-- Compute the resolution
compute_resolution_point_source_pw(list_filename_output);

