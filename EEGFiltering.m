%% MATLAB Online – EEG Toolbox-Free Filtering + Scalp Map (Final Working)
clear; clc; close all;

Fs = 256;            % Sampling rate
T = 10;              % Duration (seconds)
channels = 23;

%% --- Generate synthetic EEG ---
data = randn(channels, Fs*T);

%% ---------- FFT BANDPASS FILTER (NO TOOLBOX) ----------
N = size(data,2);
f = (0:N-1)*(Fs/N);

% ideal bandpass mask (0.5 to 30 Hz)
H_bp = double(f >= 0.5 & f <= 30);
H_bp = H_bp + fliplr(H_bp);

data_bp = zeros(size(data));
for ch = 1:channels
    X = fft(data(ch,:));
    X = X .* H_bp;
    data_bp(ch,:) = real(ifft(X));
end

%% ---------- FFT NOTCH FILTER @ 50 Hz (NO TOOLBOX) ----------
H_notch = ones(1,N);
H_notch(f >= 49 & f <= 51) = 0;
H_notch = H_notch .* fliplr(H_notch);

data_filt = zeros(size(data_bp));
for ch = 1:channels
    X = fft(data_bp(ch,:));
    X = X .* H_notch;
    data_filt(ch,:) = real(ifft(X));
end

%% ✅ FIGURE 1 — EEG Time Series
t = (0:N-1)/Fs;

figure;
plot(t, data_filt(1,:), 'LineWidth', 1.2);
xlabel('Time (s)');
ylabel('Amplitude');
title('Filtered EEG – Channel 1 (Toolbox-Free)');
grid on;


%% ---------- SCALP TOPOGRAPHY WITHOUT TOOLBOX ----------
labels = {'Fp1','Fp2','F3','F4','C3','C4','P3','P4','O1','O2', ...
          'F7','F8','T3','T4','T5','T6','Fz','Cz','Pz','Oz', ...
          'FC1','FC2','CP1'};

% manually defined 2D EEG scalp coordinates
x = [-0.5, 0.5, -0.4, 0.4, -0.3, 0.3, -0.2, 0.2, -0.1, 0.1, ...
     -0.45, 0.45, -0.35, 0.35, -0.25, 0.25, 0, 0, 0, -0.05, ...
     -0.15, 0.15, -0.05];

y = [ 1, 1,  0.6, 0.6,  0.3, 0.3,  0, 0, -0.3,-0.3, ...
      0.8, 0.8, 0.4, 0.4, -0.1, -0.1, 0.8, 0.4, -0.1, -0.5, ...
      0.5, 0.5, -0.3];

values = mean(data_filt,2);

%% ✅ FIGURE 2 — SCALP MAP (NO TOOLBOX)
figure;

% Draw the head circle manually
th = linspace(0, 2*pi, 300);
plot(cos(th), sin(th), 'Color', [0.5 0.5 0.5], 'LineWidth', 2);
hold on;

% Plot electrodes
scatter(x, y, 250, values, 'filled');
colormap jet; colorbar;

% Add electrode labels
for i = 1:length(labels)
    text(x(i)+0.03, y(i)+0.03, labels{i}, 'FontSize',10, 'FontWeight','bold');
end

title('EEG Scalp Map (Pure MATLAB, No Toolboxes)');
axis equal off;
