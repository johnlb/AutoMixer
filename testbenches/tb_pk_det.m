clear all

run('../always.m');

sig_type = 'pink';
% sig_type = 'sine';

fs 		= 48e6;
tsamp 	= 1/fs;
Ttot 	= 0.1;
ampv 	= [-20 -1 -20];
ttrans 	= [Ttot/4 Ttot/2];
ftest 	= 1e3;



Nsamp 	= round(Ttot/tsamp);
Ttot 	= tsamp*Nsamp;
t 		= linspace(0,Ttot,Nsamp);



%%%%%%%%
% Generate test vector

% Sine wave
ttrans_ptr 	= round(ttrans./tsamp);
seg_len 	= diff([0 ttrans_ptr Nsamp]);

t0 = 0;
xtest = [];
for ii = 1:length(seg_len)

	thisSeg = seg_len(ii);
	a0 = 10^(ampv(ii)/20);

	switch sig_type
		case 'sine'
			% Sine Wave
			tseg = t0 + (0:tsamp:(thisSeg-1)*tsamp);
			seg = a0.*sin(2*pi*ftest.*tseg);
			
		case 'pink'
			% Pink Noise
			H = dsp.ColoredNoise('SamplesPerFrame',seg_len(ii));
			seg = a0.*step(H)';

		otherwise
			error('Signal type must be either "sine" or "pink"');
	end

	xtest = [xtest seg];

	t0 = thisSeg*tsamp;
end







%%%%%%%%
% test things
y = pk_det(xtest,tsamp,10e-3);



figure(1);
plot(t,abs(xtest));
hold all;
plot(t,y);
hold off;