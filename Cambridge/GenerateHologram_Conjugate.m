% Ralf Mouthaan
% University of Cambridge
% July 2021

clc; clear variables; close all;

%% Read in Transmission Matrix

load('T-Matrix.mat');
conjT = conj(T).';

%% Target

Nx = size(T, 1);
Ny = size(T, 2);

% Load Target
%Target = dlmread('60x60 Targets/+ Target.txt').';
Target = dlmread('Infinity Target.txt');
%Target = dlmread('60x60 Targets/delta Target.txt').';
%Target = dlmread('60x60 Targets/lambda Target.txt').';
%Target = dlmread('60x60 Targets/mu Target.txt').';
%Target = dlmread('60x60 Targets/omega Target.txt').';
%Target = dlmread('60x60 Targets/pi Target.txt').';
%Target = dlmread('60x60 Targets/Smiley Target.txt').';
%Target = dlmread('60x60 Targets/TripleBar Target.txt').';

%% Generate Hologram

Holo = conjT*Target;
Holo = exp(1i*angle(Holo));
Replay = T*Holo;
Replay = abs(Replay);
Target = Target * sqrt(sum(sum(abs(Replay).^2))/sum(sum(abs(Target).^2)));

%% Error Metricsc
MSE = sum((Replay - Target).^2)/Nx;
RMSE = sqrt(MSE);
NMSE = sum((abs(Replay) - abs(Target)).^2)/sum(Target.^2);
RNMSE = sqrt(NMSE);
fprintf('MSE = %f\n', MSE);
fprintf('RMSE = %f\n', RMSE);
fprintf('NMSE = %f\n', NMSE);
fprintf('RNMSE = %f\n', RNMSE);

%% Plot Replay

Replay = reshape(Replay, 138, 138);
figure('Position', [400 400 400 400]);
imagesc(abs(Replay));
axis square;
xticks(''); yticks('');