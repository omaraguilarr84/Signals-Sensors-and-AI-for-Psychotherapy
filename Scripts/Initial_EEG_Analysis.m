clear; clc; close all;

%% Load Data
file_path = '/Users/omaraguilarjr/Documents/MATLAB/Sensors and AI in Psychotherapy/Data/Testing Fall 2023/11-1 Sophia Test/BrainFlow-RAW_2023-11-01_15-08-45_1.csv';
eegData = readmatrix(file_path);

sampleIndex = eegData(:,1);
numChannels = 8;
voltageData = zeros(size(eegData,1),numChannels);
for i = 1:numChannels
    varName = sprintf('EXG_Channel%d',i-1);
    colIndex = i + 1;
    data = eegData(:,colIndex);
    eval([varName, ' = data;']);
    voltageData(:,i) = data;
end
UnixTime = eegData(:,23);


%% Plot Raw Data
fs = 250;
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
linkaxes([axesArray{:}], 'xy');

%% Power Spectral Density Plot
window = hann(fs);
per_overlap = 0.75;
per_nfft = 1.10;

channelNum = 8;
[pxx,f] = pwelch(voltageData(:,channelNum),window,ceil(numel(window)*per_overlap),ceil(numel(window)*per_nfft),fs);
figure;
plot(f,10*log10(pxx));
