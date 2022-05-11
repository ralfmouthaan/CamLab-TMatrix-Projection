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
Target = dlmread('60x60 Targets/alpha Target.txt').';
%Target = dlmread('60x60 Targets/delta Target.txt').';
%Target = dlmread('60x60 Targets/lambda Target.txt').';
%Target = dlmread('60x60 Targets/mu Target.txt').';
%Target = dlmread('60x60 Targets/omega Target.txt').';
%Target = dlmread('60x60 Targets/pi Target.txt').';
%Target = dlmread('60x60 Targets/Smiley Target.txt').';
%Target = dlmread('60x60 Targets/TripleBar Target.txt').';

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

phi1 = rand(size(Holo))*2*pi;
phi2 = angle(T*Holo);
prevphi2 = zeros(size(phi2));

arrAlpha = 1:-0.01:0.9;
arrMSE = ones(size(arrAlpha))*999999;

for zz = 1:length(arrAlpha)
    
    alpha = arrAlpha(zz);
    fprintf('alpha = %f\n', alpha);

    for i = 1:50

        prevphi1 = ones(size(Holo));

        for j = 1:20
            prevphi1 = phi1;
            %phi1 = angle(A_D_inv*(conjT*(Target.*exp(1i*phi2))));   %GS - it's not GS though as we can't just drop the second term. T must genuinely be well-conditioned.
            %phi1 = angle(conjT*(Target.*exp(1i*phi2)) - Ahat*(Holo.*exp(1i*phi1)));    %YG
            phi1 = alpha*phi1 + (1-alpha)*(angle(A_D_inv*(conjT*(Target.*exp(1i*phi2)) -  A_ND*(Holo.*exp(1i*phi1))))); % Weighted YG
            %fprintf('%f\n', sum(abs(phi1 - prevphi1)))
        end

        prevphi2 = phi2;
        phi2 = angle(T*(Holo.*exp(1i*phi1)));

        Replay = T*(Holo.*exp(1i*phi1));
        Target = Target * sqrt(sum(sum(abs(Replay).^2))/sum(sum(abs(Target).^2)));
        NMSE = sum((abs(Replay) - Target).^2)/sum(Target.^2);
        if NMSE < arrMSE(zz)
            arrMSE(zz) = NMSE;
        end

    end
    
    fprintf('MSE = %f\n', arrMSE(zz));

end

figure('position', [400 400 400 400]);
plot(arrAlpha, arrMSE*100, 'LineWidth', 2);
xlabel('\alpha');
ylabel('MSE (%)');
set(gca, 'fontsize', 14);

Holo = Holo.*exp(1i*phi1);
Replay = T*Holo;

Holo = reshape(Holo, sqrt(Ny), sqrt(Ny));
Replay = reshape(Replay, sqrt(Nx), sqrt(Nx));

dlmwrite('Predicted Image.txt', Replay);

figure;
imagesc(angle(Holo));
axis square;
figure('Position', [400 400 400 400]);
imagesc(abs(Replay));
axis square;
xticks('');
yticks('');





