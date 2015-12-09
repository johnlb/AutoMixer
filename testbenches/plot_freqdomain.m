%%% hello.
clear find_timedomain_gain

run('../always.m');
init_hotelcalifornia();


FFTLEN 		= 1024;
FFTOVERLAP 	= FFTLEN/4;
FFTSTEP 	= (FFTLEN - FFTOVERLAP)*ts;


% do stft & plot data.
X = batch_stft(x(10/ts:20/ts,:),FFTLEN,FFTOVERLAP);
plot_stft(X(:,:,6),FFTSTEP,ts,1);


% %---- 1/3 octave bands
% bF = 1000;
% nOct = [-4,4];
% [ps3,cF] = f2oct3(X,fs,FFTLEN,bF,nOct);


% figure(2);
% fTime = [0:N-1]*fftLen/2/fs;
% imagesc(fTime,[],ps3);
% set(gca,'ydir','normal');
% xlabel('time (s)');
% ylabel('frequency (Hz)');
% title('Power spectrum in 1/3 octave bands');
% set(gca,'ytick',1:3:nF);
% set(gca,'yticklabel',cF(1:3:end));
% colorbar;
% aps3 = aveoct3(ps3);
% figure(3)
% semilogx(cF,aps3,'-o');
% axis('tight');
% xlabel('frequency (Hz)');
% ylabel('average power spectrum');

