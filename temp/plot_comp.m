%plot & compare
function [] = plot_gains(time,x, a, a_o,fig, rms_win, winSize,thre, clean)

	K = size(a,2);
    x_rms = ampl2rms(x,rms_win);
    if clean == 1
        I = arrayfun(@(z) repmat(sum(x_rms((z - 1) * winSize + 1: z * winSize,:),1) > thre, winSize, 1), ...
            1: length(x)/winSize,'UniformOutput', false);
        I = cell2mat(I');
    end
	figure(fig);

	for ii = 1:K
		subplot(ceil(K/2),2,ii);
        plot(time, x(:,ii)/max(max(x))/2,'y');
        hold on
        if clean == 1
            plot(time(I(:,ii)), a(I(:,ii),ii),'.','MarkerFaceColor',[0.87451,0.93725,0.96078]);
        else
            plot(time, a(:,ii), 'b');
        end
        ylabel('gain')
        hold on 
        plot(time, a_o(:,ii),'r');
        
        legend('input', 'real','estimated')
		title(sprintf('Track %i',ii));
        ylim([-2 5]);
        xlim([min(time) + 0.5, max(time) - 0.5])
	end

end
