% %---- generate a pink-noise
% Nx = 2^16;  % number of samples to synthesize
% B = [0.049922035 -0.095993537 0.050612699 -0.004408786];
% A = [1 -2.494956002   2.017265875  -0.522189400];
% nT60 = round(log(1000)/(1-max(abs(roots(A))))); % T60 est.
% v = randn(1,Nx+nT60); % Gaussian white noise: N(0,1)
% x = filter(B,A,v);    % Apply 1/F roll-off to PSD
% x = x(nT60+1:end);    % Skip transient response
% %---- adding a 1000 Hz sinusoidal signal
% fs = 48000;
% t = [0:Nx-1]/fs;
% f1 = 2000;
% a = 0.05;
% s1 = a*sin(2*pi*f1*t);
% s = x'+s1';
% %---- wave file (or mp2 file) read and write
% fName = 'test.wav';
% audiowrite(fName,s,fs);
fName = 'MASTER.mp3';
[s,fs] = audioread(fName);
%%---- calculate the magnitude of frequency components
fftLen = 1024;
f = fs*[0:ceil((fftLen-1)/2)]'/fftLen;
y = STFT(s(:,1), fftLen, fftLen/2);
[nF,N] = size(y);
fTime = [0:N-1]*fftLen/2/fs;
figure(1);
imagesc(fTime,f,abs(y));
set(gca,'ydir','normal');
xlabel('time (s)');
ylabel('frequency (Hz)');
title('STFT');
colorbar;
%---- 1/3 octave bands
bF = 1000;
nOct = [-4,4];
[ps3,cF] = f2oct3(y,fs,fftLen,bF,nOct);
figure(2); imagesc(fTime,[],ps3);
set(gca,'ydir','normal');
xlabel('time (s)');
ylabel('frequency (Hz)');
title('Power spectrum in 1/3 octave bands');
set(gca,'ytick',1:3:nF);
set(gca,'yticklabel',cF(1:3:end));
colorbar;
aps3 = aveoct3(ps3);
figure(3)
semilogx(cF,aps3,'-o');
axis('tight');
xlabel('frequency (Hz)');
ylabel('average power spectrum');

