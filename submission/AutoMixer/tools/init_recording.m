%%% create a variable called "rec_name" with the name of the recording to be loaded
%%% before you run this.

% Don't reload data every time you run the thing.
clearvars -except x xL xR t tL tR pan x_names fs ts DATA_LOADED thispath rec_name
run([thispath 'always.m']);

% rec_name = 'hotel_california';
if (~exist('DATA_LOADED'))
	DATA_LOADED = rec_name;

	[x t pan x_names fs] = readin_recording(DATA_PATH,rec_name);
	ts = 1/fs;

	% Pre-pan
	xL = x(:,pan(:,1));
	xR = x(:,pan(:,2));

	tL = t(:,1);
	tR = t(:,2);

elseif(~strcmp(DATA_LOADED, rec_name))
	error('Other data is loaded. Please do a "clear all" first.');
end

