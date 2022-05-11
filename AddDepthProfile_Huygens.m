function RetVal = AddDepthProfile(Target, z)

    Nx = sqrt(length(Target));
    Target = reshape(Target, Nx, Nx);
    lambda=633*10^-9;
    x = linspace(-25e-6,25e-6, Nx);

    RetVal = zeros(Nx, Nx);

    for i = 1:Nx
        for j = 1:Nx
            d = sqrt((x(j) - x).^2 + (x(i) - x.').^2 + z.^2);
            RetVal = RetVal + Target(i,j)*exp(1i*2*pi*d/lambda)/Nx/Nx;
        end
    end

    RetVal(sqrt(x.^2 + x.'.^2) > 20e-6) = 0;
    RetVal = reshape(RetVal, Nx*Nx, 1);

end