%%% hello.

run('../../always.m');
init_hotelcalifornia();







dn = 530;
x(:,2) = [x(dn+1:end,2); zeros(dn,1)];
dn = 320;
x(:,5) = [x(dn+1:end,5); zeros(dn,1)];











w = inv(x'*x)*x'*t;

y = x*w;


ky = 16.84;
kt = 1;


straight_pan = [ones(1,9); ones(1,9)]';
straight_pan(6,1) = -1; % kick
straight_pan(6,2) = -1;
straight_pan(2,2) = 0;	% Stereo Track
straight_pan(3,1) = 0;
straight_pan(4,2) = 0;	% Stereo Track
straight_pan(5,1) = 0;
straight_pan(8,2) = 0;	% Stereo Track
straight_pan(9,1) = 0;

straight_pan = [1 2.3 0 1 -1.6 -2 0 2.5 0;
				1 2.3 1 0 -1.6 0 -2 0 2.5]';

excl = 6;
ptr = 1:9;
ptr(excl) = [];


y_ = x(:,ptr)*straight_pan(ptr,:);





%%%%%
% Plot stuff

win = round([13 23]/ts);
% win = round([54 60]/ts);
% win = round([2*60 2*60+10]/ts);
win = win(1):win(2);



rms(t)/rms(y)

rms(t)/rms(y_)




figure(1);

subplot(311);
% plot(win*ts, x(win,7));
plot(win*ts, y_(win,1)*kt);
% plot(win*ts, x(win,ptr)*w(ptr,1)*ky-t(win,1));
ylim([-1 1]);

subplot(312);
plot(win*ts, y_(win,1)*kt-t(win,1));
% plot(win*ts, t(win)*kt);
ylim([-1 1]);

subplot(313);
plot(win*ts, x(win,excl));
% plot(win*ts, t(win)*kt);
ylim([-1 1]);




figure(2)
plot(win*ts, y_(win,1)*kt)
% plot(win*ts, x(win,ptr)*w(ptr,1)*ky)
ylim([-1 1]);





figure(3)
index = 7;
k = 1;
% plot(win*ts, t(win,1), win*ts, x(win,index)*k)
% plot(win*ts, t(win,1)-x(win,5)*(straight_pan(5,1)), win*ts, x(win,index)*k)
plot(win*ts, t(win,1)-x(win,5)*(straight_pan(5,1))-x(win,6)*k, win*ts, x(win,index)*k)
% plot(win*ts, t(win,1)-x(win,index)*k, win*ts, x(win,index)*k)
ylim([-1 1]);


% look into 3,4 (hat)
w_ = [1 2.3 0 1 -1.6 -1 0 2.5 0];