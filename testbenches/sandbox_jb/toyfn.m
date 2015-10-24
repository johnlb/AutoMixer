%% toyfn: toy function, for testing things
function [y] = toyfn(x,tsamp,tau)
	
	nsamp 		= length(x);

	x = abs(x);


	[vals pks] = findpeaks(x);
	
	pks 			= [1 pks nsamp];
	vals 			= [0 vals 0];
	max_seglen 		= max(diff(pks));

	decay_kernel 	= exp(-(tsamp/tau).*(0:max_seglen-1));
	y 				= zeros(size(x));
	for ii = 1:length(pks)-1

		seg_len = pks(ii+1) - pks(ii);
		n 		= 1:seg_len;
		xptrs = pks(ii) + (n-1);

		thisDecay 	= vals(ii).*decay_kernel(1:seg_len);

		trackptrs 	= find(thisDecay <= x(xptrs));
		decayptrs 	= setdiff(n, trackptrs);

		trackptrs 	= pks(ii) + trackptrs;
		y(pks(ii) + decayptrs) 	= thisDecay(decayptrs);
		y(trackptrs) 			= x(trackptrs);

	end

end