% sandbox
% close all;
% clearvars -except alpha2 x1 x3 L
clc;



chunk1 = chunk_class(3.214+0.1, 6.513, ts, 1);
chunk2 = chunk_class(6.515-0.1, 9.715, ts, 1);
chunk3 = chunk_class(9.718-0.1, 12.979, ts, 1);





nwin = round(.3e-3/ts);
x1_rms = ampl2rms(x1,nwin);
% x1_rms = pk_det(x1_rms',ts,1e-3)';

thresh1 = 10^(-15/20)*max(abs(x1_rms));
x1_rms(find(x1_rms < thresh1)) = thresh1;



nwin = round(.3e-3/ts);
x3_rms = ampl2rms(x3,nwin);
% x3_rms = abs(x3);


thresh3 = 10^(-20/20)*max(abs(x1_rms));
x3_rms(find(x3_rms < thresh3)) = thresh3;



% create all window indexes
fft_size = 2^12;
winstep = round(fft_size*(1/4));
nwins = floor( (L-fft_size)/winstep );
win_sweep = 1 + bsxfun(@plus, (0:fft_size-1)',winstep*(0:nwins-1));


% w = hanning(fft_size);
w = ones(fft_size,1);
A = zeros(fft_size,2,nwins);
X = zeros(fft_size,2,nwins);
TF = zeros(fft_size,2,nwins);
epsilon1 = 1e1;
epsilon2 = 1e1;
for ii = 1:nwins
	thiswin = win_sweep(:,ii);

	thisX = [fft(w.*x1_rms(thiswin)) fft(w.*x3_rms(thiswin))];
	thisA = [fft(w.*alpha2(thiswin,1)) fft(w.*alpha2(thiswin,2))];

	% take ffts for all windows
	X(:,:,ii) = thisX;
	A(:,:,ii) = thisA;
	
	% find TFs for all windows
	TF(:,:,ii) = [	find_tf(thisX(:,1), thisA(:,1),epsilon1) ...
					find_tf(thisX(:,2), thisA(:,2),epsilon2)	];


	
end

% average all TFs
TF_avg = mean(TF,3);


% invert average, convolve
ntracks = size(TF_avg,2);
ir_avg = zeros(fft_size,ntracks);
for ii = 1:ntracks
	ir_avg(:,ii) = ifft(TF_avg(:,ii));
end

a = zeros(fft_size,ntracks,nwins);
for ii = 1:nwins
	thiswin = win_sweep(:,ii);

	thisa = [	conv(x1_rms(thiswin),ir_avg(:,1)) ...
				conv(x3_rms(thiswin),ir_avg(:,2))	];

	thisa(fft_size+1:end,:) = [];

	a(:,:,ii) = thisa;
end


a_all = [	conv(x1_rms,ir_avg(:,1)) ...
			conv(x3_rms,ir_avg(:,2))	];
a_all(1:fft_size/2-1,:) = [];
a_all(L+1:end,:) = [];



% compare to desired IR at all windows

time = (0:fft_size-1)*ts;

ssect = 8;

figure(1);
subplot(311);
plot(time,alpha2(win_sweep(:,ssect+1),1), time,a(:,1,ssect+1));
subplot(312);
plot(time,alpha2(win_sweep(:,ssect+2),1), time,a(:,1,ssect+2));
subplot(313);
plot(time,alpha2(win_sweep(:,ssect+3),1), time,a(:,1,ssect+3));



figure(2);
subplot(311);
plot(time,alpha2(win_sweep(:,ssect+1),2), time,a(:,2,ssect+1));
subplot(312);
plot(time,alpha2(win_sweep(:,ssect+2),2), time,a(:,2,ssect+2));
subplot(313);
plot(time,alpha2(win_sweep(:,ssect+3),2), time,a(:,2,ssect+3));


time2 = (0:L-1)*ts;

figure(3);
subplot(211);
plot(time2,alpha2(:,1), time2,a_all(:,1));

subplot(212);
plot(time2,alpha2(:,2), time2,a_all(:,2));
