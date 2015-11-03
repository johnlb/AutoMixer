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


	% zero-pad s.t. rms @ time ii is using only previous samples
	x = x.^2;
	addx = x;
	subx = [zeros(nwin-1,1); x(1:end-nwin+1)];
	sumx = 0;
	for ii = 1:length(x)
		xrms(ii) = sumx + addx(ii) - subx(ii);
		sumx = xrms(ii);
	end

	xrms = sqrt(xrms'/nwin);