% Ralf Mouthaan
% University of Cambridge
% September 2020
%
% 

clc; clear variables; close all;

%% Read in Transmission Matrix

load('T-Matrix.mat');

%% Target

Nx = size(T, 1);
Ny = size(T, 2);

% Load Target
Target = dlmread('30x30 Targets/+ Target.txt').';
%Target = dlmread('30x30 Targets/alpha Target.txt').';
%Target = dlmread('30x30 Targets/delta Target.txt').';
%Target = dlmread('30x30 Targets/lambda Target.txt').';
%Target = dlmread('30x30 Targets/mu Target.txt').';
%Target = dlmread('30x30 Targets/omega Target.txt').';
%Target = dlmread('30x30 Targets/pi Target.txt').';
%Target = dlmread('30x30 Targets/Smiley Target.txt').';
%Target = dlmread('30x30 Targets/TripleBar Target.txt').';

% Normalise power
Holo = ones(Ny,1);
Replay = T*Holo;
Target = Target * sqrt(sum(sum(abs(Replay).^2))/sum(sum(abs(Target).^2)));

%% Direct Search Algorithm

BestMSE = MeanSquaredError(Replay, Target);

for ii = 1:1e5
    
    NewHolo = Holo;
    NewHolo(randi(Ny)) = exp(1i*2*pi*rand);
    Replay = T*NewHolo;
    
    CurrMSE = MeanSquaredError(Replay, Target);
    if CurrMSE < BestMSE
        BestMSE = CurrMSE;
        Holo = NewHolo;
        fprintf('%u %f %f\n', ii, BestMSE, sum(sum(abs(Replay).^2)));
    end
    
end

Replay = T*Holo;
Target = Target * sqrt(sum(sum(abs(Replay).^2))/sum(sum(abs(Target).^2)));

%% Save Hologram

fid = fopen('Test Hologram.txt', 'w+');

for i = 1:length(Holo)
    fprintf(fid, num2str(Holo(i)));
    if i ~= length(Holo)
        fprintf(fid, ",");
    end
end

fclose(fid);

%% Display Results

Holo = reshape(Holo, sqrt(Ny), sqrt(Ny));
Replay = reshape(Replay, sqrt(Nx), sqrt(Nx));
Target = reshape(Target, sqrt(Nx), sqrt(Nx));

figure('Position', [400 400 400 400]);
imagesc(abs(Target));
axis square;
xticks('');
yticks('');

figure('Position', [400 400 400 400]);
imagesc(abs(Replay));
axis square;
xticks('');
yticks('');


function RetVal = MeanSquaredError(Replay, Target)

    Target = Target*sqrt(sum(sum(abs(Replay).^2))/sum(sum(abs(Target).^2)));
    
    RetVal = sum(sum((abs(Replay) - abs(Target)).^2));
    RetVal = RetVal/sum(sum(abs(Target).^2));

end