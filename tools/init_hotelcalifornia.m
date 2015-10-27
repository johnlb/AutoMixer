% Don't load data every time you run the thing.
if (~exist('DATA_LOADED'))
	DATA_LOADED = 'hotel_california';

	[x t x_names fs] = readin_hotelcalifornia();
	ts = 1/fs;

elseif(~strcmp(DATA_LOADED, 'hotel_california'))
	error('Other data is loaded. Please do a "clear all" first.');
end