% Ralf Mouthaan
% University of Cambridge
% July 2021
%
% Script to target image + measured image

clc; clear variables; close all;

%%

Target = dlmread('60x60 Targets/delta Target.txt').';
Measured = dlmread('Test Result.txt');
Target = reshape(Target, 60, 60);
Measured = reshape(Measured, 60, 60);

figure;
subplot(1,2,1);
imagesc(abs(Target));
axis square;
xticks('');
yticks('');

subplot(1,2,2);
imagesc(abs(Measured));
axis square;
xticks('');
yticks('');