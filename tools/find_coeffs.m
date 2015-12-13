%% find_coeffs: finds time-varying coefficients s.t. y = sum(x.*a)
function [aL aR] = find_coeffs(xL,xR, yL,yR, ts, winSize, nwins_ta, interp_method)


	if (nargin<8)
		interp_method = 'pchip';
	end


	N 		= size(xL,1);
	K 		= size(xL,2);
	Ethresh = 10;

	aL 		= zeros(N,K);
	aR 		= zeros(N,K);
	n 		= (1:N)';

% {
	% Time alignment window should at least as big as the minimum possible timing offset,
	% 	so we catch at least one big feature in both x and y.
	% It should also be an integer multiple of the coeff window so that any seams in the data
	% 	don't corrupt the coefficients.
	
	% nwins 	= floor(N/winSize);
	% L 		= nwins*winSize;
	% winSize_ta  = find_next_divisor(nwins, 1e7/winSize);
	% nwins_ta 	= L/winSize_ta;

	[nwins_ta winSize_ta nwins winSize] = find_window_sizes(nwins_ta, winSize, N);
	
	L = nwins_ta*winSize_ta;





	% Trim unused bits.
	% We already initialized a to 0,
	% so output will still be N x K
	xL(L+1:end,:) = [];
	xR(L+1:end,:) = [];
	
	yL(L+1:end,:) = [];
	yR(L+1:end,:) = [];



	% Generate all window pointers
	wins 			= 1 + bsxfun(@plus, (0:winSize-1)',winSize*(0:nwins-1));
	wins_timealign  = 1 + bsxfun(@plus, (0:winSize_ta-1)',winSize_ta*(0:nwins_ta-1));



fprintf('Running time alignment...\n');
	% Find time alignment for whole track
	[xL nL] = time_align(xL,yL, wins_timealign);
	[xR nR] = time_align(xR,yR, wins_timealign);



fprintf('Caluclating RMS...\n');
	% Calc RMS
	rmswin = round(0.2e-3/ts);

	xL = ampl2rms(xL,rmswin);
	xR = ampl2rms(xR,rmswin);

	yL = ampl2rms(yL,rmswin);
	yR = ampl2rms(yR,rmswin);

% save('./state/find_coeffs-rms.mat');
%}

% load('./state/find_coeffs-rms.mat');


fprintf('Caluclating Coefficients...\n');
	% Choose set of tracks that have data in them (for each window)
	% goodtracks = K x nwins
	goodtracksL = find_goodtracks(reshape(xL,winSize,nwins,K), Ethresh);
	goodtracksR = find_goodtracks(reshape(xR,winSize,nwins,K), Ethresh);
	

	% for each window
	aL_win = zeros(K,nwins);
	aR_win = zeros(K,nwins);
	nL_win = zeros(K,nwins);
	nR_win = zeros(K,nwins);
	wins_mid = wins(round(winSize/2),:);
	for ii = 1:nwins
		% calc gain
		aL_win(goodtracksL(:,ii),ii) = xL(wins(:,ii),goodtracksL(:,ii))\yL(wins(:,ii));
		aR_win(goodtracksR(:,ii),ii) = xR(wins(:,ii),goodtracksR(:,ii))\yR(wins(:,ii));
		% aL(wins(:,ii),goodtracksL(:,ii)) = repmat( xL(wins(:,ii),goodtracksL(:,ii))\yL(wins(:,ii)), 1,winSize )';
		% aR(wins(:,ii),goodtracksR(:,ii)) = repmat( xR(wins(:,ii),goodtracksR(:,ii))\yR(wins(:,ii)), 1,winSize )';

		% calc time points for each window
		nL_win(goodtracksL(:,ii),ii) = nL(wins_mid(ii),goodtracksL(:,ii));
		nR_win(goodtracksR(:,ii),ii) = nR(wins_mid(ii),goodtracksR(:,ii));

		if (mod(ii,nwins/10) < 1)
			fprintf('%i%%...',round(100*ii/nwins));
		end
	end
	aL_win = abs(aL_win');
	aR_win = abs(aR_win');
	nL_win = 	 nL_win';
	nR_win = 	 nR_win';



fprintf('done.\n');


fprintf('Interpolating data...\n');

	for ii = 1:K
		fprintf('Track %i\n',ii);

		% only include valid data
		ptrsL = find(nL_win(:,ii)>0);
		ptrsR = find(nR_win(:,ii)>0);

		% figure(10); plot(nL_win(ptrsL));
		aL(:,ii) = interp1([1; nL_win(ptrsL,ii); n(end)],[0; aL_win(ptrsL,ii); 0], ...
							n, interp_method);
		aR(:,ii) = interp1([1; nR_win(ptrsR,ii); n(end)],[0; aR_win(ptrsR,ii); 0], ...
							n, interp_method);
	end

end




%% find_next_divisor: searches for next highest number s.t. num/result = integer
function [result] = find_next_divisor(num,den)

	result = ceil(den);
	direction = +1;
	while( (num/result - round(num/result)) ~= 0 )
		result = result + direction;

		if (result > num)
			direction = -1;
		end
		
		if (den > num)
			error('There are no divisors.');
		end
	end

end




%% find_window_sizes: searches for best match to given window parameters s.t. there are
%% 						an winSize_ta/winSize is an integer
%% 						(ie. there are an integer number of small windows in each big one)
function [nwins_ta winSize_ta nwins winSize] = find_window_sizes(nwins_ta, winSize, N);

	bounds 		= [ winSize*(3/2) 	winSize*(1/2) ];
	direction 	= -1;
	done 		= false;
	while (~done)
		winSize_ta  = floor(N/nwins_ta);
		L 			= nwins_ta*winSize_ta;
		winSize		= find_next_divisor(winSize_ta,winSize/2);


		if (winSize<bounds(1) & winSize>bounds(2))
			done = true;
		else
			nwins_ta = nwins_ta + direction;
		end

		if (nwins_ta == 1)
			direction = +1;
		end

		if (nwins_ta > 1000)
			error('Solution to window size not found');
		end
	end
	nwins 		= L/winSize;

	nwins_ta
	winSize

end
