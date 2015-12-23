classdef chunk_class
	properties
		n_start
		n_end
		ts
	end

	methods
		% constructor
		function obj = chunk_class(start_time, end_time, ts, isTime)
			if (isTime)
				obj.n_start = round(start_time/ts);
				obj.n_end 	= round(end_time/ts);
				obj.ts 		= ts;
			else
				obj.n_start = start_time;
				obj.n_end	= end_time;
				ts 			= ts;
			end
		end

		%% get_win_ind: returns vector of all indicies that make up this chunk
		function [win_ind] = get_win_ind(obj)

			win_ind = obj.n_start:obj.n_end;

		end

		%% get_aligned_chunk: align all tracks in x to tracks in y and extract this chunk
		function [xout yout] = get_aligned_data(obj,x,y)


			win = get_win_ind(obj);
			L 	= length(win);
			N 	= size(x,2);				% # of input tracks
			M 	= size(y,2);				% # of output tracks


			xout = zeros(L,N);
			for ii = 1:N

				xc1 = xcorr(x(win,ii), y(win,1));
				temp = find(abs(xc1)==max(abs(xc1)))-L;
				dn1 = temp(1) + 1;

				polarity1 = xc1(dn1+L)/abs(xc1(dn1+L));




				xc2 = xcorr(x(win,ii), y(win,2));
				temp = find(abs(xc2)==max(abs(xc2)))-L;
				dn2 = temp(1) + 1;

				polarity2 = xc2(dn2+L)/abs(xc2(dn2+L));


% dn1=0; dn2=0;
				if (abs(xc1(dn1+L)) > abs(xc2(dn2+L)))
					xout(:,ii) = x(win+dn1,ii)*polarity1;
				else
					xout(:,ii) = x(win+dn2,ii)*polarity2;
				end


			end

			yout = y(win,:);

		end
	end
end