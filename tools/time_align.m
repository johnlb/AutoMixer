%% time_align: zero-pads the master tracks s.t. they line up in time with orig. tracks.
function [y] = time_align(x,ts, window1,window2, track_index2)


%%%%%%
% Time Align master track.

% let's look at the opening drum hit.
ma_win = round(window1./ts);
ma_win = ma_win(1):ma_win(2);

sn_win = round(window2./ts);
sn_win = sn_win(1):sn_win(2);



n = min([ma_win sn_win]):max([ma_win sn_win]);
ma = zeros(size(n));
ma(ma_win-n(1)+1) = x{1}(ma_win);

sn = zeros(size(n));
sn(sn_win-n(1)+1) = x{track_index2}(sn_win);



ma_sn_corr = xcorr(ma,sn);


[vals pks] = findpeaks(ma_sn_corr);
samp_dly = abs(pks(find(vals == max(vals))) - length(ma) + 1);


y = x;
y{1} = [zeros(samp_dly,1); y{1}];
y{2} = [zeros(samp_dly,1); y{2}];