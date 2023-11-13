clear; clc; close all;

%% Load Data
% Add your personal file path
file_path = '/Users/omaraguilarjr/Documents/MATLAB/Sensors and AI in Psychotherapy/Data/Testing Fall 2023/11-8/11-8 Dr. Gilmore Test/BrainFlow-RAW_2023-11-08_15-53-03_0.csv';
eegData = readmatrix(file_path);
trialName = '11-8 Dr. Gilmore';

% Sample number within a second of recording
sampleIndex = eegData(:,1);

% Separating EXG Channels and putting into voltageData
numChannels = 8;
voltageData = zeros(size(eegData,1),numChannels);
for i = 1:numChannels
    varName = sprintf('EXG_Channel%d',i-1);
    colIndex = i + 1;
    data = eegData(:,colIndex);
    eval([varName, ' = data;']);
    voltageData(:,i) = data;
end

% Unix time
UnixTime = eegData(:,23);

%% Plot Raw Data
fs = 250; % Sampling rate
numSamples = 0:size(eegData,1)-1;
time = numSamples/fs;

% % Plot One Channel
% figure;
% plot(time,EXG_Channel6);
% xlabel('Time (s)');
% ylabel('Voltage (uV)');
% title('Raw Voltage for Channel 7');

% Plot All Channels
axesArray = cell(numChannels,1);
for i = 1:numChannels
    channelName = sprintf('EXG Channel %d',i-1);
    a = nexttile;
    plot(time,voltageData(:,i));
    xlabel('Time (s)');
    ylabel('Voltage (uV)');
    title(channelName);
    axesArray{i} = a;
end
sgtitle(['Raw Voltage Data for All Channels: ',trialName],'FontSize',20,'FontWeight','bold');
linkaxes([axesArray{:}], 'xy');

%% Filter Voltage
% HP filter
fpass = 0.5;
% hp_voltage = highpass(voltageData(:,channelNum),fpass,fs,"Steepness",.9);

% Notch Filter
fstop = [55 65]; % Bounds for bandstop filter
% filtered_voltage = bandstop(hp_voltage,fstop,fs);

hp_voltage = zeros(size(eegData,1),numChannels);
filtered_voltage = zeros(size(eegData,1),numChannels);
for i = 1:8
    hp_voltage(:,i) = highpass(voltageData(:,i),fpass,fs,"Steepness",.9);
    filtered_voltage(:,i) = bandstop(hp_voltage(:,i),fstop,fs);
end

%% Plot Filtered Voltage
% Plot one channel
channelNum = 7;
figure;
plot(time,filtered_voltage(:,channelNum));
xlabel('Time (s)')
ylabel('Voltage (V)');
title(['Filtered Voltage for Channel ',num2str(channelNum)]);

% Plot all channels
axesArray = cell(numChannels,1);
for i = 1:numChannels
    channelName = sprintf('EXG Channel %d',i-1);
    a = nexttile;
    plot(time,filtered_voltage(:,i));
    xlabel('Time (s)');
    ylabel('Voltage (uV)');
    title(channelName);
    axesArray{i} = a;
end
sgtitle(['Filtered Voltage Data for All Channels: ',trialName],'FontSize',20,'FontWeight','bold');
linkaxes([axesArray{:}], 'xy');

%% Power Spectral Density Plot
channelNum = 7;

% Fourier Transform specifications
window = hann(fs);
per_overlap = 0.75;
per_nfft = 1.10;

% Raw
[pxx,f] = pwelch(voltageData(:,channelNum),window,ceil(numel(window)*per_overlap),ceil(numel(window)*per_nfft),fs);
figure;
plot(f,10*log10(pxx));
xlabel('Frequency (Hz)');
ylabel('Log Power (dB)');
xlim([0 100]);
xline([0 4 8 12 30 50 70],'-',{'Delta','Theta','Alpha','Beta','Low Gamma','N/A','HighGamma'});
title(['Raw PSD for Channel ',num2str(channelNum)]);

% Filtered
[pxx2,f2] = pwelch(filtered_voltage(:,channelNum),window,ceil(numel(window)*per_overlap),ceil(numel(window)*per_nfft),fs);
figure;
plot(f2,10*log10(pxx2));
xlabel('Frequency (Hz)');
ylabel('Log Power (dB)');
title(['Filtered PSD for Channel ',num2str(channelNum)]);

%% Spectrogram
channelNum = 7;

% Fourier Transform specifications
window = hann(fs);
per_overlap = 0.75;
per_nfft = 1.10;

% Short-Time Fourier Transform
[S, F, T] = spectrogram(voltageData(:,channelNum),window,ceil(numel(window)*per_overlap),ceil(numel(window)*per_nfft),fs);
spectrogram_dB = 10 * log10(abs(S));
imagesc(T, F, normalize(spectrogram_dB,2,'center'));
xlabel('Time (s)');
ylabel('Frequency (Hz)');
ylim([0 100]);
yline([0 4 8 12 30 50 70],'-',{'Delta','Theta','Alpha','Beta','Low Gamma','N/A','HighGamma'});
colorbar eastoutside;
title(sprintf('Raw Spectrogram for Channel %0.0f', channelNum));
