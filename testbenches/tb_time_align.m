
%% Test time align
thiswin = 4e6:5e6;
winSize = 1e5;
nwins = floor(length(thiswin)/winSize);

thiswin(nwins*winSize+1:end) = [];

wins = 1 + bsxfun(@plus, (0:winSize-1)',winSize*(0:nwins-1));
x_temp = x(thiswin,:);


x_aligned = time_align(x_temp,t(thiswin,1),wins);

figure(10);
plotyy(thiswin,abs(t(thiswin,1)), thiswin,abs(x_aligned(:,1)));
title('kick')

figure(11);
plotyy(thiswin,abs(t(thiswin,1)), thiswin,abs(x_aligned(:,2)));
title('snare')

figure(12);
plotyy(thiswin,abs(t(thiswin,1)), thiswin,abs(x_aligned(:,3)));
title('hat')

figure(13);
plotyy(thiswin,abs(t(thiswin,1)), thiswin,abs(x_aligned(:,5)));
title('bass')


figure(14);
plotyy(thiswin,abs(t(thiswin,1)), thiswin,abs(x_aligned(:,6)));
title('guit')


figure(15);
plotyy(thiswin,abs(t(thiswin,1)), thiswin,abs(x_aligned(:,8)));
title('vox')