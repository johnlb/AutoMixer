%%% hello.
clear learning_freq
clc;

run('../always.m');
init_hotelcalifornia();


twin = round(2/ts):round(22/ts);
fwin = 1:80;

N 			= size(x,1);
K 			= size(x,2);
FFT_LEN 	= 8192;
FFT_OVL 	= round(FFT_LEN/4);
FFT_STEP	= FFT_LEN-FFT_OVL;


% for k = 1:K
%   X(:,:,k) = STFT(x(twin,k), FFT_LEN,FFT_OVL);
% end
x1 = x(twin,5);
X1 = STFT(x1, FFT_LEN,FFT_OVL);
X1 = abs(X1(fwin,:));

x2 = x(twin,6);
X2 = STFT(x2, FFT_LEN,FFT_OVL);
X2 = abs(X2(fwin,:));

[~, Nf, ~] = size(X1);
Y1 = STFT(t(twin,1), FFT_LEN,FFT_OVL);
Y1 = abs(Y1(fwin,:));
Y2 = STFT(t(twin,2), FFT_LEN,FFT_OVL);
Y2 = abs(Y2(fwin,:));







% Plot stuff
figloc = './figs/';

time = (1:Nf)*FFT_STEP*ts;
freq = (fwin-1)*fs/FFT_LEN;

f1 = find(freq<190);
f1 = f1(end);

ymax = 50;


figure(1);
imagesc(time,freq,X1);
title('Track 1');
xlabel('Time (s)');
ylabel('Frequency (Hz)');

saveas(gcf, [figloc 'learning-freq_Track1.png']);




figure(2);
imagesc(time,freq,X2);
title('Track 2');
xlabel('Time (s)');
ylabel('Frequency (Hz)');

saveas(gcf, [figloc 'learning-freq_Track2.png']);





figure(3);
subplot(211);
plot(time,X1(f1,:),		'color',hex2rgb('#2386FF'), 'LineWidth', 2);
title(sprintf('Track 1 @ f = %fHz', freq(f1)));
% xlabel('Time (s)');
ylabel('Amplitude');
ylim([0 ymax]);

subplot(212);
plot(time,X2(f1,:),		'color',hex2rgb('#2386FF'), 'LineWidth', 2);
title(sprintf('Track 2 @ f = %fHz', freq(f1)));
xlabel('Time (s)');
ylabel('Amplitude');
ylim([0 ymax]);

saveas(gcf, [figloc 'learning-freq_Trackzoom.png']);




figure(4);
plot(time,Y1(f1,:),		'color',hex2rgb('#2386FF'), 'LineWidth', 2);
title(sprintf('Mix, L ch. @ f = %fHz', freq(f1)));
xlabel('Time (s)');
ylabel('Amplitude');

saveas(gcf, [figloc 'learning-freq_Mixed.png']);