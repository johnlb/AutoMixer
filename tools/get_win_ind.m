%% get_win_ind: converts a window specified in seconds to a vector
%% 				of all indicies that fall into this window
function [win_ind] = get_win_ind(win_time,ts)

	win_ind = round(win_time/ts);
	win_ind = win_ind(1):win_ind(2);

end