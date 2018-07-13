% Reproduce the experiments on computational times of Section V.D of the paper
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

%-- Output filenames
filename_out = 'results/comp_times_exp1.mat';

%-- PSF method
list_flag_psf_meth = [2, 3, 4];

%-- Parameters
central_freq = 5.208e6;
sampling_freq = 4*central_freq;
c0 = 1540;
wavelength = c0 / central_freq;
pitch = wavelength;
n_elements = 128;
nt = 100;
list_n_z = [1, 2]*nt;
list_n_x = [0.5, 1, 2]*n_elements;

%-- Number of runs of evaluation
n_runs = 11;

% Pulse shape
pulse_support = 33;
pulse = randn(1, pulse_support);
pulse = pulse - mean(pulse);
pulse = pulse / max(abs(pulse));
t_pulse = (0:numel(pulse)-1)'/pulse_support;

%-- Output variables
t_fwd_proposed = zeros(n_runs, numel(list_n_z) ,numel(list_n_x));
t_fwd_roquette = zeros(n_runs, numel(list_n_z) ,numel(list_n_x));
t_fwd_shiftinvariant = zeros(n_runs, numel(list_n_z) ,numel(list_n_x));

%-- Loop to generate the B-mode images of the carotids
for jj = 1:n_runs
    disp(['*************** Evaluation run ', num2str(jj), ' over ', num2str(n_runs), ' ***************']);
    
    %-- Fix the seed number
    rng(jj);
    
    for kk = 1:numel(list_n_z)
        %-- Number of pixels in the depth
        nz = list_n_z(kk);
        
        for ll = 1:numel(list_n_x)
            
            %-- Number of pixels in the lateral dimension
            nx = list_n_x(ll);
            
            % Rawdata grid
            G_param.x = (0:n_elements-1)*pitch;
            G_param.x = G_param.x - G_param.x(end/2);
            G_param.t = (1:nt)/sampling_freq;
            G_param.z = G_param.t*c0/2;
            
            % Image grid
            G_param.lambda = wavelength;
            G_param.z_im = (0:nz-1)*G_param.lambda / 8;
            G_param.x_im = (0:nx-1)*G_param.lambda / 3;
            L = [nz, nx];
            
            %-- MISC parameters
            G_param.c = c0;
            G_param.el_width = pitch;
            
            %-- RF image
            rfdata = randn(nz, nx);
            
            %-- Loop over different blur evaluation strategies
            for uu = 1:numel(list_flag_psf_meth)
                flag_psf_meth = list_flag_psf_meth(uu);
                
                %-- Build the oprator
                if flag_psf_meth == 1
                    % Load the prestored PSF
                    load 'data/rf_psf_pw.mat';
                    
                    % Shift the PSF to center it
                    psf = circshift(psf, [-3 1]);
                    
                    % Generate the PSF operator
                    F = generate_stationary_psf_operator(psf, L);
                    
                elseif flag_psf_meth == 2
                    % Load the estimated PSF
                    load 'data/psf_pw_est_sparse.mat';
                    
                    % Generate the PSF operator
                    F = generate_stationary_psf_operator(psf_est, L);
                    
                elseif flag_psf_meth == 3
                    
                    
                    % Generate the proposed PSF operator
                    F = generate_proposed_mf_psf_operator(G_param, pulse);
                else
                    G_param.pulse = pulse;
                    G_param.t_pulse = t_pulse;
                    F.forward = @(x) psf_operator_roquette_forward(G_param, x);
                end
                
                %-- Evaluation
                tic;
                F.forward(rfdata);
                t_eval = toc;
                if flag_psf_meth == 2
                    t_fwd_shiftinvariant(jj, kk, ll) = t_eval;
                elseif flag_psf_meth == 3
                    t_fwd_proposed(jj, kk, ll) = t_eval;
                else
                    t_fwd_roquette(jj, kk, ll) = t_eval;
                end
            end
            
        end
    end
end

%-- Average time
t_avg_proposed = squeeze(mean(t_fwd_proposed));
t_avg_shiftinvariant = squeeze(mean(t_fwd_shiftinvariant));
t_avg_roquette = squeeze(mean(t_fwd_roquette));

%-- Save the workspace
save(filename_out);