
yL = sum(aL.*xL, 2);
yR = sum(aR.*xR, 2);



% Redo timealignment
yL_align = zeros(size(yL));
yR_align = zeros(size(yR));

map = 1:size(yL,1);
ovfl = [find(yL<1) find(yL>map(end))];

map(ovfl) = [];
nL(ovfl) = [];
yL_align(map) = yL(nL);

map = 1:size(yR,1);
ovfl = [find(yR<1) find(yR>map(end))];

map(ovfl) = [];
nR(ovfl) = [];
yR_align(map) = yR(nR);




% plot stuff
time = (0:length(x)-1)*ts;

plot_gains(time,aL,1);
plot_gains(time,aR,2);


figure(3);
plot(time,tL, time,yL);

figure(4);
plot(time,tR, time,yR);
