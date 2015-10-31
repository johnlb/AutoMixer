%%% hello.
clear sandbox

run('../../always.m');
init_hotelcalifornia();

<<<<<<< HEAD
=======
win = get_win_ind([10 11],ts);
>>>>>>> 5318f9b05c967f0969e955e2606973d474703efa


% 1st bass note
win = get_win_ind([3.214 6.513],ts);
win = get_win_ind([3.214 6.513] + [-0.1 0],ts);
% win = get_win_ind([3.214 6.513] + [-0.1 0.1],ts);

% 2nd bass note
win = get_win_ind([6.515 9.715],ts);
win = get_win_ind([6.515 9.715] + [-0.1 0],ts);

% 3nd bass note
win = get_win_ind([9.718 12.979],ts);
win = get_win_ind([9.718 12.979] + [-0.1 0],ts);



L = length(win);


figure(1);

xc1 = xcorr(x(win,5), t(win,1));
temp = find(abs(xc1)==max(abs(xc1)))-L;
dn1 = temp(1)
subplot(321);
plot(xc1);

dx1 = dn1;
px1 = xc1(dn1+L)/abs(xc1(dn1+L));


xc2 = xcorr(x(win,5), t(win,2));
temp = find(abs(xc2)==max(abs(xc2)))-L;
dn2 = temp(1)
subplot(322);
plot(xc2);

xc1 = xcorr(x(win,6), t(win,1));
temp = find(abs(xc1)==max(abs(xc1)))-L;
dn1 = temp(1)
subplot(323);
plot(xc1);

dx2 = dn1;
px2 = xc1(dn1+L)/abs(xc1(dn1+L));

xc2 = xcorr(x(win,6), t(win,2));
temp = find(abs(xc2)==max(abs(xc2)))-L;
dn2 = temp(1)
subplot(324);
plot(xc2);

xc1 = xcorr(x(win,7), t(win,1));
temp = find(abs(xc1)==max(abs(xc1)))-L;
dn1 = temp(1)
subplot(325);
plot(xc1);


xc2 = xcorr(x(win,7), t(win,2));
temp = find(abs(xc2)==max(abs(xc2)))-L;
dn2 = temp(1)
subplot(326);
plot(xc2);

dx3 = dn2;
px3 = xc2(dn2+L)/abs(xc2(dn2+L));




x1 = x(win+dx1,5)*px1;
x2 = x(win+dx2,6)*px2;
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



%% Try constant alpha

A = [x1 x2 x3];
alpha1 = t1\A;
alpha2 = t2\A;


y1 = A*alpha1';
y2 = A*alpha2';

figure(3);
ax1 = subplot(411);
plot(y1);
ax2 = subplot(412);
plot(y2);
ax3 = subplot(413);
plot(t1);
ax4 = subplot(414);
plot(t2);

linkaxes([ax1,ax2,ax3,ax4],'x');



%% Look at freq domain
FFT_LEN = 1024;
OVERLAP = FFT_LEN/4;
dt 		= (FFT_LEN-OVERLAP)*ts;
t_stft 	= 0:dt:(L-FFT_LEN);

X1 = STFT(x1,FFT_LEN,OVERLAP);
X2 = STFT(x1,FFT_LEN,OVERLAP);
X3 = STFT(x1,FFT_LEN,OVERLAP);
