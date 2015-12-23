%% readin_hotelcalifornia: reads all data for hotel california and preps it.
function [x, y, pan, x_names, fs] = readin_recording(DATA_PATH,rec_name)


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

			pan{jj}			= [1 0];
			pan{jj+1}		= [0 1];

			jj 			= jj + 1;
		else
			x_names{jj} = filenames{ii};
			pan{jj}		= [1 1];
		end

		jj = jj + 1;
	end

	ts = 1/fs;


	% Time align master track to other tracks.
	% x = time_align_hc(x,ts, [51.609 52.510], [54.178 55.230], 4);


	% Zero pad end of tracks s.t. all lengths line up.
	N_TRAX 		= length(x{3});
	N_MASTER 	= length(x{1});
	dN = (N_TRAX - N_MASTER);
	dN*ts
	if (dN > 0)
		% if trax are longer, pad master
		x{1} = [zeros(dN,1); x{1}];
		x{2} = [zeros(dN,1); x{2}];
	else
		% if master is longer, pad trax
		for ii = 3:length(x)
			x{ii} = [zeros(-dN,1); x{ii}];
		end
	end



	dn = 130;
	x{3} = [x{3}(dn+1:end); zeros(dn,1)];




	% y=master, x=stems
	y = [x{1:2}];
	x = [x{3:end}];

	x_names = {x_names{3:end}};


	pan 	= cell2mat(pan(3:end)');
	pan 	= pan > 0;


end


function [filename,fileext] = sep_ext (fullname)
	filename = fullname;
	fileext = fullname;
	for n = 1:length(fullname)
	  [~,filename{n},fileext{n}] = fileparts(fullname{n});
	end;
end