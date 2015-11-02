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


figure(1);

xc1 = xcorr(x(win,5), t(win,1));
temp = find(abs(xc1)==max(abs(xc1)))-L;
dn1 = temp(1);
subplot(321);
plot(xc1);

dx1 = dn1+1;
px1 = xc1(dn1+L)/abs(xc1(dn1+L));


xc2 = xcorr(x(win,5), t(win,2));
temp = find(abs(xc2)==max(abs(xc2)))-L;
dn2 = temp(1);
subplot(322);
plot(xc2);

% dx1 = dn2;
% px1 = xc2(dn2+L)/abs(xc2(dn2+L));

xc1 = xcorr(x(win,6), t(win,1));
temp = find(abs(xc1)==max(abs(xc1)))-L;
dn1 = temp(1);
subplot(323);
plot(xc1);

dx2 = dn1+1;
px2 = xc1(dn1+L)/abs(xc1(dn1+L));


xc2 = xcorr(x(win,6), t(win,2));
temp = find(abs(xc2)==max(abs(xc2)))-L;
dn2 = temp(1);
subplot(324);
plot(xc2);

% dx2 = dn2+1;
% px2 = xc2(dn2+L)/abs(xc2(dn2+L));


xc1 = xcorr(x(win,7), t(win,1));
temp = find(abs(xc1)==max(abs(xc1)))-L;
dn1 = temp(1);
subplot(325);
plot(xc1);


xc2 = xcorr(x(win,7), t(win,2));
temp = find(abs(xc2)==max(abs(xc2)))-L;
dn2 = temp(1);
subplot(326);
plot(xc2);

dx3 = dn2+1;
px3 = xc2(dn2+L)/abs(xc2(dn2+L));




x1 = x(win+dx1,5)*px1;
x2 = x(win+dx3,6)*px2;
x3 = x(win+dx3,7)*px3;

t1 = t(win,1);
t2 = t(win,2);




figure(2);
ax1 = subplot(311);
plot(x2);
ax2 = subplot(312);
plot(t1);
ax3 = subplot(313);
plot(t2);

linkaxes([ax1,ax2,ax3],'x');




%%% Look for gain value naively
alpha11 = sqrt(t1.^2./x1.^2);
alpha21 = sqrt(t1.^2./x2.^2);
alpha31 = sqrt(t1.^2./x3.^2);

N = 500;
n = 6068+(1:N);
figure(3);
subplot(311);
scatter(1:N,alpha11(n));
ylim([-10 10]);
subplot(312);
scatter(1:N,alpha21(n));
ylim([-10 10]);
subplot(313);
scatter(1:N,alpha31(n));
ylim([-10 10]);


figure(4);
subplot(311);
plot(1:N,x1(n));
% ylim([0 10]);
subplot(312);
plot(1:N,x2(n));
% ylim([0 10]);
subplot(313);
plot(1:N,x3(n));
% ylim([0 10]);

figure(5);
plot(1:N,t1(n));



%%% Try using RMS

N = 50000;
n = 6068+(1:N);
nwin = round(10e-3/ts);

figure(6);

x1_rms = ampl2rms(x1(n),nwin);
x2_rms = ampl2rms(x2(n),nwin);
x3_rms = ampl2rms(x3(n),nwin);

t1_rms = ampl2rms(t1(n),nwin);

subplot(411);
plot(abs(x1(n))); hold all;
plot(x1_rms); hold off;
% ylim([0 10]);
subplot(412);
plot(abs(x2(n))); hold all;
plot(x2_rms); hold off;
% ylim([0 10]);
subplot(413);
plot(abs(x3(n))); hold all;
plot(x3_rms); hold off;
% ylim([0 10]);
subplot(414);
plot(abs(t1(n))); hold all;
plot(t1_rms); hold off;
% ylim([0 10]);



% alpha11 = t1_rms./x2_rms;
% figure(7);
% scatter(1:N,alpha11);

A = [x1_rms x2_rms x3_rms];
alpha = t1_rms\A;


y__rms = A*alpha';
A = [x1(n) x2(n) x3(n)];
y1 = A*alpha';
y1_rms = ampl2rms(y1,nwin);

figure(8);
plot(t1_rms); hold all;
plot(y__rms*2.8); hold all;
plot(y1_rms*4.2); hold off;


figure(9);
subplot(211);
plot(t1(n));
subplot(212);
plot(y1.*2);











% %% Try constant alpha

% A = [x1 x2 x3];
% alpha1 = t1\A;
% alpha2 = t2\A;


% y1 = A*alpha1';
% y2 = A*alpha2';

% figure(3);
% ax1 = subplot(411);
% plot(y1);
% ax2 = subplot(412);
% plot(y2);
% ax3 = subplot(413);
% plot(t1);
% ax4 = subplot(414);
% plot(t2);

% linkaxes([ax1,ax2,ax3,ax4],'x');



% %% Look at freq domain
% FFT_LEN = 1024;
% OVERLAP = FFT_LEN/4;
% df 		= fs/2/FFT_LEN;
% dt 		= (FFT_LEN-OVERLAP)*ts;
% t_stft 	= 0:dt:(L-FFT_LEN);

% X1 = STFT(x1,FFT_LEN,OVERLAP);
% X2 = STFT(x2,FFT_LEN,OVERLAP);
% X3 = STFT(x3,FFT_LEN,OVERLAP);

% T1 = STFT(t1,FFT_LEN,OVERLAP);
% T2 = STFT(t2,FFT_LEN,OVERLAP);

% X1_ = (abs(X1));
% X2_ = (abs(X2));
% X3_ = (abs(X3));

% T1_ = (abs(T1));
% T2_ = (abs(T2));

% FWIN = 1:45;

% figure(4);
% subplot(511);
% imagesc(X1_(FWIN,:));
% subplot(512);
% imagesc(X2_(FWIN,:));
% subplot(513);
% imagesc(X3_(FWIN,:));
% subplot(514);
% imagesc(T1_(FWIN,:));
% subplot(515);
% imagesc(T2_(FWIN,:));



% %% Look for constant EQ curve
% X1_ = (abs(X1(FWIN,10+(1:25))));
% X2_ = (abs(X2(FWIN,8+(1:25))));
% X3_ = (abs(X3(FWIN,8+(1:25))));

% T1_ = (abs(T1(FWIN,9+(1:25))));
% T2_ = (abs(T2(FWIN,9+(1:25))));

% [M Lf] 	= size(X1_);
% N 		= 3;


% epsilon = 0.01;
% TF11 = calc_tf(X1,T1,epsilon);
% TF21 = calc_tf(X2,T1,epsilon);
% TF31 = calc_tf(X3,T1,epsilon);



% A = [];
% for ii = 1:M
% 	A_ = [	zeros((ii-1)*Lf,N);
% 			X1_(ii,:)' X2_(ii,:)' X3_(ii,:)';
% 			zeros((M-ii)*Lf,N);			];

% 	A = [A A_];
% end

% T = reshape(T1_,[M*Lf 1]);

% alpha = T\A;
% % alpha = A'*inv(A*A')*T;


% figure(5);
% % for ii=9+(1:20)
% % 	plot( abs(TF11(FWIN,ii)) );
% % 	hold all;
% % end
% % hold off;
% % ylim([0 5]);
% % xlim([0 10]);

% subplot(311);
% plot(abs(alpha(1:M)));
% subplot(312);
% plot(abs(alpha(M+(1:M))));
% subplot(313);
% plot(abs(alpha(2*M+(1:M))));



% Y = A*alpha';
% Y = reshape(Y,size(T1_'))';

% figure(6);
% subplot(211);
% imagesc( abs(Y) );
% subplot(212);
% imagesc( abs(T1_) );