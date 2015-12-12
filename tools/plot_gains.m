%% plot_gains: plots all the gains
function [] = plot_gains(time,a,fig)

	K = size(a,2);

	figure(fig);
	for ii = 1:K
		subplot(ceil(K/2),2,ii);
		plot(time, a(:,ii));
		title(sprintf('Track %i',ii));
		ylim([-2 10]);
	end

end
