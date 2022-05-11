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
Replay = Target;
Replay = Replay.*exp(1i*2*pi*rand(size(Replay)));
Target = Target * sqrt(sum(sum(abs(Holo).^2))/sum(sum(abs(Target).^2)));


%% Gerchberg-Saxton

for i = 1:100
    
    Holo = Tinv*Replay;
    Holo = exp(1i*angle(Holo));
    Replay = T*Holo;
    Target = Target * sqrt(sum(sum(abs(Replay).^2))/sum(sum(abs(Target).^2)));
    NMSE = sum((abs(Replay) - abs(Target)).^2)/sum(Target.^2);
    fprintf('NMSE = %f\n', NMSE);
    Replay = Target.*exp(1i*angle(Replay));
    
end

Replay = abs(T*Holo);
Target = Target * sqrt(sum(sum(abs(Replay).^2))/sum(sum(abs(Target).^2)));
NMSE = sum((Replay - Target).^2)/sum(Target.^2);
fprintf('MSE = %f\n', NMSE);

Holo = reshape(Holo, sqrt(Ny), sqrt(Ny));
Replay = reshape(Replay, sqrt(Nx), sqrt(Nx));

figure;
imagesc(angle(Holo));
axis square;
figure('Position', [400 400 400 400]);
imagesc(abs(Replay));
axis square;
xticks('');
yticks('');