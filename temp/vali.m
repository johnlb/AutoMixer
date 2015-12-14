

% run('../always.m');
% init_hotelcalifornia();


piece = 300000 : 800000;
xL_p = xL(piece,4:5);
xR_p = xR(piece,4:5);
time = (300000 : 800000)*ts;
%gainL = repmat(ones(size(time)),2,1)';
%gainR = repmat(ones(size(time)),2,1)';
gainL = repmat(abs(sin(time * 1.5)),size(xL_p,2),1)';
gainR = repmat(abs(cos(time * 2)),size(xR_p,2),1)';
%gainL = vertcat(abs(1.25 * cos(time * 0.9) - sin(time * 2.5).^3) + (cos(time * 2.5).* sin(time * 0.85)).^2,abs(sin(time * 2) + cos(time).^2) + exp(sin(time * 1.5))/2.7)';
%gainR = vertcat(abs(log(sin(time * 0.8)).^ cos(time * 2) + cos(time * 1.5) + cos(time + 1.12) .^(0.5)),abs(sin(time * 1.75).^0.5 + log(cos(time * 0.8).^1.5)))';

tL_p = sum(gainL.*xL_p, 2);
tR_p = sum(gainR.*xR_p, 2);

thre = 10;
win_len = 100:500:5000;
rms_win = 1: 5: 100;
mse = zeros(length(win_len), length(rms_win));

% for j = 1:length(rms_win)
% %     xL_rms = ampl2rms(xL_p,rms_win(j));
% %     xR_rms = ampl2rms(xR_p,rms_win(j));
%     for i = 1:length(win_len)
%         [aL aR winSize] = find_coeffs(xL_p,xR_p, tL_p,tR_p, ts, win_len(i) ,2, rms_win(j),'pchip',thre);
% %         win_n = length(xL_p)/winSize;
% %         I_L = arrayfun(@(z) repmat(sum(xL_rms((z - 1) * winSize + 1: z * winSize,:),1) > thre, winSize, 1), ...
% %             1: length(xL_p)/winSize,'UniformOutput', false);
% %         I_L = cell2mat(I_L');
% %         I_R = arrayfun(@(z) repmat(sum(xR_rms((z - 1) * winSize + 1: z * winSize,:),1) > thre, winSize, 1), ...
% %             1: length(xL_p)/winSize,'UniformOutput', false);
% %         I_R = cell2mat(I_R');
%         mse(i,j) = mean(sum(abs(xL_p > 0) .* ((aL - gainL).^2))) + mean(sum(abs(xR_p > 0) .* ((aR - gainR).^2)));
%     end
% end
% [i,j] = find(mse==min(mse(:)));


%aL aR] = find_coeffs(xL_p,xR_p, tL_p,tR_p, ts, win_len(i(1)) ,1,  rms_win(j(1)), 'pchip', thre);
% thre = 30;
% rms_win = 60;
% 
% a = 0:0.025:0.5;
% xL_rms = ampl2rms(xL_p,rms_win);
% xR_rms = ampl2rms(xR_p,rms_win);
% rms = zeros(size(a));
% for i = 1 : length(a)
%     thre = a(i) * rms_win;
%     [aL aR winSize] = find_coeffs(xL_p,xR_p, tL_p,tR_p, ts, 3000 ,2, rms_win,'pchip',thre);
%     win_n = length(xL_p)/winSize;
%     I_L = arrayfun(@(z) repmat(sum(xL_rms((z - 1) * winSize + 1: z * winSize,:),1) > thre, winSize, 1), ...
%             1: length(xL_p)/winSize,'UniformOutput', false);
%     I_L = cell2mat(I_L');
%     I_R = arrayfun(@(z) repmat(sum(xR_rms((z - 1) * winSize + 1: z * winSize,:),1) > thre, winSize, 1), ...
%             1: length(xL_p)/winSize,'UniformOutput', false);
%     I_R = cell2mat(I_R');
%     rms(i) = mean(sum(abs(xL_p > 0) .* ((aL - gainL).^2))) + mean(sum(abs(xR_p > 0) .* ((aR - gainR).^2)));
% end  
%     
% thre = a(find(rms == min(rms))) * rms_win
rms_win = 60;
thre = 10;

[aL aR winSize] = find_coeffs(xL_p,xR_p, tL_p, tR_p, ts, 3000, 2,  rms_win, 'pchip',thre);
%[aL aR winSize] = find_coeffs(xL_p,xR_p, yL_p,yR_p, ts, 3000 ,2,  rms_win, 'pchip',thre);
% figure(1)
% %subplot(1,2,1)
% plot(time, yL_p)
% hold on
% plot(time, sum(aL .* xL_p,2))
% ylim([-1,1])
% legend('estimated output', 'real output')
%title('estimated')
%subplot(1,2,2)

%ylim([-1,1])


plot_comp(time,xL_p, aL, gainL,3, rms_win, winSize, thre,1);
plot_comp(time,xR_p, aR, gainR,4, rms_win, winSize, thre,1);

