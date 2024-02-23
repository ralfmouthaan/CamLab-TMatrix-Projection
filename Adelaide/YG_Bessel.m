% Ralf Mouthaan
% University of Cambridge
% April 2020
%
% Yang-Gu code to obtain desired field at output of fibre.

clc; clear variables; close all;

%% Read in Transmission Matrix

load('T-Matrix.mat');
conjT = conj(T).';

%% Target

Nx = size(T, 1); % Number of outputs
Ny = size(T, 2); % Number of inputs
Nx2 = sqrt(Nx); % Total width of output image

x = linspace(-1, 1, Nx2);
Target = BesselBeam(0, 20*x);
Target = Target(:);

Mask = sum(abs(T.'));
Mask = (Mask > max(Mask)/4);

Holo = ones(Ny,1).*exp(1i*2*pi*rand(Ny,1));
Replay = T*Holo;
Target = Target* sqrt(sum(sum(abs(Replay).^2))/sum(sum(abs(Target).^2)));

%% Yang-Gu algorithm

Ahat = conjT*T;
A_D = diag(diag(Ahat));
A_ND = Ahat - A_D;
A_D_inv = diag(1./diag(A_D));
A_ND_inv = inv(A_ND);
alpha = 0.95;

for i = 1:100

    Replay = T*Holo;
    Target = Target * sqrt(sum(abs(Replay).^2)/sum(abs(Target).^2));
    NMSE = sum((abs(Replay(Mask)) - abs(Target(Mask))).^2)/sum(abs(Target(Mask)).^2);
    fprintf('NMSE = %f\n', NMSE);
    
    Replay(Mask) = Target(Mask); %.*exp(1i*angle(Replay(Mask)));
    
    for j = 1:10
        Holo = alpha*Holo + (1-alpha)*A_D_inv*(conjT*Replay - A_ND*Holo);
        Holo = exp(1i*angle(Holo));
    end
    
end

Replay = T*Holo;

%% Error calculations

Target = Target * sqrt(sum(sum(abs(Replay).^2))/sum(sum(abs(Target).^2)));
NMSE = sum((abs(Replay(Mask)) - abs(Target(Mask))).^2)/sum(abs(Target(Mask)).^2);
PSNMSE = sum(abs(Replay(Mask) - Target(Mask)).^2)/sum(abs(Target(Mask)).^2);
fprintf('NMSE = %f\n', NMSE);
fprintf('PS-NMSE = %f\n', PSNMSE)
fprintf('Overlap Integral = %f\n', OverlapIntegral(Replay, Target))

%% Save Hologram

fid = fopen('Test Hologram.txt', 'w+');

for i = 1:length(Holo)
    fprintf(fid, num2str(Holo(i)));
    if i ~= length(Holo)
        fprintf(fid, ",");
    end
end

fclose(fid);

%% Plots

Holo = reshape(Holo, sqrt(Ny), sqrt(Ny));
Replay = reshape(Replay, sqrt(Nx), sqrt(Nx));
Target = reshape(Target, sqrt(Nx), sqrt(Nx));

figure('Position', [400 400 400 400]);
imagesc(abs(Target));
axis square;
xticks('');
yticks('');

figure('Position', [400 400 400 400]);
imagesc(angle(Target));
axis square;
xticks('');
yticks('');


figure('Position', [400 400 400 400]);
imagesc(abs(Replay));
axis square;
xticks('');
yticks('');

figure('Position', [400 400 400 400]);
imagesc(angle(Replay));
axis square;
xticks('');
yticks('');

%% Helper functions

function [RetVal] = OverlapIntegral(M1, M2)

    RetVal = abs(sum(sum(M1.*conj(M2))))^2;
    RetVal = RetVal/sum(sum(abs(M1.*conj(M1))));
    RetVal = RetVal/sum(sum(abs(M2.*conj(M2))));
    RetVal = sqrt(RetVal);

end


