% Ralf Mouthaan
% University of Cambridge
% September 2020
%
% Testing the imaging capability of my system.

clc; clear variables; close all;

%%

load('T-Matrix');

%% Spade Hologram

Eout_meas = dlmread('Spade Result - Amplitude.txt');
Ein_meas = dlmread('Spade Target - Amplitude.txt');

Ein_meas = reshape(Ein_meas, 20,20);

h = figure;
subplot(1,2,1);
imagesc(abs(Ein_meas));
cbar = colorbar;
axis square;
xticks('');
yticks('');
title('Displayed');

Eout_meas = Eout_meas(:);

Ein_est = Tinv*Eout_meas;
Ein_est = reshape(Ein_est, 20,20);

subplot(1,2,2);
imagesc(abs(Ein_est));
cbar = colorbar;
axis square;
xticks('');
yticks('');
title('Measured');

saveas(h, 'Spade Phase Result.png')

%% Club Hologram

Eout_meas = dlmread('Club Result - Amplitude.txt');
Ein_meas = dlmread('Club Target - Amplitude.txt');

Ein_meas = Ein_meas.';

Ein_meas = reshape(Ein_meas, 20, 20);
figure;
subplot(1,2,1);
imagesc(abs(Ein_meas));
cbar = colorbar;
axis square;
xticks('');
yticks('');
title('Displayed');

Eout_meas = Eout_meas(:);

Ein_est = Tinv*Eout_meas;
Ein_est = reshape(Ein_est, 20,20);

subplot(1,2,2);
imagesc(abs(Ein_est));
cbar = colorbar;
axis square;
xticks('');
yticks('');
title('Measured');

saveas(h, 'Club Phase Result.png')

%% Heart Hologram

Eout_meas = dlmread('Heart Result - Amplitude.txt');
Ein_meas = dlmread('Heart Target - Amplitude.txt');

Ein_meas = Ein_meas.';

Ein_meas = reshape(Ein_meas, 20, 20);
figure;
subplot(1,2,1);
imagesc(abs(Ein_meas));
cbar = colorbar;
axis square;
xticks('');
yticks('');
title('Displayed');

Eout_meas = Eout_meas(:);

Ein_est = Tinv*Eout_meas;
Ein_est = reshape(Ein_est, 20,20);

subplot(1,2,2);
imagesc(abs(Ein_est));
cbar = colorbar;
axis square;
xticks('');
yticks('');
title('Measured');

saveas(h, 'Heart Phase Result.png')

%% Diamond Hologram

Eout_meas = dlmread('Diamond Result - Amplitude.txt');
Ein_meas = dlmread('Diamond Target - Amplitude.txt');

Ein_meas = Ein_meas.';

Ein_meas = reshape(Ein_meas, 20, 20);
figure;
subplot(1,2,1);
imagesc(abs(Ein_meas));
cbar = colorbar;
axis square;
xticks('');
yticks('');
%caxis([0 1])
%cbar.Ticks = [0 0.25 0.5 0.75 1];
title('Displayed');

Eout_meas = Eout_meas(:);
%Eout_meas = conj(Eout_meas);

Ein_est = Tinv*Eout_meas;
Ein_est = reshape(Ein_est, 20,20);

subplot(1,2,2);
imagesc(abs(Ein_est));
cbar = colorbar;
axis square;
xticks('');
yticks('');
caxis([0 1])
cbar.Ticks = [0 0.25 0.5 0.75 1];
title('Measured');

saveas(h, 'Diamond Phase Result.png')

