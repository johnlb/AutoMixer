%% play_audio: function description
function [] = play_audio(x,fs, tstart, tstop)

	if (nargin < 4)
		tstop = size(x,1)/fs;
	end
	
	if (nargin < 3)
		tstart = 0;
	end

	n = round(tstart*fs)+1:round(tstop*fs);

	sound(x(n,:),fs);