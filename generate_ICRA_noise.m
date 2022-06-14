clc
close all

% data_path = 'H:\Project\Current_Jobs\fNIRS\fNIRS_data\';
data_path = strcat(pwd,'/icra-files/');
addpath(data_path);
addpath(genpath(strcat(pwd,'/icra-files/liblsl-Matlab-master')));
% addpath(genpath('H:\Project\Current_Jobs\fNIRS\fNIRS_code\liblsl-Matlab-master'));

% assuming a compute volume of 40 (out of 100) on Windows
% manual factor to be multiplied by the test signals
amp = 9.5;

% Play time in sec
play_time = 10;

% Level difference between calibration tone and ICRA noise (track 1 to 10)
icra_gain_vect = [0 5.7 12.1 0 0 3 4.7 10.7 17.2 0];

% parameters for SPL calculation on the EAR (G.R.A.S.)
p0 = 20e-6; % Pa
gain = 40;  % dB
sensitivity = 11.19;  % device sensitivity mV/Pa
SPL_desired = 80;    % dB


% A 1-kHz calibration tone is available in the Track_10 of ICRA noise
track_num_tone = 10;
% ICRA noise track number
track_num_icra = 8;
% chunk selected form the given track (out of 5)
selected_chunk = 3;

SPL_tone = SPL_desired - icra_gain_vect(track_num_icra);    % dB

% ramp time to smooth the audio signals
t_ramp = 100e-3;

% figure size
figSize = [2 2 12 8];

% track_str = ['Track_' num2str(track_num_tone)];
track_str = [num2str(track_num_tone)];
load(['audio_stimuli_' track_str]);
audio_stim_tone = audio_stim;

% track_str = ['Track_' num2str(track_num_icra)];
track_str = [ num2str(track_num_icra)];
load(['audio_stimuli_' track_str]);
audio_stim_icra = audio_stim;
clear audio_stim

% RMS voltage to be observed on the oscilloscope
V_rms_osci = 10^(gain/20)*10^(SPL_tone/20)*p0*sensitivity;

fs = fs_audio_stim;
% test signals
sig_tone = audio_stim_tone(1:play_time*fs_audio_stim, 1, selected_chunk);
sig_icra = audio_stim_icra(1:play_time*fs_audio_stim, :, selected_chunk);

t = (0:length(sig_tone)-1)'/fs;

% create a hamming window and apply it to the signal
N_ramp = floor(t_ramp*fs);
hann_win = hanning(2*N_ramp);
sig_tone(1:N_ramp) = sig_tone(1:N_ramp) .* hann_win(1:N_ramp);
sig_tone(end-N_ramp+1:end) = sig_tone(end-N_ramp+1:end) .* hann_win(N_ramp+1:end);

sig_tone = amp * sig_tone;
audio_stim_icra = amp * audio_stim_icra;
sig_icra = amp * sig_icra;

sound(sig_tone, fs_audio_stim);
pause(play_time + 2);
sound(sig_icra, fs_audio_stim);

% plot(t, sig);
% 
% xlabel('Time (s)');
% ylabel('Amplitude (Pa)');
% set(gcf, 'Units', 'Centimeters', 'Position', figSize, 'PaperUnits', 'Centimeters',...
%     'PaperPosition', [0 0 figSize(3) figSize(4)],'PaperSize', [figSize(3) figSize(4)]);
% print('sample_ICRA_noise', '-dpdf', '-r300');


