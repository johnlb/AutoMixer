%plot & compare
function [] = plot_gains(time,x, a, a_o,fig)

	K = size(a,2);

	figure(fig);
	for ii = 1:K
		subplot(ceil(K/2),2,ii);
        plot(time, x(:,ii)/max(max(x))/2,'y');
        hold on
		plot(time, a(:,ii));
        ylabel('gain')
        hold on 
        plot(time, a_o(:,ii));
        
        legend('input', 'real','estimated')
		title(sprintf('Track %i',ii));
        ylim([-2 5]);
	end

end
