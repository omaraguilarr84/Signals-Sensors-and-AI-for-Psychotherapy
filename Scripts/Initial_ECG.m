%% Choose Computer
list = {'Omar Mac', 'Omar PC'};
a = listdlg('ListString',list);
gitPath = comp(a);

%% Load Data
ecg_filePath = '\Data\Shimmer Data\2-15\2024-02-15_10.35.35_Thu10h35m33s_MultiSession\Thu10h35m33s_Session1_S103_011E_Calibrated_SD.csv';
afr_filePath = '\Data\Shimmer Data\2-15\2024-02-15_10.35.35_Thu10h35m33s_MultiSession\Thu10h35m33s_Session1_Aggregator_Fusion_Response_Calibrated_PC.csv';
ecgData = readmatrix([gitPath, ecg_filePath]);
afrData = readmatrix([gitPath, afr_filePath]);
trialName = '2-15 Gracie';

fs = 256; % not sure of this
UnixTime = ecgData(:,1); % ms
time = (UnixTime-UnixTime(1))/1000; % s
rawAmp = ecgData(:,2); % mV

afr_UnixTime = afrData(:,1);
afr_time = (afr_UnixTime-afr_UnixTime(1))/1000;
resp = afrData(:,4);

%% Plot Raw ECG Amplitude
figure;
plot(time,rawAmp);
title([trialName, ' Raw Voltage']);
ylabel('Amplidtude (mV)');
xlabel('Time (s)');

%% Filter ECG Data
% HP filter
fpass = 0.5;
hp_voltage = highpass(rawAmp,fpass,fs,"Steepness",.9);

% Notch Filter
fstop = [55 65]; % Bounds for bandstop filter
filtAmp = bandstop(hp_voltage,fstop,fs);

%% Plot Filtered ECG
figure;
plot(time,filtAmp);
title([trialName, ' Filtered Voltage']);
ylabel('Amplidtude (mV)');
xlabel('Time (s)');

%% Raw vs. Filtered ECG
figure;
plot(time,rawAmp);
hold on;
plot(time,filtAmp);
legend('Raw','Filtered');
title([trialName, ' Raw vs. Filtered Voltage']);
ylabel('Amplidtude (mV)');
xlabel('Time (s)');

%% Spectrogram for Filtered Voltage
% Fourier Transform specifications
window = hann(fs);
per_overlap = 0.75;
per_nfft = 1.10;

% STFT
[S, F, T] = spectrogram(filtAmp,window,ceil(numel(window)*per_overlap),ceil(numel(window)*per_nfft),fs);
spectrogram_dB = 10 * log10(abs(S));
imagesc(T, F, normalize(spectrogram_dB,2,'center'));
xlabel('Time (s)');
ylabel('Frequency (Hz)');
colorbar;
title([trialName, ' Filtered Voltage Spectrogram']);

%% Voltage with Spectrogram and AFR
tiledlayout(3,1);

x1 = nexttile;
plot(time,filtAmp);
title([trialName, ' Filtered Voltage']);
ylabel('Amplidtude (mV)');
xlabel('Time (s)');

x2 = nexttile;
imagesc(T, F, normalize(spectrogram_dB,2,'center'));
xlabel('Time (s)');
ylabel('Frequency (Hz)');
title([trialName, ' Filtered Voltage Spectrogram']);

x3 = nexttile;
plot(afr_time,resp);
title([trialName, ' AFR']);
ylabel('Response (%)');
xlabel('Time (s)');
ylim([99 101]);

linkaxes([x1 x2 x3], 'x');

%% Voltage and AFR in Unix Time
tiledlayout(2,1);

x1 = nexttile;
plot(UnixTime,filtAmp);
title([trialName, ' Filtered Voltage']);
ylabel('Amplidtude (mV)');
xlabel('Time (s)');

x2 = nexttile;
plot(afr_UnixTime,resp);
title([trialName, ' AFR']);
ylabel('Response (%)');
xlabel('Time (s)');
ylim([99 101]);

linkaxes([x1 x2], 'x');
