function F = generate_proposed_psf_operator_dw(G_param, pulse)
disp('******* Build the proposed PSF operator *******')

% PSF operator
F.forward  = @(z) das_dw_forward(G_param, propagation_operator_dw_forward(G_param, z, pulse'));
F.adjoint = @(z) propagation_operator_dw_adjoint(G_param, das_dw_adjoint(G_param, z), pulse');

end