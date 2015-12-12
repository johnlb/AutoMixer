% Don't reload data every time you run the thing.
clearvars -except x xL xR t tL tR pan x_names fs ts DATA_LOADED thispath
run([thispath 'always.m']);

fprintf('Loading Hotel California data...\n');
if (~exist('DATA_LOADED'))
	DATA_LOADED = 'hotel_california';

	[x t pan x_names fs] = readin_hotelcalifornia(DATA_PATH);
	ts = 1/fs;

	dn = 589;
	x(:,5) = [zeros(dn,1); x(1:end-dn,5)];




	% Pre-pan
	xL = x(:,pan(:,1));
	xR = x(:,pan(:,2));

	tL = t(:,1);
	tR = t(:,2);




elseif(~strcmp(DATA_LOADED, 'hotel_california'))
	error('Other data is loaded. Please do a "clear all" first.');
end