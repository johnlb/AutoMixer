%%% hello.
clear sandbox

run('../../always.m');
init_hotelcalifornia();

win = get_win_ind([50 51],ts);


N = length(x(win));
M = size(x,2);


FRAME_LENGTH = round(10e-3/ts);
frame = 0:FRAME_LENGTH-1;


alpha = [];
% for ii = 1:M
% 	alpha{ii} = [];
% end
NFRAMES = floor(N/FRAME_LENGTH);
% frame_starts = (1:FRAME_LENGTH:N-FRAME_LENGTH)+win(1)-1;
frame_starts = win(1) + (0:NFRAMES-1).*FRAME_LENGTH;
W = exp(-(frame-FRAME_LENGTH/2).^2/(2*200*FRAME_LENGTH));
W = diag(W);
for ii = 1:NFRAMES
	frame_index = floor( (ii-1)/FRAME_LENGTH )+1;
	thisFrame = frame_starts(ii)+frame;
		y_ = t(thisFrame,1);
		x_ = x(thisFrame,:);
		nodata = ~any(x_,1);
		x_(:,nodata) = [];
		% alpha_(nodata) = [];
		alpha_ = inv(x_'*W*x_)*x_'*W*y_;
		% alpha_ = inv(x_'*x_)*x_'*y_;
		% alpha_ = lsqnonneg(x_,y_);
		alpha__ = zeros(1,M);
		alpha__(~nodata) = alpha_';
		alpha = [alpha; alpha__];

end



figure(1);
% for ii = 1:10
% for ii = 1:size(alpha{1},1)
% 	fi = ii;
% 	loc = (fi-1)*FRAME_LENGTH+1;
% 	thisFrame = loc+frame;
	for jj = 1:M
		subplot(ceil(M/2),2,jj);
		scatter(1:NFRAMES,alpha(:,jj));
		% ylim([-10 +10]);
% 	hold all;
	end
% end
% hold off;


figure(2);
for jj = 1:M
	subplot(ceil(M/2),2,jj);
	plot(x(win(1):win(1)+450,jj));
end


figure(3);
plot(t(win(1):win(1)+450,1))