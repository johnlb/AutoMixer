function [ val ] = LEF( array, Fs )
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here
    %each frame is 20ms
    frame = 0.02 * Fs;
    num_frame = length(array)/frame;
    rms = RMS(array);
    count = 0;
    for i = 0:num_frame-1
        mini_array = array((i*frame)+1:(i+1) *frame);
        mini_rms = RMS(mini_array);
        if mini_rms < 0.5*rms
           count = count + 1;
        end
    end
        
    val = count/num_frame;

end
