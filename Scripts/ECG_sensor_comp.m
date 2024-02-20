%% Choose Computer
list = {'Omar Mac', 'Omar PC'};
a = listdlg('ListString',list);
gitPath = comp(a);

%% Load Data
trialName = '2-15 Gracie';
fs = 256; % pretty positive of this

s1_ecg_filePath = '\Data\Shimmer Data\2-15\2024-02-15_10.35.35_Thu10h35m33s_MultiSession\Thu10h35m33s_Session1_S103_011E_Calibrated_SD.csv';
s1_afr_filePath = '\Data\Shimmer Data\2-15\2024-02-15_10.35.35_Thu10h35m33s_MultiSession\Thu10h35m33s_Session1_Aggregator_Fusion_Response_Calibrated_PC.csv';
s1_ecgData = readmatrix([gitPath, s1_ecg_filePath]);
s1_afrData = readmatrix([gitPath, s1_afr_filePath]);
s1_UnixTime = s1_ecgData(:,1); % ms
s1_time = (s1_UnixTime-s1_UnixTime(1))/1000; % s
s1_rawAmp = s1_ecgData(:,2); % mV
s1_afr_UnixTime = s1_afrData(:,1);
s1_afr_time = (s1_afr_UnixTime-s1_afr_UnixTime(1))/1000;
s1_resp = s1_afrData(:,4);

s2_ecg_filePath = '\Data\Shimmer Data\2-15\2024-02-15_10.35.35_Thu10h35m33s_MultiSession\Thu10h35m33s_Session2_S114_0146_Calibrated_SD.csv';
s2_afr_filePath = '\Data\Shimmer Data\2-15\2024-02-15_10.35.35_Thu10h35m33s_MultiSession\Thu10h35m33s_Session2_Aggregator_Fusion_Response_Calibrated_PC.csv';
s2_ecgData = readmatrix([gitPath, s2_ecg_filePath]);
s2_afrData = readmatrix([gitPath, s2_afr_filePath]);
s2_UnixTime = s2_ecgData(:,1); % ms
s2_time = (s2_UnixTime-s2_UnixTime(1))/1000; % s
s2_rawAmp = s2_ecgData(:,2); % mV
s2_afr_UnixTime = s2_afrData(:,1);
s2_afr_time = (s2_afr_UnixTime-s2_afr_UnixTime(1))/1000;
s2_resp = s2_afrData(:,4);

% Create variable matrices instead
UnixTime(:,1) = s1_ecgData(:,1);

%% Raw Voltage Comparison
figure;
plot(s1_UnixTime,s1_rawAmp)