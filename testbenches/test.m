clear test


% Do timealigned mixing
yL = sum(aL.*xL, 2);
yR = sum(aR.*xR, 2);



% Redo timealignment
K = size(xL,2);
xL_align = zeros(size(xL));
xR_align = zeros(size(xR));
aL_align = zeros(size(aL));
aR_align = zeros(size(aR));
for ii = 1:K
	mapL = 1:size(nL,1);
	mapR = 1:size(nR,1);
	ovflL = [find(nL(:,ii)<1); find(nL(:,ii)>mapL(end))];
	ovflR = [find(nR(:,ii)<1); find(nR(:,ii)>mapR(end))];

	mapL(ovflL) = [];
	mapR(ovflR) = [];
	nL_align = nL(:,ii);
	nR_align = nR(:,ii);
	nL_align(ovflL) = [];
	nR_align(ovflR) = [];
	xL_align(mapL) = xL(nL_align);
	xR_align(mapR) = xR(nR_align);
	aL_align(mapL) = aL(nL_align);
	aR_align(mapR) = aR(nR_align);
end


% Do timealigned mixing
yL_align = sum(aL_align.*xL_align, 2);
yR_align = sum(aR_align.*xR_align, 2);




% plot stuff
time = (0:length(x)-1)*ts;

plot_gains(time,aL,1);
plot_gains(time,aR,2);


figure(3);
plot(time,tL, time,yL);

figure(4);
plot(time,tR, time,yR);
