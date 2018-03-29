function F = generate_proposed_psf_operator(G_param, H_das, K_h)    
    % Forward model
    disp('******* Build the US propagation operator *******')
    disp('It may take a long time (several minutes)')
    H_fwd = BuildH_PW(G_param);
    
    % PSF operator
    disp('******* Build the PSF operator *******')
    F.forward  = @(z) reshape(H_das*reshape(K_h*reshape(H_fwd*z(:), [numel(G_param.z), numel(G_param.x)]), [numel(G_param.z)*numel(G_param.x), 1]), [numel(G_param.z_im), numel(G_param.x_im)]);
    F.adjoint = @(z) reshape(H_fwd'*reshape(K_h'*reshape(H_das'*z(:), [numel(G_param.z), numel(G_param.x)]), [numel(G_param.z)*numel(G_param.x), 1]), [numel(G_param.z_im), numel(G_param.x_im)]);
 
end