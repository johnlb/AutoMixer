%% model_rel: function description
function [a_new] = model_rel(a,x,tau,thresh,amax)

	ptrs = find(x > thresh);

	temp = diff(ptrs);
	sect = find(temp>1);
	sect_start 	= ptrs(sect);
	sect_end 	= ptrs(sect+1);


	a_new = a;
	for ii = 1:length(sect_start)

		thissect = sect_start(ii):sect_end(ii);
		L = length(thissect);

		a0 = a(sect_start(ii));
		af = a(sect_end(ii));


		a_new(thissect) = (a0 - amax)*exp(-(0:L-1)/tau) + amax;

	end


end