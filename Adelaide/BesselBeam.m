% Ralf Mouthaan
% University of Adelaide
% December 2023
%
% Generation of bessel beams

function RetVal = BesselBeam(l, x)

% l is azimuthal index
% x is a one-dimensional coordinate axis.
% It is assumed that y = x.';

r = sqrt(x.^2 + x.'.^2);
phi = atan2(x, x.');

RetVal = besselj(l, r).*exp(1i*l*phi);

end