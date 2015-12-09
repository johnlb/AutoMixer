%%% hello.
clear sandbox

run('../../always.m');
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












%%%%%%%%%%%%%%%
% Plot stuff


figure(1);
subplot(411);
plot(abs(x1)); hold all;
plot(x1_rms); hold off;
% ylim([0 10]);
title('abs() & RMS of x1');
subplot(412);
plot(abs(x2)); hold all;
plot(x2_rms); hold off;
% ylim([0 10]);
title('abs() & RMS of x2');
subplot(413);
plot(abs(x3)); hold all;
plot(x3_rms); hold off;
% ylim([0 10]);
title('abs() & RMS of x3');
subplot(414);
plot(abs(t2)); hold all;
plot(t2_rms); hold off;
% ylim([0 10]);
title('abs() & RMS of t2');




figure(2);
plot(t2_rms); hold all;
% plot(y__rms*1.9); hold all;
% plot(y2_rms*2.4); hold off;
plot(y__rms); hold all;
plot(y2_rms); hold off;
legend('actual','estimated RMS','RMS of mixed signal');
title('Results of algorithm, RMS (R ch. only)')


figure(3);
% subplot(211);
% plot(t1);
% subplot(212);
% plot(y2*2.4);

plot(t2); hold all;
plot(y2); hold off;
legend('actual','mixed');
title('Results of algorithm, Time (R ch. only)')




figure(4);
subplot(211);
plot(alpha2(:,1));
ylim([-0 3]);
title('gain of x1 over time');
subplot(212);
plot(alpha2(:,2));
ylim([-0 3]);
title('gain of x3 over time');


% figure(5);
% plot(t1_rms); hold all;
% plot(x1_rms); hold all;
% plot(x2_rms); hold all;
% plot(x1_rms*.65*2.6 + x2_rms*0.3*2.6); hold off;
















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

% figure(5);
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