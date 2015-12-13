% sandbox
% close all;
% clearvars -except alpha2 x1 x3 L
clc;

% alpha2_orig = alpha2;
alpha2 = alpha2_orig;

chunk1 = chunk_class(3.214+0.1, 6.513, ts, 1);
chunk2 = chunk_class(6.515-0.1, 9.715, ts, 1);
chunk3 = chunk_class(9.718-0.1, 12.979, ts, 1);







amax = [2 1];




% Fill in bad Data

tau = 0.25/ts;
rep = {109811+(0:38673)',	253532+(0:38983)', 	409514+(0:16485)'};
for ii = 1:length(rep)
	thisL = length(rep{ii});
	a0 = alpha2(rep{ii}(1));

	alpha2(rep{ii},1) = (a0 - amax(1))*exp(-(0:thisL-1)/tau) + amax(1);
end









%%%%%%%%%
% Generate source signals

nwin = round(.3e-3/ts);
x1_rms = ampl2rms(x1,nwin);
% x1_rms = pk_det(x1_rms',ts,1e-3)';

thresh1 = 10^(-10/20)*max(abs(x1_rms));

x1_rms = log( abs(x1)./thresh1 );
x1_rms(find(x1_rms<0)) = 0;
x1_rms = -x1_rms;




nwin = round(.3e-3/ts);
x3_rms = ampl2rms(x3,nwin);
% x3_rms = abs(x3);


thresh3 = 10^(-6/20)*max(abs(x3_rms));
x3_rms = log( abs(x3)./thresh3 );
x3_rms(find(x3_rms<0)) = 0;
x3_rms = -x3_rms;








% Find inputs/outputs of linear part of system
a = log(alpha2(:,1)./amax(1));
% u = x1_rms;



% Att sections
absx1 = abs(x1);
ptrs = find(absx1 > thresh1);
consecutive_ptrs = ptrs( find(diff(ptrs)==1) );
t_att = consecutive_ptrs;

z 		= a(t_att,1);
z_dot 	= a(t_att+1,1);
u 		= x1_rms(t_att);

coeffs_att = [z u]\z_dot;


% Rel sections
absx1 = abs(x1);
ptrs = find(absx1 <= thresh1);
consecutive_ptrs = ptrs( find(diff(ptrs)==1) );
t_rel = consecutive_ptrs;

z 		= alpha2(t_rel,1);
z_dot 	= alpha2(t_rel+1,1);
u 		= x1_rms(t_rel);

coeffs_rel = [z]\z_dot;



% run piecewise system
% quick and dirty.
c = zeros(size(x1,1),2);
c(t_rel,:) = repmat([coeffs_rel zeros(size(coeffs_rel))], size(t_rel,1),1);
c(t_att,:) = repmat(coeffs_att', size(t_att,1),1);
a_guess = zeros(size(x1));
for ii = 1:length(x1)-1
	a_guess(ii+1) = [a_guess(ii) absx1(ii)]*c(ii,:)';
end


alpha_ = exp(a_guess)*amax(1);



% % Find inputs/outputs of linear part of system
% a = [ log(alpha2(:,1)./amax(1)) 	log(alpha2(:,2)./amax(2)) ];
% v = [ x1_rms 	x3_rms ];


% data = {iddata(a(:,1),v(:,1),ts), iddata(a(:,2),v(:,2),ts)};
% udata = {iddata([],v(:,1),ts), iddata([],v(:,2),ts)};

% fprintf('finding system...');
% sys = ssest(data{1},2)
% ss_sys = ss(sys);


% fprintf('simulating system...');
% time2 = (0:L-1)*ts;
% a_ = lsim(ss_sys, v(:,1),time2);

% alpha_ = amax(1).*exp(a_);



% %%%%%%%%%
% % Do stuff

% % create all window indexes
% fft_size = 2^12;
% winstep = round(fft_size*(1/4));
% nwins = floor( (L-fft_size)/winstep );
% win_sweep = 1 + bsxfun(@plus, (0:fft_size-1)',winstep*(0:nwins-1));


% % w = hanning(fft_size);
% w = ones(fft_size,1);
% A = zeros(fft_size,2,nwins);
% X = zeros(fft_size,2,nwins);
% TF = zeros(fft_size,2,nwins);
% epsilon1 = 1e1;
% epsilon2 = 1e1;
% for ii = 1:nwins
% 	thiswin = win_sweep(:,ii);

% 	thisX = [fft(w.*x1_rms(thiswin)) fft(w.*x3_rms(thiswin))];
% 	thisA = [fft(w.*alpha2(thiswin,1)) fft(w.*alpha2(thiswin,2))];

% 	% take ffts for all windows
% 	X(:,:,ii) = thisX;
% 	A(:,:,ii) = thisA;
	
% 	% find TFs for all windows
% 	TF(:,:,ii) = [	find_tf(thisX(:,1), thisA(:,1),epsilon1) ...
% 					find_tf(thisX(:,2), thisA(:,2),epsilon2)	];


	
% end

% % average all TFs
% % TF_avg = mean(TF,3);
% TF_avg = mean(abs(TF),3).*exp(j*mean(angle(TF),3));


% % invert average, convolve
% ntracks = size(TF_avg,2);
% ir_avg = zeros(fft_size,ntracks);
% for ii = 1:ntracks
% 	ir_avg(:,ii) = ifft(TF_avg(:,ii));
% end

% a = zeros(fft_size,ntracks,nwins);
% for ii = 1:nwins
% 	thiswin = win_sweep(:,ii);

% 	thisa = [	conv(x1_rms(thiswin),ir_avg(:,1)) ...
% 				conv(x3_rms(thiswin),ir_avg(:,2))	];

% 	thisa(fft_size+1:end,:) = [];

% 	a(:,:,ii) = thisa;
% end


% a_all = [	conv(x1_rms,ir_avg(:,1)) ...
% 			conv(x3_rms,ir_avg(:,2))	];
% % a_all(1:,:) = [];
% % a_all(1:fft_size/2-1,:) = [];
% a_all(L+1:end,:) = [];









% %%%%%%%%%
% % Plot stuff

% % compare to desired IR at all windows

% time = (0:fft_size-1)*ts;

% ssect = 8;

% figure(1);
% subplot(311);
% plot(time,alpha2(win_sweep(:,ssect+1),1), time,a(:,1,ssect+1));
% subplot(312);
% plot(time,alpha2(win_sweep(:,ssect+2),1), time,a(:,1,ssect+2));
% subplot(313);
% plot(time,alpha2(win_sweep(:,ssect+3),1), time,a(:,1,ssect+3));



% figure(2);
% subplot(311);
% plot(time,alpha2(win_sweep(:,ssect+1),2), time,a(:,2,ssect+1));
% subplot(312);
% plot(time,alpha2(win_sweep(:,ssect+2),2), time,a(:,2,ssect+2));
% subplot(313);
% plot(time,alpha2(win_sweep(:,ssect+3),2), time,a(:,2,ssect+3));



% figure(3);
% subplot(211);
% plot(time2,alpha2(:,1), time2,(a_all(:,1)));

% subplot(212);
% plot(time2,alpha2(:,2), time2,a_all(:,2));

time2 = (0:L-1)*ts;


figure(1);
subplot(211);
plot(time2,x1_rms);
subplot(212);
plot(time2,x3_rms);



figure(2);
subplot(211);
plot(time2,alpha2(:,1));
subplot(212);
plot(time2,alpha2(:,2));



figure(4);
subplot(211);
plot(time2,x1_rms);
subplot(212);
plot(time2,x3_rms);

figure(5);
subplot(211);
plot(time2,alpha2(:,1)./amax(1));
subplot(212);
plot(time2,alpha2(:,2)./amax(2));


figure(6);
subplot(211);
plot(time2,log(alpha2(:,1)./amax(1)));
subplot(212);
plot(time2,log(alpha2(:,2)./amax(2)));

% 
% figure(6);
% subplot(211);
% plot(t1_rms);



figure(7);
subplot(211);
plot(time2,a,time2,a_guess);
subplot(212);
plot(time2,alpha2(:,1),time2,alpha_);