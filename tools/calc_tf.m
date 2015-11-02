%% calc_tf: calculates z-domain transfer function in the presence of noise
%%
%% 			ideally, TF = Y/X
function [TF] = calc_tf(X,Y,epsilon)

	TF = Y.*conj(X)./(abs(X).^2 + epsilon.^2);

end