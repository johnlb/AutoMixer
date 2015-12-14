%%% hello.
clear tb_freqdomain
clc;

run('../always.m');
init_hotelcalifornia();



N       = size(x,1);
K       = size(x,2);

FFT_LEN   = 8192;
FFT_OVL   = round(FFT_LEN/4);
FFT_STEP  = FFT_LEN-FFT_OVL;


twin = round(60/ts):round(90/ts);
fwin = 1:FFT_LEN/2+1;
freq = (fwin-1)*fs/FFT_LEN;





for k = 1:K
  fprintf('Doing STFT for Track %i\n', k);
  X(:,:,k) = STFT(x(twin,k), FFT_LEN,FFT_OVL);
end
X = abs(X(fwin,:,:));


[~, Nf, ~] = size(X);
YL = STFT(t(twin,1), FFT_LEN,FFT_OVL);
YL = abs(YL(fwin,:));
YR = STFT(t(twin,2), FFT_LEN,FFT_OVL);
YR = abs(YR(fwin,:));

XL = X(:,:,pan(:,1));
XR = X(:,:,pan(:,2));
K  = size(XL,3);



AL = mixparam(XL,YL)';
AR = mixparam(XR,YR)';




AL_mag = 20.*log10(abs(AL));
AR_mag = 20.*log10(abs(AR));



fprintf('Smoothing frf\n');
for ii = 1:K
	[AL_smoothed(:,ii) AL_oct(:,ii)] = generate_smooth_tf(freq,AL_mag(:,ii));
	[AR_smoothed(:,ii) AR_oct(:,ii)] = generate_smooth_tf(freq,AR_mag(:,ii));
end




% fprintf('Estimating Filters\n');
% hL = idfrd(10.^(AL_smoothed(:,1)/20),freq,ts);
% AestL = ssest(hL,10,'DisturbanceModel','estimate');


% Find FIR filter
for ii = 1:K
	AL_fir(:,ii) = gain2fir(AL_smoothed,1);
	AR_fir(:,ii) = gain2fir(AR_smoothed,1);
end
AL_fir_ = AL_fir(1:FFT_LEN/2+1,:);
AR_fir_ = AR_fir(1:FFT_LEN/2+1,:);


% Plot stuff
figloc = './figs/';


figure(1);
% tracklist = [4 5];
% titles = {'Bass Guitar EQ', 'Guitar EQ'};
tracklist = 1:K;
titles = {'Kick', 'Snare', 'Hat', 'Bass', 'Guitar', 'Vox'};
L = length(tracklist);
for ii = 1:L
  subplot(ceil(L/2), 2, ii);
  semilogx(freq, AL_mag(:,ii), 'LineWidth',2, 'color',hex2rgb('#6170FF'));
  hold all;
  semilogx(freq, AL_smoothed(:,ii));
  hold off;

  title(titles{ii});
  ylabel('Gain (dB)');
end
xlabel('Frequency (Hz)');



figure(2);
subplot(211);
semilogx(freq,20*log10(abs(AL_fir_(:,1))), freq,AL_smoothed(:,1))
subplot(212);
semilogx(freq,angle(AL_fir_(:,1)));
% compare(AestL,hL);

