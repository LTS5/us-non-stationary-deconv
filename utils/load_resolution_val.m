function [a_res_var_14, a_res_var_45, l_res_var_14, l_res_var_45, a_res_cst_14, a_res_cst_45, l_res_cst_14, l_res_cst_45, a_res_est_14, a_res_est_45, l_res_est_14, l_res_est_45, list_contrast] =load_resolution_val(p)

if p == 1.3
    list_contrast = 6.20:-0.2:5.40;
    % %-- Proposed PSF -- CNR = 6.20 dB -- p=1.3
        filename_in = 'results/varying_trf_numerical_1.3_9e-05_metrics.mat';
        load(filename_in);
        a_res_var_14(1,:) = mean(resolution(1:5,1));
        a_res_var_45(1,:) = mean(resolution(6:10,1));
        l_res_var_14(1,:) = mean(resolution(1:5,2));
        l_res_var_45(1,:) = mean(resolution(6:10,2));
        
        %-- Simulated PSF -- CNR = 6.20 dB -- p=1.3
        filename_in = 'results/constant_trf_numerical_1.3_0.145_metrics.mat';
        load(filename_in);
        a_res_cst_14(1,:) = mean(resolution(1:5,1));
        a_res_cst_45(1,:) = mean(resolution(6:10,1));
        l_res_cst_14(1,:) = mean(resolution(1:5,2));
        l_res_cst_45(1,:) = mean(resolution(6:10,2));
        
        %-- Estimated PSF -- CNR = 6.20 dB -- p=1.3
        filename_in = 'results/estimated_trf_numerical_1.3_0.135_metrics.mat';
        load(filename_in);
        a_res_est_14(1,:) = mean(resolution(1:5,1));
        a_res_est_45(1,:) = mean(resolution(6:10,1));
        l_res_est_14(1,:) = mean(resolution(1:5,2));
        l_res_est_45(1,:) = mean(resolution(6:10,2));
        
        %-- Proposed PSF -- CNR = 6.00 dB -- p=1.3
        filename_in = 'results/varying_trf_numerical_1.3_5e-05_metrics.mat';
        load(filename_in);
        a_res_var_14(2,:) = mean(resolution(1:5,1));
        a_res_var_45(2,:) = mean(resolution(6:10,1));
        l_res_var_14(2,:) = mean(resolution(1:5,2));
        l_res_var_45(2,:) = mean(resolution(6:10,2));
        
        %-- Simulated PSF -- CNR = 6.00 dB -- p=1.3
        filename_in = 'results/constant_trf_numerical_1.3_0.135_metrics.mat';
        load(filename_in);
        a_res_cst_14(2,:) = mean(resolution(1:5,1));
        a_res_cst_45(2,:) = mean(resolution(6:10,1));
        l_res_cst_14(2,:) = mean(resolution(1:5,2));
        l_res_cst_45(2,:) = mean(resolution(6:10,2));
        
        %-- Estimated PSF -- CNR = 6.00 dB -- p=1.3
        filename_in = 'results/estimated_trf_numerical_1.3_0.12_metrics.mat';
        load(filename_in);
        a_res_est_14(2,:) = mean(resolution(1:5,1));
        a_res_est_45(2,:) = mean(resolution(6:10,1));
        l_res_est_14(2,:) = mean(resolution(1:5,2));
        l_res_est_45(2,:) = mean(resolution(6:10,2));
        
        %-- Proposed PSF -- CNR = 5.80 dB -- p=1.3
        filename_in = 'results/varying_trf_numerical_1.3_1.29e-05_metrics.mat';
        load(filename_in);
        a_res_var_14(3,:) = mean(resolution(1:5,1));
        a_res_var_45(3,:) = mean(resolution(6:10,1));
        l_res_var_14(3,:) = mean(resolution(1:5,2));
        l_res_var_45(3,:) = mean(resolution(6:10,2));
        
        % %-- Simulated PSF -- CNR = 5.80 dB -- p=1.3
        filename_in = 'results/constant_trf_numerical_1.3_0.125_metrics.mat';
        load(filename_in);
        a_res_cst_14(3,:) = mean(resolution(1:5,1));
        a_res_cst_45(3,:) = mean(resolution(6:10,1));
        l_res_cst_14(3,:) = mean(resolution(1:5,2));
        l_res_cst_45(3,:) = mean(resolution(6:10,2));
        
        %-- Estimated PSF -- CNR = 5.80 dB -- p=1.3
        filename_in = 'results/estimated_trf_numerical_1.3_0.11_metrics.mat';
        load(filename_in);
        a_res_est_14(3,:) = mean(resolution(1:5,1));
        a_res_est_45(3,:) = mean(resolution(6:10,1));
        l_res_est_14(3,:) = mean(resolution(1:5,2));
        l_res_est_45(3,:) = mean(resolution(6:10,2));
        
        %-- Proposed PSF -- CNR = 5.60 dB -- p=1.3
        filename_in = 'results/varying_trf_numerical_1.3_6e-06_metrics.mat';
        load(filename_in);
        a_res_var_14(4,:) = mean(resolution(1:5,1));
        a_res_var_45(4,:) = mean(resolution(6:10,1));
        l_res_var_14(4,:) = mean(resolution(1:5,2));
        l_res_var_45(4,:) = mean(resolution(6:10,2));
        
        %-- Simulated PSF -- CNR = 5.60 dB -- p=1.3
        filename_in = 'results/constant_trf_numerical_1.3_0.115_metrics.mat';
        load(filename_in);
        a_res_cst_14(4,:) = mean(resolution(1:5,1));
        a_res_cst_45(4,:) = mean(resolution(6:10,1));
        l_res_cst_14(4,:) = mean(resolution(1:5,2));
        l_res_cst_45(4,:) = mean(resolution(6:10,2));
        
        %-- Estimated PSF -- CNR = 5.60 dB -- p=1.3
        filename_in = 'results/estimated_trf_numerical_1.3_0.1025_metrics.mat';
        load(filename_in);
        a_res_est_14(4,:) = mean(resolution(1:5,1));
        a_res_est_45(4,:) = mean(resolution(6:10,1));
        l_res_est_14(4,:) = mean(resolution(1:5,2));
        l_res_est_45(4,:) = mean(resolution(6:10,2));
        
        %-- Proposed PSF -- CNR = 5.40 dB -- p=1.3
        filename_in = 'results/varying_trf_numerical_1.3_3e-06_metrics.mat';
        load(filename_in);
        a_res_var_14(5,:) = mean(resolution(1:5,1));
        a_res_var_45(5,:) = mean(resolution(6:10,1));
        l_res_var_14(5,:) = mean(resolution(1:5,2));
        l_res_var_45(5,:) = mean(resolution(6:10,2));
        
        %-- Simulated PSF -- CNR = 5.40 dB -- p=1.3
        filename_in = 'results/constant_trf_numerical_1.3_0.105_metrics.mat';
        load(filename_in);
        a_res_cst_14(5,:) = mean(resolution(1:5,1));
        a_res_cst_45(5,:) = mean(resolution(6:10,1));
        l_res_cst_14(5,:) = mean(resolution(1:5,2));
        l_res_cst_45(5,:) = mean(resolution(6:10,2));
        
        %-- Estimated PSF -- CNR = 5.40 dB -- p=1.3
        filename_in = 'results/estimated_trf_numerical_1.3_0.095_metrics.mat';
        load(filename_in);
        a_res_est_14(5,:) = mean(resolution(1:5,1));
        a_res_est_45(5,:) = mean(resolution(6:10,1));
        l_res_est_14(5,:) = mean(resolution(1:5,2));
        l_res_est_45(5,:) = mean(resolution(6:10,2));
else
        list_contrast = 6.80:-0.2:6.00;
        %-- Proposed PSF -- CNR = 6.80 dB -- p=1.5
        filename_in = 'results/varying_trf_numerical_1.5_6e-06_metrics.mat';
        load(filename_in);
        a_res_var_14(1,:) = mean(resolution(1:5,1));
        a_res_var_45(1,:) = mean(resolution(6:10,1));
        l_res_var_14(1,:) = mean(resolution(1:5,2));
        l_res_var_45(1,:) = mean(resolution(6:10,2));
        
        %-- Simulated PSF -- CNR = 6.80 dB -- p=1.5
        filename_in = 'results/constant_trf_numerical_1.5_0.9_metrics.mat';
        load(filename_in);
        a_res_cst_14(1,:) = mean(resolution(1:5,1));
        a_res_cst_45(1,:) = mean(resolution(6:10,1));
        l_res_cst_14(1,:) = mean(resolution(1:5,2));
        l_res_cst_45(1,:) = mean(resolution(6:10,2));
        
        %-- Estimated PSF -- CNR = 6.80 dB -- p=1.5
        filename_in = 'results/estimated_trf_numerical_1.5_0.9_metrics.mat';
        load(filename_in);
        a_res_est_14(1,:) = mean(resolution(1:5,1));
        a_res_est_45(1,:) = mean(resolution(6:10,1));
        l_res_est_14(1,:) = mean(resolution(1:5,2));
        l_res_est_45(1,:) = mean(resolution(6:10,2));
        
        %-- Proposed PSF -- CNR = 6.60 dB -- p=1.5
        filename_in = 'results/varying_trf_numerical_1.5_9e-06_metrics.mat';
        load(filename_in);
        a_res_var_14(2,:) = mean(resolution(1:5,1));
        a_res_var_45(2,:) = mean(resolution(6:10,1));
        l_res_var_14(2,:) = mean(resolution(1:5,2));
        l_res_var_45(2,:) = mean(resolution(6:10,2));
        
        %-- Simulated PSF -- CNR = 6.60 dB -- p=1.5
        filename_in = 'results/constant_trf_numerical_1.5_0.82_metrics.mat';
        load(filename_in);
        a_res_cst_14(2,:) = mean(resolution(1:5,1));
        a_res_cst_45(2,:) = mean(resolution(6:10,1));
        l_res_cst_14(2,:) = mean(resolution(1:5,2));
        l_res_cst_45(2,:) = mean(resolution(6:10,2));
        
        %-- Estimated PSF -- CNR = 6.60 dB -- p=1.5
        filename_in = 'results/estimated_trf_numerical_1.5_0.8_metrics.mat';
        load(filename_in);
        a_res_est_14(2,:) = mean(resolution(1:5,1));
        a_res_est_45(2,:) = mean(resolution(6:10,1));
        l_res_est_14(2,:) = mean(resolution(1:5,2));
        l_res_est_45(2,:) = mean(resolution(6:10,2));
        
        %-- Proposed PSF -- CNR = 6.40 dB -- p=1.5
        filename_in = 'results/varying_trf_numerical_1.5_1.25e-05_metrics.mat';
        load(filename_in);
        a_res_var_14(3,:) = mean(resolution(1:5,1));
        a_res_var_45(3,:) = mean(resolution(6:10,1));
        l_res_var_14(3,:) = mean(resolution(1:5,2));
        l_res_var_45(3,:) = mean(resolution(6:10,2));
        
        %-- Simulated PSF -- CNR = 6.40 dB -- p=1.5
        filename_in = 'results/constant_trf_numerical_1.5_0.75_metrics.mat';
        load(filename_in);
        a_res_cst_14(3,:) = mean(resolution(1:5,1));
        a_res_cst_45(3,:) = mean(resolution(6:10,1));
        l_res_cst_14(3,:) = mean(resolution(1:5,2));
        l_res_cst_45(3,:) = mean(resolution(6:10,2));
        
        %-- Estimated PSF -- CNR = 6.40 dB -- p=1.5
        filename_in = 'results/estimated_trf_numerical_1.5_0.7_metrics.mat';
        load(filename_in);
        a_res_est_14(3,:) = mean(resolution(1:5,1));
        a_res_est_45(3,:) = mean(resolution(6:10,1));
        l_res_est_14(3,:) = mean(resolution(1:5,2));
        l_res_est_45(3,:) = mean(resolution(6:10,2));
        
        %-- Proposed PSF -- CNR = 6.20 dB -- p=1.5
        filename_in = 'results/varying_trf_numerical_1.5_1.25e-05_metrics.mat';
        load(filename_in);
        a_res_var_14(4,:) = mean(resolution(1:5,1));
        a_res_var_45(4,:) = mean(resolution(6:10,1));
        l_res_var_14(4,:) = mean(resolution(1:5,2));
        l_res_var_45(4,:) = mean(resolution(6:10,2));
        
        %-- Simulated PSF -- CNR = 6.20 dB -- p=1.5
        filename_in = 'results/constant_trf_numerical_1.5_0.675_metrics.mat';
        load(filename_in);
        a_res_cst_14(4,:) = mean(resolution(1:5,1));
        a_res_cst_45(4,:) = mean(resolution(6:10,1));
        l_res_cst_14(4,:) = mean(resolution(1:5,2));
        l_res_cst_45(4,:) = mean(resolution(6:10,2));
        
        %-- Estimated PSF -- CNR = 6.20 dB -- p=1.5
        filename_in = 'results/estimated_trf_numerical_1.5_0.6_metrics.mat';
        load(filename_in);
        a_res_est_14(4,:) = mean(resolution(1:5,1));
        a_res_est_45(4,:) = mean(resolution(6:10,1));
        l_res_est_14(4,:) = mean(resolution(1:5,2));
        l_res_est_45(4,:) = mean(resolution(6:10,2));
        
        %-- Proposed PSF -- CNR = 6.00 dB -- p=1.5
        filename_in = 'results/varying_trf_numerical_1.5_5e-05_metrics.mat';
        load(filename_in);
        a_res_var_14(5,:) = mean(resolution(1:5,1));
        a_res_var_45(5,:) = mean(resolution(6:10,1));
        l_res_var_14(5,:) = mean(resolution(1:5,2));
        l_res_var_45(5,:) = mean(resolution(6:10,2));
        
        %-- Simulated PSF -- CNR = 6.00 dB -- p=1.5
        filename_in = 'results/constant_trf_numerical_1.5_0.6_metrics.mat';
        load(filename_in);
        a_res_cst_14(5,:) = mean(resolution(1:5,1));
        a_res_cst_45(5,:) = mean(resolution(6:10,1));
        l_res_cst_14(5,:) = mean(resolution(1:5,2));
        l_res_cst_45(5,:) = mean(resolution(6:10,2));
        
        %-- Estimated PSF -- CNR = 6.00 dB -- p=1.5
        filename_in = 'results/estimated_trf_numerical_1.5_0.55_metrics.mat';
        load(filename_in);
        a_res_est_14(5,:) = mean(resolution(1:5,1));
        a_res_est_45(5,:) = mean(resolution(6:10,1));
        l_res_est_14(5,:) = mean(resolution(1:5,2));
        l_res_est_45(5,:) = mean(resolution(6:10,2));
end