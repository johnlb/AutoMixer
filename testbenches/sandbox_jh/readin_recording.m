%% readin_hotelcalifornia: reads all data for hotel california and preps it.
function [x, y, x_names, fs] = readin_recording(DATA_PATH,rec_name)


% if (~exist('LOADED_DATA'))
% 	LOADED_DATA = 'hotel_california';
% elseif (strcmp(LOADED_DATA, 'hotel_california'))
% 	break;
% else
% 	error('Some other data is loaded. Please do clear all first.');
% end

%fileext 	= '.mp3';
masterfile = dir([DATA_PATH '/' rec_name '/' 'MASTER.*']);
[~,~,fileext] = fileparts(masterfile.name);

% filenames 	= {'MASTER', 'Bass', 'Guitar', 'Hat', 'Kick', 'Snare', 'Vox_Guitar'};
% filenames 	= {'MASTER', 'Kick', 'Snare', 'Hat', 'Bass', 'Guitar', 'Vox_Guitar'};

rec_files = dir([DATA_PATH '/' rec_name '/' '*' fileext]);
master = cellfun(@(x) strcmp(x(1:6),'MASTER'),{rec_files.name});
fullnames = {rec_files(master==1).name, rec_files(master==0).name};
[filenames,exts] = sep_ext(fullnames);

jj			= 1;
for ii = 1:length(filenames)

	[x{jj} fs] = audioread([DATA_PATH '/' rec_name '/' filenames{ii} fileext]);

	% Split up stereo tracks
	if (size(x{jj},2)==2)
		x{jj+1} 	= x{jj}(:,2);
		x{jj}(:,2) 	= [];

		x_names{jj} 	= [filenames{ii} '-L'];
		x_names{jj+1}	= [filenames{ii} '-R'];

		jj 			= jj + 1;
	else
		x_names{jj} = filenames{ii};
	end

	jj = jj + 1;
end

ts = 1/fs;


% Time align master track to other tracks.
x = time_align_hc(x,ts, [51.609 52.510], [54.178 55.230], 4);


% Zero pad end of master track s.t. all lengths line up.
N 	= length(x{3});
N_ 	= length(x{1});
x{1} = [x{1}; zeros(N-N_,1)];
x{2} = [x{2}; zeros(N-N_,1)];




dn = 130;
x{3} = [x{3}(dn+1:end); zeros(dn,1)];




% y=master, x=stems
y = [x{1:2}];
x = [x{3:end}];

x_names = {x_names{3:end}};




%% Plot time aligned data.

% n = round([54.178 55.230]./ts);
% n = n(1):n(2);

% figure(1);
% plot(n,x{1}(n), n,x{9}(n));
