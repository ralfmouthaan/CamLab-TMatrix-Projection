% Ralf Mouthaan
% University of Adelaide
% December 2023
%
% Script to generate text target.
% One letter at a time for the moment.

function RetVal = TextTarget(strText, Nx)

    RetVal = zeros(Nx);
    RetVal = insertText(RetVal, [Nx/2, Nx/2], strText, ...
        'AnchorPoint', 'Center', ...
        'TextColor', 'White', ...
        'BoxColor', 'Black', ...
        'FontSize', 100, ...
        'Font', 'Arial Bold');
    RetVal = rgb2gray(RetVal);

end