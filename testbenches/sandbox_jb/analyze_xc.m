%%% hello.
clear sandbox

run('../../always.m');
init_hotelcalifornia();

% win = get_win_ind([3 3]*60 + [40 40] + [0 10],ts);
% win = get_win_ind([2 2]*60 + [00 00] + [0 10],ts);
% win = get_win_ind([0 0]*60 + [50 50] + [0 10],ts);
win = get_win_ind([54 58],ts);
win = get_win_ind([64 68],ts);
% win = get_win_ind([10 11],ts);


N = length(x(win));
M = size(x,2);

figure(1);
dn = [];
for ii = 1:M
	subplot(ceil(M/2),2,ii);
	xc = xcorr(x(win,ii),t(win,1));
	plot(xc);
	temp = find(abs(xc)==max(abs(xc)))-length(win);
	dn(ii) = temp(1);
	if (xc(dn(ii)+length(win))>=0)
		txt = '+';
	else
		txt = '-';
	end
	title(sprintf('dn=%d %s',dn(ii),txt));
end

ddn = dist(dn);
ddn(7,:) = []; ddn(:,7) = []
max(max(ddn))



figure(2);
ax1 = subplot(211);
plot(x(win,2));
ax2 = subplot(212);
plot(t(win,1));

linkaxes([ax1,ax2],'xy');
