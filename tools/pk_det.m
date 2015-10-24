%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% pk_det: implements peak detector

%%
%% TO DO: add attack time knob
%%
function [y] = pk_det(x,tsamp,tau)
	
	LOOKAHEAD = 100; 	% # peaks in the future to consider when choosing seg_len


	nsamp 		= length(x);

	x = abs(x);


	[vals pks] = findpeaks(x);
	
	pks 			= [1 pks nsamp];
	vals 			= [0 vals 0];

	% Create decay shape LUT
	max_seglen 		= nsamp;
	decay_kernel 	= exp(-(tsamp/tau).*(0:max_seglen-1));

	% init loop
	y 				= zeros(size(x));
	prev_decayptr 	= 1;
	this_k		 	= vals(1);
	ii 				= 1;
	while (ii <= length(pks)-1)
		
		% Setup for lookahead
		la 		= min([LOOKAHEAD; length(pks)-ii]);
		la_ptrs = ii+(1:la);


		% Start with long segment, cut down later w/ lookahead\
		% 	Note: only calculate @ pks for look ahead.
		% seg_len = pks(la_ptrs(end)) - pks(ii);
		% n 		= 1:seg_len;
		seg_len = length(la_ptrs);
		n 		= pks(la_ptrs) - pks(ii);

		l 			= prev_decayptr + [n];
		thisDecay 	= this_k.*decay_kernel(l);


		% Do lookahead
		next_xover = min([find(vals(la_ptrs) > thisDecay) length(la_ptrs)]);



		% Re-kajigger the seg_len based on the lookahead result.
		la 		= la_ptrs(next_xover);
		seg_len = pks(la)-pks(ii);
		% seg_len = min([pks(la)-pks(ii)+1; length(x)-pks(ii)]);
		n 		= 1:seg_len;
		xptrs	= pks(ii)+n;

		l 			= prev_decayptr + n;
		thisDecay 	= this_k.*decay_kernel(l);


		trackptrs 	= find(thisDecay < x(xptrs));
		cont_decay 	= (max(trackptrs) ~= seg_len);
		if (isempty(cont_decay))
			cont_decay = 1;
		end

		decayptrs 	= setdiff(n, trackptrs);
		trackptrs 	= pks(ii) + trackptrs;


		y(pks(ii) + decayptrs) 	= thisDecay(decayptrs);
		y(trackptrs) 				= x(trackptrs);


		% Housekeeping
		if (cont_decay)
			prev_decayptr 	= prev_decayptr + seg_len;
			% this_k 			= this_k;
		else
			prev_decayptr 	= 1;
			this_k 			= vals(la);
		end
		ii = ii + next_xover;
	end

end