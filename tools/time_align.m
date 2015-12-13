
%% time_align: function description
function [x_aligned, n_aligned] = time_align(x,y,wins)

	winSize = size(wins,1);
	K = size(x,2);

	% Don't overrun/underrun
	pad = zeros(size(wins,1), size(x,2));
	x = [pad; x; pad];
	y = [pad(:,1); y; pad(:,1)];
	n = repmat((1:size(x,1))', 1,K);
	wins = [wins wins(:,end)+winSize, wins(:,end)+2*winSize];
	nwins = size(wins,2);


	L = size(x,1);
	K = size(x,2);

	% vectorize lookups
	xptrs = repmat((1:L)', 1,K);


	% initialize and loop
	x_aligned = zeros(size(x));
	n_aligned = zeros(size(x));
	lag 	  = zeros(1,K);
	for ii = 2:nwins-1
		thiswin = (ii-1)*winSize + (0:winSize-1);
		for jj = 1:K
			[acor,corrx] = xcorr(x(thiswin,jj), y(thiswin));
			[~,ptr] = max(abs(acor));
			lag(jj) = corrx(ptr);
		end

		minind = xptrs(thiswin(1),:)   + lag;
		maxind = xptrs(thiswin(end),:) + lag;
		xwin = bsxfun(@ge, xptrs, minind)  &  bsxfun(@le, xptrs, maxind);

		% constuct output matricies
		x_aligned(wins(:,ii),:) = reshape(x(xwin), winSize,K);
		n_aligned(wins(:,ii),:) = reshape(n(xwin), winSize,K);

		fprintf('%i/%i\n', ii-1, nwins-2);
	end


	% Cut off overrun/underrun buffer.
	x_aligned(L-winSize+1:end,:) = [];
	x_aligned(1:winSize,:) 		 = [];

	n_aligned(L-winSize+1:end,:) = [];
	n_aligned(1:winSize,:) 		 = [];
	n_aligned = n_aligned - winSize;
end