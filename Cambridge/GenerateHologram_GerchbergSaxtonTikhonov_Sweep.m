% Ralf Mouthaan
% University of Cambridge
% August 2020
%
% Gerchberg-Saxton code to run with transmission matrix. Attempts to take
% into account the fact that pixels can be turned on or off.

clc; clear variables; close all;

%%  Transmission matrix

load('T-Matrix.mat');

Nx = size(T, 1);
Ny = size(T, 2);

%% Initialise fields

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

Holo = ones(Ny,1).*exp(1i*2*pi*rand(Ny,1));
Replay = T*Holo;
Replay = Replay.*exp(1i*2*pi*rand(size(Replay)));
Target = Target * sqrt(sum(sum(abs(Replay).^2))/sum(sum(abs(Target).^2)));


%% Gerchberg-Saxton

figure;

arrlambda = 0:0.5:10;
arrMSE = zeros(size(arrlambda));

for ii = 1:length(arrlambda)
    
    lambda = arrlambda(ii);
    Gamma = eye(Ny)*lambda;
    Tinv = inv(T'*T + Gamma)*T';

    for i = 1:100

        Holo = Tinv*Replay;
        Holo = exp(1i*angle(Holo));
        Replay = T*Holo;
        Target = Target * sqrt(sum(sum(abs(Replay).^2))/sum(sum(abs(Target).^2)));
        NMSE = sum((abs(Replay) - Target).^2)/sum(Target.^2);
        Replay = Target.*exp(1i*angle(Replay));

    end
    
    arrMSE(ii) = NMSE;

end

figure('position', [400 400 400 400]);
plot(arrlambda, arrMSE*100);
xlabel('\lambda');
ylabel('NMSE (%)');

