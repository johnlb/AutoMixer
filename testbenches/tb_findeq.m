%%% hello.
clear tb_findeq
clc;

run('../always.m');
init_hotelcalifornia();


twin = round(60/ts):round(3*90/ts);


% Find Frequency-domain Gains
[AL AR] = find_eq(xL(twin,:),xR(twin,:), tL(twin),tR(twin), ts);
fprintf('Filtering L Ch...\n');
xL_filt = fftfilt(ifft(AL(:,5)), xL(twin,5));
fprintf('Filtering R Ch...\n');
xR_filt = fftfilt(ifft(AR(:,5)), xR(twin,5));





% Plot stuff
figloc = './figs/';



figure(1);
plot(xL_filt);



% figure(1);
% % tracklist = [4 5];
% % titles = {'Bass Guitar EQ', 'Guitar EQ'};
% tracklist = 1:K;
% titles = {'Kick', 'Snare', 'Hat', 'Bass', 'Guitar', 'Vox'};
% L = length(tracklist);
% for ii = 1:L
%   subplot(ceil(L/2), 2, ii);
%   semilogx(freq, AL_mag(:,ii), 'LineWidth',2, 'color',hex2rgb('#6170FF'));
%   hold all;
%   semilogx(freq, AL_smoothed(:,ii));
%   hold off;

%   title(titles{ii});
%   ylabel('Gain (dB)');
% end
% xlabel('Frequency (Hz)');



% figure(2);
% subplot(211);
% semilogx(freq,20*log10(abs(AL_fir(:,1))), freq,AL_smoothed(:,1))
% subplot(212);
% semilogx(freq,angle(AL_fir(:,1)));
% % compare(AestL,hL);

