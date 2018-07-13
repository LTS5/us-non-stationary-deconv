function res = lp_deconvolution(p, lambda, maximum_iterations, rf, F, gamma)
%-- Parameters
data.y = rf;
data.H = F;
param.mu = lambda;
disp('******* Calculate the norm of the PSF operator *******')
if or(nargin == 5, isempty(gamma))
    param.gamma = 1/pow_method(F.forward, F.adjoint, size(rf), 1e-4, 1000, 1);
else
    param.gamma = gamma;
end
param.imsize = size(rf);
param.p = p;
param.tol = 1e-3;
param.iterMax = maximum_iterations;

%-- Deconvolution
disp('******* lp-deconvolution of the RF image *******')
res = Dec_lp_FISTA(data,param);