%% find_firstord: function description
function [y ymax tau] = find_firstord(x,t,eta)

	y0 		= t(1);
	tau 	= x(end)-x(1);
	ymax 	= ( t(end)-y0*exp(-x(end)/tau) )/( 1-exp(-x(end)/tau) );

	isdone = 0;
			% y = (y0 - ymax)*exp(-x/tau) + ymax;

	% thresholds = sqrt(eps)*ones(2,1);
	thresholds = 0.1*ones(2,1);
	while (~isdone)

		y = (y0 - ymax)*exp(-x/tau) + ymax;

		dEdmax = sum( 2*(y-t).*(1-exp(-x/tau)), 1);
		dEdtau = sum( 2*(y-t).*((y0-ymax)*exp(-x/tau).*(x/tau^2)), 1);



		ymax = ymax - eta*dEdmax;
		% tau  = tau  - 0;
		tau  = tau  - eta*dEdtau;

		E = sum((t-y).^2,1)

		dE = [dEdtau; dEdmax];
		if (all(dE < thresholds))
			isdone = 1;
		end
	end

end