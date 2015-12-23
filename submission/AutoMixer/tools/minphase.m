%% minphase: function description
function [X_min] = minphase(X)
	n = length(X);
	h_cep = real(ifft(log(X)));
	odd = fix(rem(n,2));
	wn = [1; 2*ones((n+odd)/2-1,1) ; ones(1-rem(n,2),1); zeros((n+odd)/2-1,1)];
	h_min = zeros(n,1);
	h_min(:) = real(ifft(exp(fft(wn.*h_cep(:)))));

	X_min = fft(h_min);
end