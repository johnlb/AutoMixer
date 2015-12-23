function [ps3,cF] = f2oct3(y,fs,fftLen,bF,nOct)
% y, STFT of dimension nFxN
% fs, sampling frequency
% fftlen
% bF, base frequency of 1/3 octave
% nOct, +, - number of octaves
cF = bF*2.^([nOct(1)*3:nOct(2)*3]/3)';  % calculate the center frequencies
[nF,N] = size(y);                       % dimension of input y
ps3 = zeros(length(cF),N);              %
f = fs*[0:ceil((fftLen-1)/2)]'/fftLen;  % center frequency of y
for n = 1:N
  ps3(:,n) = poct3(y(:,n),f,cF);        % transform from STFT to 1/3 octaves
end