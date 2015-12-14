%%% hello.
clear learning_time
clc;

run('../always.m');
init_hotelcalifornia();



%%%%%%%%%%%%
% Just look at one "chunk" 
% at a time, for now.


%%% 1st bass note
chunk1 = chunk_class(3.214-0.1, 6.513, ts, 1);

%%% 2nd bass note
chunk2 = chunk_class(6.515-0.1, 9.715, ts, 1);

%%% 3nd bass note
chunk3 = chunk_class(9.718-0.1, 12.979, ts, 1);

%%% all 3
chunkall = chunk_class(3.214+0.1, 12.979, ts, 1);


% chunk = chunk1;
chunk = chunkall;



win = chunk.get_win_ind();
L = length(win);







%%%%%%%%%%%%%
% Time alignment
%
% - Will probably have to
%	align each "chunk"
%	individually, to correct
% 	for small timing drift

[x_ t_] = chunk.get_aligned_data(x(:,5:7),t);
x1 = x_(:,1);
x2 = x_(:,2);
x3 = x_(:,3);

t1 = t_(:,1);
t2 = t_(:,2);






%%%%%%%%%%%%%%
% Calc RMS of signals.
%
% - Smooths out small inconsistencies
% 	between x & y (more input invariant)

nwin = round(0.2e-3/ts);

x1_rms = ampl2rms(x1,nwin);
x2_rms = ampl2rms(x2,nwin);
x3_rms = ampl2rms(x3,nwin);

t1_rms = ampl2rms(t1,nwin);
t2_rms = ampl2rms(t2,nwin);










% %%%%%%%%%%%%%%
% % Calc const. gains
% A_rms1 	= [x1_rms x2_rms];
% A1 		= [x1 x2];

% alpha1 = A_rms1\t1_rms;
% % alpha2 = A_rms\t2_rms;

% y__rms = A_rms1*alpha2;
% y2 = A1*alpha2;
% y2_rms = ampl2rms(y2,nwin);









%%%%%%%%%%%%%%
% Calc time-dep. gains

M = 3000;
NUM_WINS = floor( L/M );
alpha2 = [];
for ii = 1:NUM_WINS
	thisWin = (ii-1)*M+1:(ii)*M;

	A 		= [x1(thisWin) x2(thisWin) x3(thisWin)];
	A 		= [x1(thisWin) x3(thisWin)];
	alpha 	= A\t2(thisWin);

	A_rms 	= [x1_rms(thisWin) x2_rms(thisWin) x3_rms(thisWin)];
	A_rms 	= [x1_rms(thisWin) x3_rms(thisWin)];
	alpha 	= A_rms\t2_rms(thisWin);
	alpha 	= alpha;

	alpha2 	= [alpha2; repmat(alpha',M,1)];
end


% Smooth the gains we find.
alpha2(find(abs(alpha2)>3)) = 1;
alpha2(:,1) = smooth(alpha2(:,1),5*M);
alpha2(:,2) = smooth(alpha2(:,2),5*M);
% alpha2(:,3) = smooth(alpha2(:,3),5*M);



L = size(alpha2,1);
x1(L+1:end) = [];
x2(L+1:end) = [];
x3(L+1:end) = [];
t1(L+1:end) = [];
t2(L+1:end) = [];

x1_rms(L+1:end) = [];
x2_rms(L+1:end) = [];
x3_rms(L+1:end) = [];
t1_rms(L+1:end) = [];
t2_rms(L+1:end) = [];



if (size(alpha2,2) == 3)
	A1 		= [x1 x2 x3];
	A_rms1 	= [x1_rms x2_rms x3_rms];
else
	A1 		= [x1 x3];
	A_rms1 	= [x1_rms x3_rms];
end

y__rms = sum(A_rms1.*alpha2,2);
y2 = sum(A1.*alpha2,2);
y2 = y2*sqrt(2);

y2_rms = ampl2rms(y2,nwin);


% y__rms = y__rms*1.2;
% y2_rms = y2_rms*1.7;
% y2_rms = y2_rms*sqrt(2);















amax = [2 1];




% Fill in bad Data

tau = 0.25/ts;
rep = {109811+(0:38673)',	253532+(0:38983)', 	409514+(0:16485)'};
for ii = 1:length(rep)
	thisL = length(rep{ii});
	a0 = alpha2(rep{ii}(1));

	alpha2(rep{ii},1) = (a0 - amax(1))*exp(-(0:thisL-1)/tau) + amax(1);
end









% Plot stuff
figloc = './figs/';

time = (1:length(alpha2))*ts;



figure(1);
plot(time,0.5*x1/max(x1),				'color',hex2rgb('#89BEFF'));
hold all;
plot(time(1:end-1),alpha2(1:end-1,1),	'color',hex2rgb('#FF0000'), 'LineWidth', 2);
hold off;
% ylim([-0 3]);
title('Track 1');
xlabel('Time (s)');

fig = gcf;
fig.PaperUnits = 'inches';
fig.PaperPosition = [0 0 6 3];
fig.PaperPositionMode = 'manual';
saveas(gcf, [figloc 'learning-time_Track1.png']);




figure(2);
plot(time,0.5*x3/max(x3),					'color',hex2rgb('#89BEFF'));
hold all;
plot(time(1:end-1e4),alpha2(1:end-1e4,2),	'color',hex2rgb('#FF0000'), 'LineWidth', 2);
hold off;
% ylim([-0 2]);
title('Track 2');
xlabel('Time (s)');

fig = gcf;
fig.PaperUnits = 'inches';
fig.PaperPosition = [0 0 6 3];
fig.PaperPositionMode = 'manual';
saveas(gcf, [figloc 'learning-time_Track2.png']);


figure(3);
zwin = round(1.06)/ts:round(1.12/ts);
plot(time(zwin),0.5*x1(zwin)/max(x1),		'color',hex2rgb('#2386FF'), 'LineWidth', 2);
hold all;
plot(time(zwin),alpha2(zwin,1),				'color',hex2rgb('#FF0030'), 'LineWidth', 2);
hold off;
xlim([1.06 1.12]);
% ylim([-0 3]);
title(sprintf('Track 1 - 40ms window (%i samples)',length(zwin)));
xlabel('Time (s)');

% fig = gcf;
% fig.PaperUnits = 'inches';
% fig.PaperPosition = [0 0 6 3];
% fig.PaperPositionMode = 'manual';
saveas(gcf, [figloc 'learning-time_Track1zoom.png']);



figure(4);
subplot(211);
plot(time,0.5*t1/max(t1),				'color',hex2rgb('#FC9041'));
% plot(time,0.5*t1/max(t1),				'color',hex2rgb('#47FF6A'));
title('Mixed (L Channel)');
ylim([-1 1]);
% xlabel('Time (s)');
subplot(212);
plot(time,0.5*t2/max(t2),				'color',hex2rgb('#FC9041'));
% plot(time,0.5*t2/max(t2),				'color',hex2rgb('#47FF6A'));
title('Mixed (R Channel)');
xlabel('Time (s)');
ylim([-1 1]);

fig = gcf;
fig.PaperUnits = 'inches';
fig.PaperPosition = [0 0 6 3];
fig.PaperPositionMode = 'manual';
saveas(gcf, [figloc 'learning-time_Mixed.png']);