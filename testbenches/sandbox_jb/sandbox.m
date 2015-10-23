clear all


fs 		= 48e6;
tsamp 	= 1/fs;
Ttot 	= 0.01;
ampv 	= [-20 -1 -20];
ttrans 	= [Ttot/4 Ttot/2];
ftest 	= 1e3;



Nsamp 	= round(Ttot/tsamp);
Ttot 	= tsamp*Nsamp;
t 		= linspace(0,Ttot,Nsamp);



%%%%%%%%
% Generate test vector
ttrans_ptr 	= round(ttrans./tsamp);
seg_len 	= diff([0 ttrans_ptr Nsamp]);

t0 = 0;
xtest = [];
for ii = 1:length(seg_len)

	thisSeg = seg_len(ii);
	a0 = 10^(ampv(ii)/20);

	tseg = t0 + (0:tsamp:(thisSeg-1)*tsamp);
	seg = a0.*sin(2*pi*ftest.*tseg);

	xtest = [xtest seg];

	t0 = thisSeg*tsamp;
end



%%%%%%%%
% test things
y = toyfn(xtest,tsamp,10e-3,100e-3);



figure(1);
plot(t,xtest);
hold all;
plot(t,y);