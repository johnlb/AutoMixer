winSize = 3000;
	N = size(x,1);
	K = size(x,2);
	nwins 	= floor(N/winSize);
	Ethresh = 10;
		L 		= nwins*winSize;


		x_temp = x;
		x_temp(L+1:end,:) = [];




%% Test time align
thiswin = 4e6:5e6;
winSize = 1e5;
nwins = floor(length(thiswin)/winSize);

thiswin(nwins*winSize+1:end) = [];

wins = 1 + bsxfun(@plus, (0:winSize-1)',winSize*(0:nwins-1));
x_temp = x(thiswin,:);


x_aligned = time_align(x_temp,t(thiswin,1),wins);

figure(10);
plot(thiswin,x_aligned(:,1), thiswin,t(thiswin,1));










%% Test goodtracks

% 	winE = sum( abs(reshape(x_temp,winSize,nwins,K)), 1);
% 	winE = reshape(winE,nwins,K)';
% 	goodtracks = sum( abs(reshape(x_temp,winSize,nwins,K)), 1) > Ethresh;
% 	goodtracks = reshape(goodtracks, nwins,K)';


% figure(10);
% plot(1:L,abs(x_temp(:,1)));
% hold all;
% stairs(1+winSize*(0:nwins-1),goodtracks(1,:));
% hold off;



% figure(11);
% plotyy(1:L,abs(x_temp(:,1)), 1+winSize*(0:nwins-1),winE(1,:));


