clc
clear all
close all

%%
% data_path = 'H:\Project\Current_Jobs\fNIRS\fNIRS_data\';
% addpath(data_path);
% addpath(genpath('H:\Project\Current_Jobs\fNIRS\fNIRS_code\liblsl-Matlab-master'));
data_path = strcat(pwd,'/icra-files/');
addpath(data_path);
addpath(genpath(strcat(pwd,'/icra-files/liblsl-Matlab-master')));
addpath(genpath(strcat(pwd,'/icra-files/liblsl-Matlab-master/bin')));
addpath(genpath(strcat(pwd,'/liblsl-Matlab-master')));

% A 1-kHz calibration tone is available in the Track_10 of ICRA noise
track_num_tone = 10;
% ICRA noise track number
track_num_icra = 8;
% chunk selected form the given track (out of 5)
selected_chunk = 3;

session_n = 2;

SPLs = [20; 50; 80];
amp_fact = [0.5 1 3];
markers = {'A', 'B', 'C'};

nRep = 5;
isi_t = [20; 25; 30];
spare_time = 1;

% track_str = ['Track_' num2str(track_num_tone)];
% load(['audio_stimuli_' track_str]);
load(['audio_stimuli_' num2str(track_num_tone)]);
audio_stim_tone = audio_stim;

% track_str = ['Track_' num2str(track_num_icra)];
% load(['audio_stimuli_' track_str]);
load(['audio_stimuli_' num2str(track_num_icra)]);
audio_stim_icra = audio_stim;
clear audio_stim;

% smooth the audio data
smooth_t = 100e-3;

audio_stim_icra = Hanning_smooth(audio_stim_icra, smooth_t, fs_audio_stim);

nAll = length(SPLs)*nRep;
lin_SPLs = (1:length(SPLs))';

lin_stim_order = [];
lin_isi_order = [];

for i = 1:nRep
    lin_stim_order = [lin_stim_order; lin_SPLs(randperm(length(lin_SPLs)))];
    lin_isi_order = [lin_isi_order; randi(length(isi_t), 3, 1)];

end

stim_order = SPLs(lin_stim_order);
isi_order = isi_t(lin_isi_order);
markers_order = markers(lin_stim_order);

% instantiate the library
disp('Loading library...');
lib = lsl_loadlib();

disp('Creating a new marker stream info...');
info = lsl_streaminfo(lib, 'triggerMATLAB', 'Markers', 1, 0, 'cf_string');

disp('Opening an outlet...');
outlet = lsl_outlet(info);

% send markers into the outlet
disp('Now transmitting data...');

pause(spare_time);

for i = 1:nAll
    
    disp(['i = ' num2str(i) ' (out of ' num2str(nAll) '), marker = ', markers_order{i}]);
    
    % play the stimuli
    sound(amp_fact(lin_stim_order(i))*audio_stim_icra(:, :, randi(n_chunks)), fs_audio_stim);
    
    % send the trigger
    outlet.push_sample(markers_order(i));
    pause(chunk_t + isi_order(i)); 
end


save([data_path 'fNIRS_Loudness_stim_config_s_' num2str(session_n) '.mat'], ...
    'stim_order', 'lin_stim_order', 'isi_order', 'lin_isi_order', ...
    'session_n', 'nRep', 'nAll', 'SPLs');
