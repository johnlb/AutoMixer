winSize = 3000;
	N = size(x,1);
	K = size(x,2);
	nwins 	= floor(N/winSize);
	Ethresh = 10;
		L 		= nwins*winSize;


		x_temp = x;
		x_temp(L+1:end,:) = [];








%% Test goodtracks

	winE = sum( abs(reshape(x_temp,winSize,nwins,K)), 1);
	winE = reshape(winE,nwins,K)';
	goodtracks = find_goodtracks(reshape(x_temp,winSize,nwins,K),Ethresh);


figure(10);
plot(1:L,abs(x_temp(:,1)));
hold all;
stairs(1+winSize*(0:nwins-1),goodtracks(1,:));
hold off;



figure(11);
plotyy(1:L,abs(x_temp(:,1)), 1+winSize*(0:nwins-1),winE(1,:));


