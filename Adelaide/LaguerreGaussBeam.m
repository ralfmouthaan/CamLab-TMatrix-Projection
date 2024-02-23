% Ralf Mouthaan
% University of Adelaide
% December 2023
%
% Laguerre-Gauss beam generator

function RetVal = LaguerreGaussBeam(p, l, x)

    % p is radial index
    % l is azimuthal index
    % x is a one-dimensional coordinate axis.
    % It is assumed that y = x.';
    
    % Coordinate system
    r = sqrt(x.^2 + x.'.^2);
    phi = atan2(x, x.');
    
    RetVal = (sqrt(2)*r).^l .* exp(-r.^2) .* LaguerreGaussPoly(p, abs(l), 2*r.^2) .*exp(1i*l*phi);

end

function RetVal = LaguerreGaussPoly(k, a, x)

    % Generates Laguerre-Gauss Polynomial
    % Written as L_k^a(x)

    if k == 0
        RetVal = ones(size(x));
    elseif k == 1
        RetVal = 1 + a - x;
    else
        RetVal = (2*k + a - 1 - x)/k.*LaguerreGaussPoly(k-1, a, x) - ...
            (k-1 + a)/k*LaguerreGaussPoly(k-2, a, x);
    end

   
end