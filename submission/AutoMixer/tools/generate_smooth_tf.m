%% generate_smooth_tf: function description
function [X_smooth X_smooth_oct] = generate_smooth_tf(freqs,X)

	fstep = freqs(2) - freqs(1);

	% Break up into octaves
	octs = generate_octaves(freqs); 	% in Hz.
	oct_mid = [	freqs(1) 	...
				10.^((log10(octs(1:end-1))+log10(octs(2:end)))/2) ...
				freqs(end) ];

	mid_idx = round(oct_mid/fstep)+1;

	octwins = {};
	for ii = 2:length(mid_idx)
		octwins{ii-1} = mid_idx(ii-1):mid_idx(ii);
	end



	% Smooth each octave w/ proportional smoothing factors
	f = 0.08;
	for ii = 1:length(octs)
		X_smooth(octwins{ii}) = smooth(X(octwins{ii}), f*length(octwins{ii}));
	end

	% Thin out # points in each octave
	X_smooth_oct = X_smooth;
end



%% generate_octaves: generates center frequencies of all octaves worth considering.
function [octs] = generate_octaves(freqs)
	fstep = freqs(2) - freqs(1);
	fmax = freqs(end);

	octs = [125];
	while(octs(1) > 2*(freqs(1) + fstep))
		octs = [octs(1)/2 	octs];
	end
	while(octs(end) < fmax/2)
		octs = [octs 	2*octs(end)];
	end
end