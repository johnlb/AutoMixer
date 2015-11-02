%%% hello.
clear sandbox

run('../../always.m');
init_hotelcalifornia();


% 1st bass note
win = get_win_ind([3.214 6.513],ts);
win = get_win_ind([3.214 6.513] + [-0.1 0],ts);
% win = get_win_ind([3.214 6.513] + [-0.1 0.1],ts);

% % 2nd bass note
% win = get_win_ind([6.515 9.715],ts);
% win = get_win_ind([6.515 9.715] + [-0.1 0],ts);

% % 3nd bass note
% win = get_win_ind([9.718 12.979],ts);
% win = get_win_ind([9.718 12.979] + [-0.1 0],ts);



L = length(win);


%%%%%%%%%%%%%
% Time alignment

xc1 = xcorr(x(win,5), t(win,1));
temp = find(abs(xc1)==max(abs(xc1)))-L;
dn1 = temp(1);
% subplot(321);
% plot(xc1);

dx1 = dn1+1;
px1 = xc1(dn1+L)/abs(xc1(dn1+L));


xc2 = xcorr(x(win,5), t(win,2));
temp = find(abs(xc2)==max(abs(xc2)))-L;
dn2 = temp(1);
% subplot(322);
% plot(xc2);

% dx1 = dn2;
% px1 = xc2(dn2+L)/abs(xc2(dn2+L));

xc1 = xcorr(x(win,6), t(win,1));
temp = find(abs(xc1)==max(abs(xc1)))-L;
dn1 = temp(1);
% subplot(323);
% plot(xc1);

dx2 = dn1+1;
px2 = xc1(dn1+L)/abs(xc1(dn1+L));


xc2 = xcorr(x(win,6), t(win,2));
temp = find(abs(xc2)==max(abs(xc2)))-L;
dn2 = temp(1);
% subplot(324);
% plot(xc2);

% dx2 = dn2+1;
% px2 = xc2(dn2+L)/abs(xc2(dn2+L));


xc1 = xcorr(x(win,7), t(win,1));
temp = find(abs(xc1)==max(abs(xc1)))-L;
dn1 = temp(1);
% subplot(325);
% plot(xc1);


xc2 = xcorr(x(win,7), t(win,2));
temp = find(abs(xc2)==max(abs(xc2)))-L;
dn2 = temp(1);
% subplot(326);
% plot(xc2);

dx3 = dn2+1;
px3 = xc2(dn2+L)/abs(xc2(dn2+L));


% dx1 = 0;
% dx2 = 0;
dx3 = -100;

x1 = x(win+dx1,5)*px1;
x2 = x(win+dx3,6)*px2;
x3 = x(win+dx3,7)*px3;

t1 = t(win,1);
t2 = t(win,2);









%%%%%%%%%%%%%%
% Calc RMS
nwin = round(01e-3/ts);

x1_rms = ampl2rms(x1,nwin);
x2_rms = ampl2rms(x2,nwin);
x3_rms = ampl2rms(x3,nwin);

t1_rms = ampl2rms(t1,nwin);
t2_rms = ampl2rms(t2,nwin);







% %%%%%%%%%%%%%%
% % Calc const. alphas
% A_rms1 	= [x1_rms x2_rms];
% A1 		= [x1 x2];

% alpha1 = A_rms1\t1_rms;
% % alpha2 = A_rms\t2_rms;

% y__rms = A_rms1*alpha2;
% y2 = A1*alpha2;
% y2_rms = ampl2rms(y2,nwin);



%%%%%%%%%%%%%%
% Calc time-dep. alphas
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

alpha2(find(abs(alpha2)>10)) = 1;
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










figure(1);
subplot(411);
plot(abs(x1)); hold all;
plot(x1_rms); hold off;
% ylim([0 10]);
subplot(412);
plot(abs(x2)); hold all;
plot(x2_rms); hold off;
% ylim([0 10]);
subplot(413);
plot(abs(x3)); hold all;
plot(x3_rms); hold off;
% ylim([0 10]);
subplot(414);
plot(abs(t2)); hold all;
plot(t2_rms); hold off;
% ylim([0 10]);




figure(2);
plot(t2_rms); hold all;
% plot(y__rms*1.9); hold all;
% plot(y2_rms*2.4); hold off;
plot(y__rms); hold all;
plot(y2_rms); hold off;
legend('actual','estimated, no mix','estimate, mixed');


figure(3);
% subplot(211);
% plot(t1);
% subplot(212);
% plot(y2*2.4);

plot(t2); hold all;
plot(y2); hold off;




figure(5);
subplot(211);
plot(alpha2(:,1));
ylim([-5 5]);
subplot(212);
plot(alpha2(:,2));
ylim([-5 5]);


% figure(5);
% plot(t1_rms); hold all;
% plot(x1_rms); hold all;
% plot(x2_rms); hold all;
% plot(x1_rms*.65*2.6 + x2_rms*0.3*2.6); hold off;

