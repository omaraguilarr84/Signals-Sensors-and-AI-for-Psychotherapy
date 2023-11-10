clear; clc; close all;

%% Load Data
% Add your personal file path
file_path = '/Users/omaraguilarjr/Documents/MATLAB/Sensors and AI in Psychotherapy/Data/Testing Fall 2023/11-1 Sophia Test/BrainFlow-RAW_2023-11-01_15-08-45_1.csv';
eegData = readmatrix(file_path);

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
% plot(time,EXG_Channel1);
% xlabel('Time (s)');
% ylabel('Voltage (uV)');
% title('Raw Voltage for Channel 8');

% Plot All Channels
axesArray = cell(numChannels,1);
for i = 1:numChannels
    channelName = sprintf('EXG Channel %d',i-1);
    a = nexttile;
    plot(time,eegData(:,i+1));
    xlabel('Time (s)');
    ylabel('Voltage (uV)');
    title(channelName);
    axesArray{i} = a;
end
sgtitle('Raw Voltage Data for All Channels');
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

%% Power Spectral Density Plot
channelNum = 8;

% Fourier Transform specifications
window = hann(fs);
per_overlap = 0.75;
per_nfft = 1.10;

% Raw
[pxx,f] = pwelch(voltageData(:,channelNum),window,ceil(numel(window)*per_overlap),ceil(numel(window)*per_nfft),fs);
figure;
plot(f,10*log10(pxx));

% Filtered
[pxx2,f2] = pwelch(filtered_voltage(:,channelNum),window,ceil(numel(window)*per_overlap),ceil(numel(window)*per_nfft),fs);
figure;
plot(f2,10*log10(pxx2));
