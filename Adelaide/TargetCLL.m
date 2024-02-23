% Ralf Mouthaan
% University of Adelaide
% December 2023
%
% Generates a target shaped like a christmas tree

%function img = TargetChristmas

clc; clear variables; close all;

img = imread('CLL.jpg');
img = rgb2gray(img);
img = img(60:500,:);
img = img > 100;

Nx = 50;
x1 = linspace(0, 1, size(img, 2));
y1 = linspace(0, 1, size(img, 1)).';
x2 = linspace(0, 1, Nx);
y2 = linspace(0, 1, Nx).';

img = double(img);
img = interp2(x1, y1, img, x2, y2);

imagesc(img);