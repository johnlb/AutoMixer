%%% hello.
clear run_find_coeffs


run('../always.m');
init_hotelcalifornia();



[aL aR] = find_coeffs(xL,xR, tL,tR, ts, 3000);


yL = sum(aL.*xL, 2);
yR = sum(aR.*xR, 2);




% plot stuff
time = (0:length(x)-1)*ts;

plot_gains(time,aL,1);
plot_gains(time,aR,2);


figure(3);
plot(time,tL, time,yL);

figure(4);
plot(time,tR, time,yR);
