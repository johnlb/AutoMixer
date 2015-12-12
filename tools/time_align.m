
%% time_align: function description
function [x_aligned] = time_align(x,y,wins)

	winSize = size(wins,1);


	% Don't overrun/underrun
	pad = zeros(size(wins,1), size(x,2));
	x = [pad; x; pad];
	y = [pad(:,1); y; pad(:,1)];
	wins = [wins wins(:,end)+winSize, wins(:,end)+2*winSize];
	nwins = size(wins,2);


	L = size(x,1);
	K = size(x,2);

	% vectorize lookups
	xptrs = repmat((1:L)', 1,K);


	% initialize and loop
	x_aligned = zeros(size(x));
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

		% for kk = 1:K
		% 	% Wanted to vectorize, but if xwin isn't a perfect block of ones,
		% 	% x(xwin) spits out a vector instead of a matrix, like I hoped.
		% 	x_aligned(wins(:,ii),kk) = x(xwin(:,kk));
		% end
		x_aligned(wins(:,ii),:) = reshape(x(xwin), winSize,K);

		fprintf('%i/%i\n', ii-1, nwins-2);
	end


	% Cut off overrun/underrun buffer.
	x_aligned(L-winSize+1:end,:) = [];
	x_aligned(1:winSize,:) 		 = [];
end