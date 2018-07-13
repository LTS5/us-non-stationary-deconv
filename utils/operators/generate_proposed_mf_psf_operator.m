function F = generate_proposed_mf_psf_operator(G_param, pulse)
disp('******* Build the proposed PSF operator *******')

% PSF operator
F.forward  = @(z) das_forward(G_param, propagation_operator_forward(G_param, z, pulse'));
F.adjoint = @(z) propagation_operator_adjoint(G_param, das_adjoint(G_param, z), pulse');
end