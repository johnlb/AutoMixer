%%% hello.

run('../../always.m');
init_hotelcalifornia();


w = inv(x'*x)*x'*t;

y = x*w;


ky = 22.5;
kt = 1/2.74;


straight_pan = [ones(1,9); ones(1,9)]';
straight_pan(2,2) = 0;	% Stereo Track
straight_pan(3,1) = 0;
straight_pan(4,2) = 0;	% Stereo Track
straight_pan(5,1) = 0;
straight_pan(8,2) = 0;	% Stereo Track
straight_pan(9,1) = 0;


y_ = x(:,1:7)*straight_pan(1:7,:);





%%%%%
% Plot stuff

win = round([54 60]/ts);
% win = round([2*60 2*60+10]/ts);
win = win(1):win(2);

figure(1);

subplot(211);
plot(win*ts, x(win,7));
% plot(win*ts, y(win)*ky);
ylim([-1 1]);

subplot(212);
plot(win*ts, t(win,1));
% plot(win*ts, t(win)*kt);
ylim([-1 1]);