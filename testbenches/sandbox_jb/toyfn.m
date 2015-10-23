%% toyfn: toy function, for testing things
function [y] = toyfn(x,tsamp,att,rel)
	
	tau 		= 1e-3;
	winsize 	= 1e-3;
	
	nsamp 		= length(x);
	winwidth 	= round(winsize/tsamp);

	win1 = x(1:winwidth);

	x = abs(x);


	[vals pks] = findpeaks(x);
	
	pks 			= [1 pks nsamp];
	vals 			= [0 vals 0];
	max_seglen 		= max(diff(pks));
length(pks)
	decay_kernel 	= exp(-tau*tsamp.*(0:max_seglen-1));
	y 				= zeros(size(x));
	for ii = 1:length(pks)-1
ii
		seg_len = pks(ii+1) - pks(ii);
		n 		= 1:seg_len;
		xptrs = pks(ii) + (n-1);


		thisDecay 	= vals(ii).*decay_kernel(1:seg_len);
		xover_ptr 	= min(find(thisDecay<x(xptrs)));
		xover_ptr 	= ceil(xover_ptr);

		decayptrs	= 1:xover_ptr-1;
		trackptrs 	= pks(ii) + (xover_ptr:seg_len);
		if (isempty(decayptrs) && isempty(trackptrs))
			figure(10);
			plot(thisDecay);
			hold all;
			plot(x(trackptrs));
			hold off;
		end

		y(xptrs) 	= [thisDecay(decayptrs) x(trackptrs)];

	end

	% for ii = 1:nsamp
	% 	if (mod(ii,1000)==0)
	% 		ii
	% 	end
	% 	if (ii > nsamp-winwidth-1)
	% 		thisx = [x zeros(1,winwidth-(nsamp-ii+1))];
	% 	else
	% 		thisx = x(ii:ii+winwidth);
	% 	end

	% 	y(ii) = max(thisx);

	% end

end