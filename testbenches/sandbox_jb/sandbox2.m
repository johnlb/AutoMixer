noise = normrnd(0,2.1e-5,L,1);
noise_rms = ampl2rms(noise,nwin);
ii = 1;
	thisWin = (ii-1)*M+1:(ii)*M;
	% thisWin = (ii-1)*M+1+814:(ii)*M;
	A 		= [x1(thisWin) x2(thisWin) x3(thisWin)];
	% A 		= A + repmat(noise(thisWin)/3,1,3);
	cond(A)
	alpha 	= A\t1(thisWin);

% 	A_rms 	= [x1_rms(thisWin) x2_rms(thisWin) x3_rms(thisWin)];
% 	% A_rms 	= A_rms + repmat(noise_rms(thisWin),1,3);
% 	alpha 	= A_rms\t1_rms(thisWin);

% alpha
% y1 = A*alpha;
% % y__rms = A_rms*alpha;

% figure(10);
% plot(t1(thisWin)); hold all;
% plot(y1); hold off;


% figure(11);
% subplot(311);
% plot(x1(thisWin));
% subplot(312);
% plot(x2(thisWin));
% subplot(313);
% plot(x3(thisWin));