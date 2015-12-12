%% find_good_tracks: function description
function [goodtracks] = find_goodtracks(x_win, Ethresh)
	[~, nwins, K] = size(x_win);
	goodtracks = sum( abs(x_win), 1) > Ethresh;
	goodtracks = reshape(goodtracks, nwins,K)';
end


