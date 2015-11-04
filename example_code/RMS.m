function [ val ] = RMS( array )
%RMS returns the RMS value of the input array
%   Detailed explanation goes here
    array = array .^2;
    val = sum(array)./length(array);
    val = val .^ 0.5;
end
