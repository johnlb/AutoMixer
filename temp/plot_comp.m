%plot & compare
function [] = plot_gains(time,a, a_o,fig)

	K = size(a,2);

	figure(fig);
	for ii = 1:K
		subplot(ceil(K/2),2,ii);
		plot(time, a(:,ii));
        ylabel('gain')
        hold on 
        plot(time, a_o(:,ii));
        legend('estimated', 'real')
		title(sprintf('Track %i',ii));
		ylim([-2 10]);
	end

end
