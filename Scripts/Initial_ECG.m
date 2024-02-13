path = 'C:\Users\omarh\Documents\Clemson\Signals-Sensors-and-AI-for-Psychotherapy\Data\Shimmer Data\2-6\2024-02-06_10.45.14_2_6_2024_MultiSession\2_6_2024_Session1_S103_011E_Calibrated_SD.csv';
ecgData = readmatrix(path);
trialName = '2-6 Omar';

fs = 256; % not sure of this
UnixTime = ecgData(:,1); % ms
time = UnixTime-UnixTime(1)/1000; % s
rawAmp = ecgData(:,2); % mV

%% Plot Raw ECG Amplitude
figure;
plot(UnixTime,rawAmp);
title([trialName, ' Raw Voltage']);
ylabel('Amplidtude (mV)');
xlabel('UnixTime (ms)');

%% Filter ECG Data
% HP filter
fpass = 0.5;
hp_voltage = highpass(rawAmp,fpass,fs,"Steepness",.9);

% Notch Filter
fstop = [55 65]; % Bounds for bandstop filter
filtAmp = bandstop(hp_voltage,fstop,fs);

%% Plot Filtered ECG
figure;
plot(UnixTime,filtAmp);
title([trialName, ' Filtered Voltage']);
ylabel('Amplidtude (mV)');
xlabel('UnixTime (ms)');

%% Raw vs. Filtered ECG
figure;
plot(UnixTime,rawAmp);
hold on;
plot(UnixTime,filtAmp);
legend('Raw','Filtered');
title([trialName, ' Raw vs. Filtered Voltage']);
ylabel('Amplidtude (mV)');
xlabel('UnixTime (ms)');

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