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

lambda = 5;
Gamma = eye(Ny)*lambda;
 
Tinv = inv(T'*T + Gamma)*T';

figure;
imagesc(abs(Tinv*T))

%% Initialise fields

% Load Target
%Target = dlmread('30x30 Targets/+ Target.txt').';
Target = dlmread('32x32 Targets/Infinity Target.txt');
%Target = dlmread('30x30 Targets/delta Target.txt').';
%Target = dlmread('30x30 Targets/lambda Target.txt').';
%Target = dlmread('30x30 Targets/mu Target.txt').';
%Target = dlmread('30x30 Targets/omega Target.txt').';
%Target = dlmread('30x30 Targets/pi Target.txt').';
%Target = dlmread('60x60 Targets/Smiley Target.txt').';
%Target = dlmread('30x30 Targets/TripleBar Target.txt').';

Holo = ones(Ny,1).*exp(1i*2*pi*rand(Ny,1));
Replay = T*Holo;
Replay = Replay.*exp(1i*2*pi*rand(size(Replay)));
Target = Target * sqrt(sum(sum(abs(Replay).^2))/sum(sum(abs(Target).^2)));


%% Gerchberg-Saxton

figure;
for i = 1:100
    
    Holo = Tinv*Replay;
    Holo = exp(1i*angle(Holo));
    Replay = T*Holo;
    Target = Target * sqrt(sum(sum(abs(Replay).^2))/sum(sum(abs(Target).^2)));
    Replay = Target.*exp(1i*angle(Replay));
    
end

Replay = T*Holo;
Target = Target * sqrt(sum(sum(abs(Replay).^2))/sum(sum(abs(Target).^2)));

%% Error Calculations

Replay = abs(Replay);
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

Holo = conj(Holo);
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

figure;
subplot(1,2,1);
imagesc(abs(Holo));
axis square;
subplot(1,2,2);
imagesc(angle(Holo));
axis square;

figure('Position', [400 400 400 400]);
imagesc(abs(Replay));
xticks(''); yticks('');
axis square;