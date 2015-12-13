

run('../always.m');
init_hotelcalifornia();


piece = 300000 : 1000000;
xL_p = xL(piece,:);
xR_p = xR(piece,:);
time = (300000 : 1000000)*ts;
gainL = repmat(abs(sin(time * 1.5)),size(xL_p,2),1)';
gainR = repmat(abs(cos(time * 2)),size(xL_p,2),1)';
tL_p = sum(gainL.*xL_p, 2);
tR_p = sum(gainR.*xR_p, 2);
thre = 10;
win_len = 100:100:3000;
rms_win = 1: 5: 100;
mse = zeros(length(win_len), length(rms_win));
%{
for j = 1:length(rms_win)
    xL_rms = ampl2rms(xL_p,rms_win(j));
    xR_rms = ampl2rms(xR_p,rms_win(j));
    for i = 1:length(win_len)
        [aL aR winSize] = find_coeffs(xL_p,xR_p, tL_p,tR_p, ts, win_len(i) ,1, rms_win(j),'pchip',thre);
        
        win_n = ceil(length(xL_p)/winSize);
        I_L = arrayfun(@(z) repmat(sum(xL_rms((z - 1) * winSize + 1: z * winSize,:),1) > thre, winSize, 1), ...
            1: length(xL_p)/winSize,'UniformOutput', false);
        I_L = cell2mat(I_L');
        I_R = arrayfun(@(z) repmat(sum(xR_rms((z - 1) * winSize + 1: z * winSize,:),1) > thre, winSize, 1), ...
            1: length(xL_p)/winSize,'UniformOutput', false);
        I_R = cell2mat(I_R');
        mse(i,j) = mean(sum(I_L .* ((aL - gainL).^2))) + mean(sum((I_R) .* ((aR - gainR).^2)));
    end
end
[i,j] = find(mse==min(mse(:)));
%}

%[aL aR] = find_coeffs(xL_p,xR_p, tL_p,tR_p, ts, win_len(i(1)) ,1,  rms_win(j(1)), 'pchip', thre);
thre = 10;
rms_win = 96;
[aL aR winSize] = find_coeffs(xL_p,xR_p, tL_p,tR_p, ts, 3000 ,2,  rms_win, 'pchip',thre);
plot_comp(time,xL_p, aL,gainL,1, rms_win, winSize, thre,1, 4:5);
plot_comp(time,xR_p, aR,gainR,2, rms_win, winSize, thre,1, 4:5);
%plot_comp(time,xL_p, aL, gainL,3, rms_win, winSize, thre,0);
%plot_comp(time,xR_p, aR, gainR,4, rms_win, winSize, thre,0);

%{
figure(3)
surf(rms_win(10:end), win_len, mse(:,10:end));
shading interp
xlabel('rms window size');
ylabel('window size');
zlabel('mse');
%}
%{
mseL = []
mseR = []
for i = 1:length(rms_win)
    [aL aR] = find_coeffs(xL_p,xR_p, tL_p,tR_p, ts, win_len(idx(1)) ,2, rms_win(i));
    mseL = [mseL, mean(sum((aL - gainL).^2))];
    mseR = [mseR, mean(sum((aR - gainR).^2))];
end
figure(6)
mse = mseL + mseR;
plot(rms_win, mse);
title('rms_win vs mse');
idx2 = find(mse == min(mse));
[aL aR] = find_coeffs(xL_p,xR_p, tL_p,tR_p, ts, win_len(idx(1)) ,2,  rms_win(idx2(1)));
%}
%{
figure(3)
plot(time,xL_p(:,1))
hold on 
plot(time,xL_p(:,2))
legend('1','2')
figure(4)
plot(time,xR_p(:,1))
hold on 
plot(time,xR_p(:,2))
legend('1','2')
%}



%{
figure
plot_gains(time,aR,2);
hold on 
plot_gains(time,gainR,1);



figure(3);
plot(time,tL_p, time,yL);
legend('t','y')

figure(4);
plot(time,tR_p, time,yR);
%}