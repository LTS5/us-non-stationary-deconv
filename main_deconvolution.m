% Example script to run the deconvolution methods described in the paper: 
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

flag_experiment = 3;        % 1=point source diverging wave, 2=point source plane wave, 3=picmus phantom, 4=in vivo carotid
flag_psf_meth = 1;          % 1=simulated PSF, 2=estimated PSF, 3=proposed method
flag_display = 1;           % 1=display the RF image and TRF image, 0=no display
filename_out = '';          % if empty, the results are not saved
flag_carotid = 2;           % 1=first carotid, 2=second carotid
p = 1;                      % p-norm used in the regularization (default=1)
maximum_iterations = 1e6;   % maximum number of iterations of the lp-based deconvolution algorithm
lambda = 2900;               % regularization parameter - Values used in the paper
                            % 1) point source DW: lambda=1 for simulated PSF, lambda=60 for estimated PSF, lambda=2900 for proposed method 
                            % 2) point source PW: lambda=2.5 for simulated PSF, lambda=1.5 for estimated PSF, lambda=0.01 for proposed method 
                            % 3) picmus:
                            %   a) p=1.5: lambda=0.5 for simulated PSF, lambda=0.8 for estimated PSF, lambda=3e-4 for proposed method
                            %   b) p=1.3: lambda=0.1 for simulated PSF, lambda=0.1 for estimated PSF, lambda=3e-5 for proposed method
                            % 4) carotid:
                            %   a) first carotid:
                            %        i) p=1.5: lambda=70 for simulated PSF, lambda=70 for estimated PSF, lambda=1e-2 for proposed method
                            %        ii) p=1.3: lambda=70 for simulated PSF, lambda=70 for estimated PSF, lambda=1e-2 for proposed method
                            %   b) second carotid:
                            %        i) p=1.5: lambda=20 for simulated PSF, lambda=20 for estimated PSF, lambda=1e-2 for proposed method
                            %        ii) p=1.3: lambda=30 for simulated PSF, lambda=30 for estimated PSF, lambda=5e-3 for proposed method

switch (flag_experiment)
    case 1
        deconvolution_point_source_dw(flag_psf_meth, flag_display, filename_out, p, lambda, maximum_iterations);
    case 2
        deconvolution_point_source_pw(flag_psf_meth, flag_display, filename_out, p, lambda, maximum_iterations);
    case 3
        deconvolution_picmus(flag_psf_meth, flag_display, filename_out, p, lambda, maximum_iterations);
    case 4 
        deconvolution_carotid(flag_carotid, flag_psf_meth, flag_display, filename_out, p, lambda, maximum_iterations);
    otherwise
        error('Wrong value for flag_experiment');
end
        