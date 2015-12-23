% Don't reload data every time you run the thing.
clearvars -except x t x_names fs ts DATA_LOADED thispath
%clear -x x t x_names fs ts DATA_LOADED thispath

run([thispath 'always.m']);

rec_name = 'hotel_california';
if (~exist('DATA_LOADED'))
	DATA_LOADED = rec_name;

  
	[x t x_names fs] = readin_recording2(DATA_PATH,rec_name);
	ts = 1/fs;

	dn = 589;
	x(:,5) = [zeros(dn,1); x(1:end-dn,5)];

elseif(~strcmp(DATA_LOADED, rec_name))
	error('Other data is loaded. Please do a "clear all" first.');
end