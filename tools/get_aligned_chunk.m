%% get_aligned_chunk: align all tracks in x to tracks in y and extract the chunk described in "chunk"
function [xout yout] = get_aligned_chunk(x,y,chunk)


	win = chunk.start:chunk.end;
	L 	= length(win);
	N 	= size(x,2);				% # of tracks


	xout = [];
	for ii = 1:N

		xc1 = xcorr(x(win,5), t(win,1));
		temp = find(abs(xc1)==max(abs(xc1)))-L;
		dn1 = temp(1) + 1;

		polarity1 = xc1(dn1+L)/abs(xc1(dn1+L));




		xc2 = xcorr(x(win,5), t(win,2));
		temp = find(abs(xc2)==max(abs(xc2)))-L;
		dn2 = temp(1) + 1;

		polarity2 = xc2(dn2+L)/abs(xc2(dn2+L));

dn1=0; dn2=0;

		if (abs(xc1(dn1+L)) > abs(xc2(dn2+L)))
			xout = [xout x(win+dn1,ii)*polarity1];
		else
			xout = [xout x(win+dn2,ii)*polarity2];
		end

	end


end