%% gain2fir: Find minimum-phase FIR filter that realizes the gain curve, X.
%% 				Assumes X is lower half of an fft.
function [X_MIN] = gain2fir(X,is_db)

	if (is_db)
		X = 10.^(X/20);
	end
	X = [X(:,1); flipud(X(1:end-2,1))];
	X_MIN = minphase(X);
	% X_MIN = X_MIN(1:length(X_MIN)/2+1);

end