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

