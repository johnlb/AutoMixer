% sandbox
% close all;



chunk1 = chunk_class(3.214+0.1, 6.513, ts, 1);
chunk2 = chunk_class(6.515-0.1, 9.715, ts, 1);
chunk3 = chunk_class(9.718-0.1, 12.979, ts, 1);


nwin = round(.3e-3/ts);
x3_rms = ampl2rms(x3,nwin);
x3_rms = pk_det(x3_rms',ts,1e-3)';
% x3_rms = sqrt(x3.^2);

% x3_rms = pk_det(x3',ts,10e-3)';
% x3_rms = ampl2rms(x3_rms,nwin);

% nwin = round(.3e-3/ts);
% x1_rms = ampl2rms(x1,nwin);
% % x1_rms = abs(x1);




nwin = round(.3e-3/ts);
x1_rms = ampl2rms(x1,nwin);
x1_rms = pk_det(x1_rms',ts,1e-3)';













%% Try finding Sys
win1 = chunk1.get_win_ind()-win(1)+1;
win2 = chunk2.get_win_ind()-win(1)+1;
win3 = chunk3.get_win_ind()-win(1)+1;

win3(find(win3>L)) = [];

L_new = min([length(win1),length(win2),length(win3)]);
win1(L_new:end) = [];
win2(L_new:end) = [];
win3(L_new:end) = [];

A11 = fft(alpha2(win1,1));
A12 = fft(alpha2(win2,1));
A13 = fft(alpha2(win3,1));
A21 = fft(alpha2(win1,2));
A22 = fft(alpha2(win2,2));
A23 = fft(alpha2(win3,2));


x3_pk = pk_det(x3',ts,100e-3)';

% nwin = round(.3e-3/ts);
% x3_pk = ampl2rms(x3,nwin);

% nwin = round(10e-3/ts);
% x3_pk = ampl2rms(x3_pk,nwin);


X11 = fft(x1_rms(win1));
X12 = fft(x1_rms(win2));
X13 = fft(x1_rms(win3));
X21 = fft(x3_rms(win1));
X22 = fft(x3_rms(win2));
X23 = fft(x3_rms(win3));

X21_pk = fft(x3_pk(win1));
X22_pk = fft(x3_pk(win2));
X23_pk = fft(x3_pk(win3));


epsilon1 = 7e1;
epsilon2 = 9e1;
TF1 = [find_tf(X11,A11,epsilon1) find_tf(X12,A12,epsilon1) find_tf(X13,A13,epsilon1)];
TF2 = [find_tf(X21,A21,epsilon2) find_tf(X22,A22,epsilon2) find_tf(X23,A23,epsilon2)];

TF2_pk = [find_tf(X21_pk,A21,epsilon2) find_tf(X22_pk,A22,epsilon2) find_tf(X23_pk,A23,epsilon2)];


TF1_avg = mean(abs(TF1),2).*exp(j*mean(angle(TF1),2));
TF2_avg = mean(abs(TF2),2).*exp(j*mean(angle(TF2),2));
TF1_avg = mean(TF1,2);
TF2_avg = mean(TF2,2);

TF2_pk_avg = mean(TF2_pk,2);




%% predict shit

A11_ = TF1_avg.*X11;
A12_ = TF1_avg.*X12;
A13_ = TF1_avg.*X13;


A21_ = TF2_avg.*X21;
A22_ = TF2_avg.*X22;
A23_ = TF2_avg.*X23;

A21_pk = TF2_pk_avg.*X21;
A22_pk = TF2_pk_avg.*X22;
A23_pk = TF2_pk_avg.*X23;



a11 = ifft(A11_);
a12 = ifft(A12_);
a13 = ifft(A13_);


a21 = ifft(A21_);
a22 = ifft(A22_);
a23 = ifft(A23_);

a21_pk = ifft(A21_pk);
a22_pk = ifft(A22_pk);
a23_pk = ifft(A23_pk);


g = [[a21; a22; a23] [a21_pk; a22_pk; a23_pk]]\[alpha2(win1,1); alpha2(win2,1); alpha2(win3,1)];



%% plot shit


freqs = (0:L_new-1)*fs/(L_new-1);
fwin = 1:L_new/2;


figure(1);
subplot(211);
plot(freqs(fwin), abs(TF1(fwin,1)), freqs(fwin), abs(TF1(fwin,2)), freqs(fwin), abs(TF1(fwin,3)));
hold all;
plot(freqs(fwin), abs(TF1_avg(fwin,1)),'ro');
hold off;
xlim([0 10])

subplot(212);
plot(freqs(fwin), abs(TF2(fwin,1)), freqs(fwin), abs(TF2(fwin,2)), freqs(fwin), abs(TF2(fwin,3)));
hold all;
plot(freqs(fwin), abs(TF2_avg(fwin,1)),'ro');
hold off;
xlim([0 10])

figure(2);
subplot(211);
plot(freqs(fwin), abs(X12(fwin)))
xlim([0 50]);

subplot(212);
plot(freqs(fwin), abs(A12(fwin)))
xlim([0 50]);




time = (0:L_new-2)*ts;

figure(3);
subplot(311);
plot(time,alpha2(win1,1), time,a11);
subplot(312);
plot(time,alpha2(win2,1), time,a12);
subplot(313);
plot(time,alpha2(win3,1), time,a13);


% figure(4);
% subplot(311);
% plot(time,alpha2(win1,2), time,a21);
% subplot(312);
% plot(time,alpha2(win2,2), time,a22);
% subplot(313);
% plot(time,alpha2(win3,2), time,a23);


figure(4);
subplot(311);
plot(time,alpha2(win1,2), time,a21, time,a21_pk);
subplot(312);
plot(time,alpha2(win2,2), time,a22, time,a22_pk);
subplot(313);
plot(time,alpha2(win3,2), time,a23, time,a23_pk);


figure(5);
subplot(311);
plot(time,alpha2(win1,2), time,[a21 a21_pk]*g);
subplot(312);
plot(time,alpha2(win2,2), time,[a22 a21_pk]*g);
subplot(313);
plot(time,alpha2(win3,2), time,[a23 a21_pk]*g);






% x1_rms(1:2*4410) = [];
% x3_rms(1:2*4410) = [];
% alpha2(1:2*4410,:) = [];
% L = L-2*4410;


% x1_rms = [x1_rms(1)*ones(L_new,1); x1_rms];
% x3_rms = [x3_rms(1)*ones(L_new,1); x3_rms];


% a1 = conv(ifft(TF1_avg),x1_rms);
% a1(L+1:end) = [];
% a2 = conv(ifft(TF2_avg),x3_rms);
% a2(L+1:end) = [];
% time2 = (0:L-1)*ts;

% figure(6);
% subplot(211);
% plot(time2,alpha2(:,1), time2,a1);
% subplot(212);
% plot(time2,alpha2(:,2), time2,a2);