%% gain2fir: Find minimum-phase FIR filter that realizes the gain curve, X.
function [X_MIN] = gain2fir(X)
	X = abs(X);
	
	XIN = [AL_smoothed(:,1); flipud(AL_smoothed(1:end-2,1))];
	XIN = 10.^(XIN/20);
	X_MIN = minphase(XIN);
	X_MIN = X_MIN(1:length(X_MIN)/2+1);

end