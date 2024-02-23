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

Nx = size(T, 1);
Ny = size(T, 2);

% Load Target
%Target = dlmread('60x60 Targets/+ Target.txt').';
%Target = dlmread('60x60 Targets/alpha Target.txt').';
%Target = dlmread('60x60 Targets/beta Target.txt').';
%Target = dlmread('60x60 Targets/delta Target.txt').';
%Target = dlmread('60x60 Targets/lambda Target.txt').';
%Target = dlmread('60x60 Targets/mu Target.txt').';
Target = dlmread('82x82 Targets/Infinity Target.txt');
%Target = dlmread('60x60 Targets/pi Target.txt').';
%Target = dlmread('60x60 Targets/Smiley Target.txt').';
%Target = dlmread('60x60 Targets/TripleBar Target.txt').';

Target = AddDepthProfile_AngularSpectrum(Target, 25e-6);

% Normalise power
Holo = ones(Ny,1);
Replay = T*Holo;
Target = Target * sqrt(sum(sum(abs(Replay).^2))/sum(sum(abs(Target).^2)));

%% Yang-Gu algorithm

Ahat = conjT*T;
A_D = diag(diag(Ahat));
A_ND = Ahat - A_D;
A_D_inv = diag(1./diag(A_D));
A_ND_inv = inv(A_ND);
alpha = 0.95;

phi1 = rand(size(Holo))*2*pi;

for i = 1:100
    
    prevphi1 = ones(size(Holo));
    
    for j = 1:10
        prevphi1 = phi1;
        %phi1 = angle(A_D_inv*(conjT*(Target.*exp(1i*phi2))));   %GS - it's not GS though as we can't just drop the second term. T must genuinely be well-conditioned.
        %phi1 = angle(conjT*(Target.*exp(1i*phi2)) - Ahat*(Holo.*exp(1i*phi1)));    %YG
        phi1 = alpha*phi1 + (1-alpha)*(angle(A_D_inv*(conjT*Target -  A_ND*(Holo.*exp(1i*phi1))))); % Weighted YG
        %fprintf('%f\n', sum(abs(phi1 - prevphi1)))
    end
    
    Replay = T*(Holo.*exp(1i*phi1));
    Target = Target * sqrt(sum(sum(abs(Replay).^2))/sum(sum(abs(Target).^2)));
    
end

Holo = Holo.*exp(1i*phi1);

%% Error calculations

Replay = abs(T*Holo);
Target = Target * sqrt(sum(sum(abs(Replay).^2))/sum(sum(abs(Target).^2)));
MSE = sum((Replay - Target).^2)/Nx;
RMSE = sqrt(MSE);
NMSE = sum((Replay - Target).^2)/sum(Target.^2);
RNMSE = sqrt(NMSE);
fprintf('MSE = %f\n', MSE);
fprintf('RMSE = %f\n', RMSE);
fprintf('NMSE = %f\n', NMSE);
fprintf('RNMSE = %f\n', RNMSE);

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

Replay = T*Holo;
Holo = reshape(Holo, sqrt(Ny), sqrt(Ny));
Replay = reshape(Replay, sqrt(Nx), sqrt(Nx));
Target = reshape(Target, sqrt(Nx), sqrt(Nx));

%dlmwrite('Predicted Image.txt', Replay);

figure;
imagesc(angle(Holo));
axis square;

figure;
subplot(1,2,1);
ComplexPlot(Target);
axis square;
xticks('');
yticks('');

subplot(1,2,2);
ComplexPlot(Replay)
axis square;
xticks('');
yticks('');





