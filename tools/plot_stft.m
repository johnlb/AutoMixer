%% plot_stft: takes stft data and plots it in a purdy way
function [] = plot_stft(X,tstep,ts,fignum)
	if (nargin < 4)
		figure;
	else
		figure(fignum);
	end

	N = size(X,1);
	M = size(X,2);

	if (length(size(X)) == 3)
		% Eventually make this plot each track...
		X = reshape(X(:,:,1),N,M);
	end

	t = tstep*(0:M-1);
	f = (1/(2*ts))*(0:N-1);

	plot_helper(X,t,f);

end


%% plot_helper: do a single plot.
function [] = plot_helper(X,t,f)

	p = imagesc(t,f./1e3,abs(X));
	set(gca,'ydir','normal');
	% set(gca,'yscale','log');
	xlabel('time (s)');
	ylabel('frequency (kHz)');
	title('STFT');
	colorbar;

end