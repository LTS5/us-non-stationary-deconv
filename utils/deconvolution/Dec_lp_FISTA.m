function res = Dec_lp_FISTA(data, param)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% x = argmin ||y-h*x||_2^2 + 1/(2*mu)||x||_p^p
%input:
%   data:
%      y: observation
%      h: point spread function
%   param:
%      p: lp norm
%      mu: hyperparameter, mu is usually responsible for the trade
%      off between noise and lp norm
%      gamma: step size, lipschitz constant
%      iterMax: maximum iteration
%      tol: convergence criterion
%output:
%   res:
%      x: estimated true image
%      iter: num of iterations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if ~isfield(param, 'imsize')
    imsize = size(data.y);
else
    imsize = param.imsize;
end
F = data.H;

%%initialization
j=0;
x = zeros(imsize);
xold = x;
z = x;
told = 1;

while j < param.iterMax
    Df = F.adjoint(F.forward(z) - data.y);%real(ifft2(conj(H).*(H.*fft2(x)-fft2(y))));
    x = prox_lp(z - param.gamma*Df, param.p, param.mu*param.gamma); 
    
    % Update of the acceleration parameter
    t=0.5*(1+sqrt(1+4*told^2));
    
    % Intermediate variable
    z=x+((told-1)/t)*(x-xold);
    
    % MSE computation
    mse = norm(x(:)-xold(:),2)/norm(x);
    
    % Update of the x and t value
    xold = x;
    told = t;
    
    disp(['Iteration ', num2str(j), ' - relative error = ', num2str(mse)]);%, ob1 = %.2e, ob2 = %.2e, ob = %.2e\n',mse, Ob1(j+1),  Ob2(j+1), Ob(j+1));
    if(mse < param.tol)
        break;
    end
    j = j+1;
end

res.x = x;
res.iter = j;

end
