clear all

run('../always.m');

%%%%%%%%
% DUT settings

thresh 		= -6;
ratio 		= 3;
att 		= 10e-3;
rel 		= 100e-3/4;
env_type 	= 'peak';




%%%%%%%%
% Test Vector settings

sig_type = 'pink';
sig_type = 'sine';

fs 		= 48e6;
tsamp 	= 1/fs;
Ttot 	= 0.1;
ampv 	= [-20 -1 -20];
ttrans 	= [Ttot/4 Ttot/2];
ftest 	= 1e3;



Nsamp 	= round(Ttot/tsamp);
Ttot 	= tsamp*Nsamp;
t 		= linspace(0,Ttot,Nsamp);

knobs = struct(	'thresh',thresh, 'ratio',ratio, 'att',att, ...
				'rel',rel, 'env_type',env_type	);




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%
% Generate test vector

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
			seg = a0.*step(H)'./8;

		otherwise
			error('Signal type must be either "sine" or "pink"');
	end

	xtest = [xtest seg];

	t0 = thisSeg*tsamp;
end







%%%%%%%%
% test things

y = comp(xtest,tsamp,knobs);





%%%%%%%%
% plot things

figure(1);
plot(t,abs(xtest));
hold all;
plot(t,y);
hold off;