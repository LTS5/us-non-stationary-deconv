function K = evaluate_psf_kernel(xr, zr, xs, zs, tx_pos, rx_pos, c, G_param)
	K = 0;
    el_width = G_param.el_width;
    lambda = G_param.lambda;
    pulse = G_param.pulse;
    t_pulse = G_param.t_pulse;
    for kk = 1:numel(tx_pos)
        tx_pos_kk = tx_pos(kk);
        tx_dist = sqrt((xr-tx_pos_kk)^2 + zr^2);
        tx_dist_s = sqrt((xs-tx_pos_kk)^2 + zs^2);
        tx_directivity = zr./(tx_dist+eps) .* sinc(el_width / lambda .*(xr-tx_pos_kk) ./(tx_dist+eps));
        dist_r = tx_dist;
        dist_s = tx_dist_s;
        tmp = tx_directivity/tx_dist;
        for ll = 1:numel(rx_pos)
            rx_pos_ll = rx_pos(ll);
            rx_dist = sqrt((xr-rx_pos_ll)^2 + zr^2);
            rx_dist_s = sqrt((xs-rx_pos_ll)^2 + zs^2);
            dist_r =  dist_r + rx_dist;
            dist_s = dist_s + rx_dist_s;
            K = K + zs./(rx_dist_s+eps) .* sinc(el_width / lambda .*(xs-rx_pos_ll) ./(rx_dist_s+eps))*zr./(rx_dist+eps) .* sinc(el_width / lambda .*(xr-rx_pos_ll) ./(rx_dist+eps))/(rx_dist+eps) *tmp*interp1(t_pulse, pulse, (dist_s-dist_r)/c, 'linear', 0);
            
        end
    end
    