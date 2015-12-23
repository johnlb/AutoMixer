%% 4.2 Frequency coefficients estimation by STFT
%%
always; init_recording2;  % read audio data from real mixing tracks:
                         % song of 'hotel california' (150-200sec only)
                         % x: M track audio data
                         % t: 2 track master audio data
[data_len, M] = size(x); % data size
len = 1024;                % set parameter number (fft length)
f = fs*[0:len-1]/len;    % center frequencies of fft
fn = 1+len/2;            % available frequency number of fft
f = f(1:fn);             % available center frequencies
bF = 1000;               % base frequency for 1/3 octave band
nOct = [-4,4];           % + and - number of octaves
% calculate STFT and 1/3 octave band power spectra of mixing tracks
for m = 1:M
  X(:,:,m) = STFT(x(100001:110000,m),len,len/2);
  %X(:,:,m) = STFT(x(:,m),len,len/2);
  [ps3,cF] = f2oct3(X(:,:,m),fs,len,bF,nOct); aps3(:,m) = aveoct3(ps3);
end
[K,N,M] = size(X);                      % data size
M = M-3;% since some tracks are double for L and R
l_names = x_names([1,2,4,6,7,8]);
r_names = x_names([1,3,5,6,7,9]);
Xl = X(:,:,[1,2,4,6,7,8]);              % for left track
Xr = X(:,:,[1,3,5,6,7,9]);              % for right track
Xl_aps3 = aps3(:,[1,2,4,6,7,8]);
Xr_aps3 = aps3(:,[1,3,5,6,7,9]);
% calculate STFT of the master tracks
Yl = STFT(t(100001:110000,1),len,len/2);            % left master
Yr = STFT(t(100001:110000,2),len,len/2);            % right master
[ps3,cF] = f2oct3(Yl,fs,len,bF,nOct); Yl_aps3 = aveoct3(ps3);
[ps3,cF] = f2oct3(Yr,fs,len,bF,nOct); Yr_aps3 = aveoct3(ps3);
%figure(2); semilogx(cF,10*log10(Xl_aps3),'o-'); axis('tight');
%figure(2); semilogx(cF,Xl_aps3,'o-'); axis('tight');
% legend(l_names,'Location','SouthWest');
% xlabel('frequency (Hz)'); ylabel('power spectra');
% title('average 1/3 octaves power spectra of mixing tracks');
% figure(3); semilogx(cF,10*log10(Xr_aps3),'o-'); axis('tight');
%figure(3); semilogx(cF,Xr_aps3,'o-'); axis('tight');
% legend(r_names,'Location','SouthWest');
% xlabel('frequency (Hz)'); ylabel('power spectra');
% title('average 1/3 octaves power spectra of mixing tracks');

Al = mixparam2(Xl,Yl); % estimate mixing parameters for L track
Ar = mixparam2(Xr,Yr); % for R track

figure;
subplot(2,1,1); semilogx(f,20*log10(abs(Al))); axis('tight');
legend(l_names,'Location','EastOutside');
xlabel('frequency (Hz)'); ylabel('dB');
title('L master mixing coefficients');
subplot(2,1,2); semilogx(f,20*log10(abs(Ar))); axis('tight');
legend(r_names,'Location','EastOutside');
xlabel('frequency (Hz)'); ylabel('dB');
title('R master mixing coefficients');
%%
%% 1/3 octave mixing parameters
%%
% To reduce the parameters,
% we transfer the STFT parameters to 1/3 octave parameters.
% The number of parameters are significantly reduced to 25 points
% per track.
% The results are shown in the following figures.
%%
% for m = 1:M
%    [Al_ps3(:,m),cF] = f2oct3(Al(m,:)',fs,len,bF,nOct);
%    [Ar_ps3(:,m),cF] = f2oct3(Ar(m,:)',fs,len,bF,nOct);
% end
% figure(5); subplot(2,1,1); semilogx(cF,20*log10(sqrt(abs(Al_ps3))),'.-'); axis('tight');
% legend(l_names,'Location','EastOutside');
% xlabel('frequency (Hz)'); ylabel('dB');
% title('L master mixing coefficients in 1/3 octaves');
% subplot(2,1,2); semilogx(cF,20*log10(sqrt(abs(Ar_ps3))),'.-'); axis('tight');
% legend(r_names,'Location','EastOutside');
% xlabel('frequency (Hz)'); ylabel('dB');
% title('R master mixing coefficients in 1/3 octaves');