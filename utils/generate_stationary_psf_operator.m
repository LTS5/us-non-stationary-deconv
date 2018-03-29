function F = generate_stationary_psf_operator(psf, L)
    disp('******* Build the PSF operator *******')
    % Normalization of the PSF
    psf = psf ./max(abs(psf(:)));
    
    % Fourier domain expression
    [lh1, lh2] = size(psf);
    PSF=[psf zeros(size(psf,1),L(2)-size(psf,2)) ;...
        zeros(L(1)-size(psf,1), L(2))];
    PSF = circshift(PSF,[-floor(lh1/2),-floor(lh2/2)]); % -2 comes to align exactly the recovered image
    H = fft2(PSF);
    
    % Function handle for the model
    F.forward  = @(z) real(ifft2(fft2(z).*H));
    F.adjoint = @(z) real(ifft2(conj(H).*fft2(z)));
end