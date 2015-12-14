%%% hello.
clear valid_freq
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



AL = mixparam(XL,YL)';
AR = mixparam(XR,YR)';



% Plot stuff
figloc = './figs/';
K = size(AL,2);
freq = (fwin-1)*fs/FFT_LEN;


figure(1);
tracklist = [4 5];
titles = {'Bass Guitar EQ', 'Guitar EQ'};
% tracklist = 1:K;
L = length(tracklist);
for ii = 1:L
  subplot(ceil(L), 1, ii);
  semilogx(freq, 20.*log10(abs(AL(:,tracklist(ii)))), 'LineWidth',2, 'color',hex2rgb('#6170FF'));
  title(titles{ii});
  ylabel('Gain (dB)');
end
xlabel('Frequency (Hz)');

% figure(1);
% tracklist = [4 5];
% % tracklist = 1:K;
% L = length(tracklist);
% for ii = 1:L
%   subplot(ceil(L/2), 2, ii);
%   semilogx(freq, 20.*log10(abs(AL(:,tracklist(ii)))));
% end

saveas(gcf, [figloc 'valid-freq_2ch.png']);