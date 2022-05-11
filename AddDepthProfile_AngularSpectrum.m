function RetVal = AddDepthProfile(Target, z)

    Nx = sqrt(length(Target));
    Target = reshape(Target, Nx, Nx);
    lambda=633e-9;
    x = linspace(-25e-6,25e-6, Nx);
    dx = x(2) - x(1);
    du = 1/dx;
    u = -Nx/2 + 1/2 : Nx/2 - 1/2;
    u = u*du/length(u);
    
    filter = exp(1i*2*pi*z.*sqrt(1/lambda^2 - u.^2 - u.'.^2));
    
    RetVal = fftshift(fft2(fftshift(Target)));
    RetVal = RetVal.*filter;
    RetVal = fftshift(ifft2(fftshift(RetVal)));
    
    RetVal(sqrt(x.^2 + x.'.^2) > 20e-6) = 0;
    RetVal = reshape(RetVal, Nx*Nx, 1);
    
   
end