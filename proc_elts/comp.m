%% comp: dynamic range compression
function [y] = comp(x,tsamp,knobs)

	% Threshold, in dBFS (dB relative to FS)
	if (isfield(knobs,'thresh'))
		thresh = knobs.thresh;
	else 
		thresh = -6;
	end
	
	% Compression Ratio
	if (isfield(knobs,'ratio'))
		ratio = knobs.ratio;
	else 
		ratio = 3;
	end

	% Attack time (seconds)
	if (isfield(knobs,'att'))
		att = knobs.att;
	else 
		att = 10e-3;
	end
	att_ind = round(att/tsamp); 	% att in samples

	% Release time (seconds)
	if (isfield(knobs,'rel'))
		rel = knobs.rel;
	else 
		rel = 100e-3;
	end
	rel_ind = round(rel/tsamp); 	% rel in samples

	% Peak/RMS Envelope Detection algo.
	if (isfield(knobs,'env_type'))
		env_type = knobs.env_type;
	else 
		env_type = 'peak';
	end





	%%%%%%%
	% Envelope Detection
	switch env_type
		case 'peak'
			x_env = pk_det(x,tsamp,rel);

		case 'rms'
			x_env = rms_det(x,tsamp,rel);

		otherwise
			error('env_type should be either "peak" or "rms"');
	end



	%%%%%%%
	% Threshold Detection
	env_db 		= 20.*log10(x_env);
	over_dist 	= env_db - thresh;
	
	dptr 			= find(over_dist < 0);
	over_dist(dptr) = 0;




	%%%%%%%
	% Output
	gain_db = -over_dist;
	gain 	= 10.^(gain_db./20);

	y = x.*gain;

end





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% rms_det: implements rms detector
function [y] = rms_det(x,att,rel)


%%%%%% Not implemented yet %%%%%%%%%%

	y = pk_det(x,att,rel);

end