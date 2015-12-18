%%% hello.
clear main_beth_rest


run('./always.m');
rec_name = 'beth_rest';
init_recording();



% twin = round(60/ts):round(3*90/ts);
% xL_ = xL(twin,:);
% xR_ = xR(twin,:);
% tL_ = tL(twin,:);
% tR_ = tR(twin,:);


% Find Frequency-domain Gains
[AL AR] = find_eq(xL,xR, tL,tR, ts);
xL_filt = zeros(size(xL));
xR_filt = zeros(size(xR));
for ii = 1:size(AL,2)
	fprintf('Filtering Track %i...\n',ii);
	xL_filt(:,ii) = fftfilt(ifft(AL(:,ii)), xL(:,ii));
	xR_filt(:,ii) = fftfilt(ifft(AR(:,ii)), xR(:,ii));
end





% Find Time-domain Gains
winsize = 3000;
[aL aR nL nR] = find_coeffs(xL_filt,xR_filt, tL,tR, ts, winsize,99);


% % Smooth the gains we find.
for ii = 1:size(aL,2)
	fprintf('Smoothing track %i\n',ii);
	aL(:,ii) = smooth(aL(:,ii),5*winsize);
	aR(:,ii) = smooth(aR(:,ii),5*winsize);
end


% Do mixing
yL = sum(aL.*xL_filt, 2);
yR = sum(aR.*xR_filt, 2);




% plot stuff
time = (0:length(x)-1)*ts;

plot_gains(time,aL,1);
plot_gains(time,aR,2);


figure(3);
plot(time,tL, time,yL);

figure(4);
plot(time,tR, time,yR);


% figure(5);
% plot(time,tL, time,yL_align);



audiowrite([DATA_PATH '/beth_rest/output/prediction.wav'],[yL yR],fs);