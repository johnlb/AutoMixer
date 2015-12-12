%%% hello.
clear run_find_coeffs


run('../../always.m');
init_hotelcalifornia();



[aL aR] = find_coeffs(xL,xR, tL,tR, ts, 3000);


yL = sum(aL.*xL, 2);
yR = sum(aR.*xR, 2);


time = (0:length(x))*ts/length(x);

figure(1);
plot(time,tL, time,yL);

figure(2);
plot(time,tR, time,yR);