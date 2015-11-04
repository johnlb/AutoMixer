function [ val ] = ZCR( array, Fs )
%UNTITLED9 Summary of this function goes here
%   Detailed explanation goes here
    count = 0;
    if array(1) >= 0 
        z = 1;
    else
        z = 0;
    end
    
    
    for i = 2:length(array)
        if array(i) >=0
            z_new = 1;
        else
            z_new = 0;
        end
        if z_new == z;
            count  = count + 1;
        end
        z = z_new;
    end
    
    val = Fs* count/(length(array)-1);
end
