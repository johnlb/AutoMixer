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

