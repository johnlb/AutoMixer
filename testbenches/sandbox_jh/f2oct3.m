function [ps3,cF] = f2oct3(y,fs,fftLen,bF,nOct)
cF = bF*2.^([nOct(1)*3:nOct(2)*3]/3)';
[nF,N] = size(y);
ps3 = zeros(length(cF),N);
fftLen = 1024;
f = fs*[0:ceil((fftLen-1)/2)]'/fftLen;
for n = 1:N
  ps3(:,n) = poct3(y(:,n),f,cF);
end