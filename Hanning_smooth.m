function data_in = Hanning_smooth(data_in, rise_time, fs)

L_rise = floor(fs*rise_time);
hann_win = hann(2*L_rise);

if iscell(data_in)
    
    for i = 1:length(data_in)
        data_in{i}(1:L_rise, :) = data_in{i}(1:L_rise, :) .* hann_win(1:L_rise);
        data_in{i}(end-L_rise+1:end, :) = data_in{i}(end-L_rise+1:end, :) .* hann_win(L_rise+1:end);
    end
    
elseif ismatrix(data_in)
    data_in(1:L_rise, :) = data_in(1:L_rise, :) .* hann_win(1:L_rise);
    data_in(end-L_rise+1:end, :) = data_in(end-L_rise+1:end, :) .* hann_win(L_rise+1:end);
    
elseif isvector(data_in)
    data_in(1:L_rise) = data_in(1:L_rise) .* hann_win(1:L_rise);
    data_in(end-L_rise+1:end) = data_in(end-L_rise+1:end) .* hann_win(L_rise+1:end);
    
end