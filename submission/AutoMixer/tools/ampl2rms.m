%% ampl2rms: convert amplitude (time domain) data to an RMS signal with window size = nwin (in samples)
%% 				note: xrms is the same length as x (i.e. RMS is calc'd at every point in time)
function [xrms] = ampl2rms(x,nwin)

	% % zero-pad s.t. rms @ time ii is using only previous samples
	% x = [zeros(nwin-1,1); x];

	% x_ = [];
	% for ii = 1:nwin
	% 	x_ = [x_; x(ii:end-nwin+ii)'];
	% end
	% x_ = x_.^2;
	% xrms = sqrt(sum(x_,1));

	N = size(x,1);
	K = size(x,2);


	% zero-pad s.t. rms @ time ii is using only previous samples
	x 	 = x.^2;
	xrms = zeros(N,K);

	addx = x;
	subx = [zeros(nwin-1,K); x(1:end-nwin+1,:)];
	sumx = zeros(1,K);
	for ii = 1:N
		xrms(ii,:) = sumx + addx(ii,:) - subx(ii,:);
		sumx = xrms(ii,:);
	end


	% Fix small rounding errors that might make summation slightly negative when it should be 0.
	ptrs = find(xrms<0);
	if (any(-xrms(ptrs) > 1e-9))
		warning('xrms returning negative values. There may be accumulating precision errors occuring.');
	end
	xrms(ptrs) = 0;

	
	xrms = sqrt(xrms/nwin);

end