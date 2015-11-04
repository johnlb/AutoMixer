function [ val ] = Energy( array )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
    array = abs(array);
    array = array .^2;
    val = sum(array);
end
