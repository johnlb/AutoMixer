%% batch_stft: takes multi-channel data and runs STFT on each
%%				channel. x should be NxM where:
%% 				--N is # samples
%% 				--M is # tracks
function [X] = batch_stft(x,fftlen,overlap)
	
	N = size(x,1);
	Ns = floor( (N-fftlen)/(fftlen-overlap) );
	M = size(x,2);
	K = fftlen/2 + 1;

	X = zeros(K,Ns,M);
	for ii = 1:M
		X(:,:,ii) = STFT(x(:,ii),fftlen,overlap);
	end

end