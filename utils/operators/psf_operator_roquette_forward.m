function trf = psf_operator_roquette_forward(G_param, rf_data)

%-- Parameters
el_width = G_param.el_width;
lambda = G_param.lambda;
pulse = G_param.pulse;
t_pulse = G_param.t_pulse;
c = G_param.c;

%-- Transducer locations
x = G_param.x;

%-- Image grid
xim = G_param.x_im;
zim = G_param.z_im;
[Xim, Zim] = meshgrid(xim, zim);
xim_flatten = Xim(:);
zim_flatten = Zim(:);

%-- Output variable
trf = zeros(size(xim_flatten));
rf_data_flatten = rf_data(:);

%-- Evaluation
parfor pp = 1:numel(x)
    
    %-- Considered transducer element
    x_pp = x(pp);
    
    %-- Receive distance
    dist_rx_r = sqrt(zim_flatten.^2 + (xim_flatten-x_pp).^2);
    
    %-- Transmit distance
    dist_tx_r = zim_flatten;
    
    %-- TX-RX distance
    dist_txrx_r = dist_rx_r + dist_tx_r;
    
    %-- Directivity
    directivity_r = zim_flatten./(dist_rx_r+eps) .* sinc(el_width / lambda .*(x_pp-xim_flatten) ./(dist_rx_r+eps));
    
    %-- Loop over the TRF grid
    for kk = 1:numel(xim_flatten)
        
        %-- tx-rx distance
        dist_txrx_s = dist_txrx_r(kk);
        
        %-- Directivity
        directivity_s = directivity_r(kk);
        
        %-- Interpolation
        trf = trf + directivity_s*directivity_r.*interp1(t_pulse, pulse, (dist_txrx_s - dist_txrx_r) / c, 'spline', 0).*rf_data_flatten;
    end
end
%-- Reshape the TRF
trf = reshape(trf, [numel(zim), numel(xim)]);
