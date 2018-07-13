function [ x ,chi] = prox_lp(w,p,lam,prec)
%----------------------------------------------------
% Date: Nov. 2014
% Author: Ninging Zhao (PhD student)
%         University of Toulouse, IRIT/INP-ENSEEIHT
%         
% TARGET:
%       (P0)  argmin_x .5||x-w||^2 + lam* ||x||^p  
%             with lam = lam*gamma   
%
% OUTPUT
%      x: MAP estimation of (P0)
%         if p<1 x = x_star*sgn(w)*max(0,|w|-chi)
%         if p>1 x = x_star*sgn(w)
%      chi: thresholding value
%----------------------------------------------------
if nargin == 3
    prec = 1e-6;
elseif nargin ~= 4
    error('invalid number of arguments')
end


if (0<p)&&(p<1)  
%------------Fixed Point Iterative method---------------
    opiter=20;
  
    xa = (2*lam*(1-p)).^(1/(2-p));
    chi = xa + lam*p.*xa.^(p-1);

    % iteration to determin x_star
    i0 = find(abs(w)>=chi);
    x = zeros(size(w));
    x_star = abs(w(i0));
    if numel(lam)~=1
        lam =lam(i0);
    end
    for j = 1 : opiter
        x_star_old = x_star;
        x_star = abs(w(i0)) - lam*p.*(x_star_old).^(p-1);
        if norm(x_star-x_star_old) < prec;
            break
        end
    end
    x(i0)=sign(w(i0)).*x_star; 
  
elseif 1<p
%------------------Newton's method-------------------
    pref = [1 4/3 3/2 2 3 4];
    [~, imin] = min(abs(p-pref));
    x0 = proxpowerp(abs(w),pref(imin),lam);

    opiter=200;
    x_star = x0;
    err=zeros(1,opiter);
    for j = 1 : opiter
        x_star_old = x_star;
        f = x_star_old + lam.*p.*x_star_old.^(p-1)-abs(w);
        fp=1 + lam.*p*(p-1).*x_star_old.^(p-2);
        x_star = x_star_old-f./fp;
        err(j) = norm(x_star(:)-x_star_old(:))^2;
        
        if err(j) < prec;
            break
        end
    end

%     a = p*lam;
%         x_star = zeros(size(w));
%     for t=1:length(w)
%         func= @(x)(x + a*abs(x)^(p-1)-abs(w(t)));
%         %        x_star(t) =fzero(func, abs(w(t)));
%         x_star(t) =fzero(func, x0(t));
%     end
    
    x = sign(w).*x_star;
    chi =0;
    
elseif p == 1;
    x = proxpowerp(w,1,lam);
    chi = lam;    
else
    error('incorrect value of exponent');
end
end

function pr = proxpowerp(x,p,gamma,y)
% pr = proxpowerp(x,p,gamma,y)

if nargin == 3
    y = zeros(size(x));
elseif nargin ~= 4
    error('incorrect number of arguments');
end


 x = x-y;
 gamma = gamma+eps;
 switch p
 case 1
     pr = max(abs(x)-gamma,0).*sign(x);
 case 4/3
     %pr = sqrt(256*gamma^3+729*x.^2);
     pr = sqrt(256*gamma^3/729+x.^2);
     %pr = ((108*abs(x)+4*pr).^(2/3)-16*gamma).^3/864./(27*abs(x)+pr).*sign(x);
     pr = x+4*gamma/3/2^(1/3)*((pr-x).^(1/3)-(pr+x).^(1/3));
 case 3/2
     pr = x+9/8*gamma.*sign(x).*(gamma-sqrt(gamma.^2+16/9.*abs(x)));
 case 2
     pr = x/(1+2*gamma);
 case 3
     pr =sign(x).*(sqrt(1+12*gamma*abs(x))-1)/(6*gamma);
 case 4
     pr = sqrt(x.^2+1/(27*gamma));
     pr =1/(8*gamma)^(1/3)*((x+pr).^(1/3)-(-x+pr).^(1/3));
 otherwise
     error('unknown prox');
 end
 pr = pr+y;
end
