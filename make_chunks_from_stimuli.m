clc
clear all
close all

% data_path = 'H:\Project\Current_Jobs\fNIRS\fNIRS_data\';
% track_num = 'Track_10';
% [sig, fs_audio_stim] = audioread([data_path track_num '.wav']);

data_path = strcat(pwd,'/icra-files/');


for track_num = 1:10
    
    % track_num = 10;
    try
        [sig, fs_audio_stim] = audioread([data_path sprintf('%02d - Track %d.wav', track_num, track_num)]);
    catch
        warning(sprintf('Track %d not found', track_num));
        continue;
    end

    % length of chunks in sec
    chunk_t = 20;
    chunk_sample = floor(chunk_t*fs_audio_stim);
    % number of chunks
    n_chunks = 5;
    L_div = floor(size(sig, 1)/n_chunks);

    start_index = randi(L_div - chunk_sample, n_chunks, 1);
    audio_stim = zeros(chunk_sample, 2, n_chunks);

    for i = 1:n_chunks
        audio_stim(:, :, i) = sig(start_index(i)+L_div*(i-1)+1 : start_index(i)+L_div*(i-1)+chunk_sample, :);
    end

    % sound(audio_stim(:, 1), fs);
    save([data_path 'audio_stimuli_' num2str(track_num) '.mat'], 'audio_stim', 'fs_audio_stim', 'chunk_t', 'n_chunks');


end
