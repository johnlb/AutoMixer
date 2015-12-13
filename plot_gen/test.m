


time = (1:length(alpha2))*ts;



figure(1);
plot(time,0.5*x1/max(x1),				'color',hex2rgb('#89BEFF'));
hold all;
plot(time(1:end-1),alpha2(1:end-1,1),	'color',hex2rgb('#FF0000'), 'LineWidth', 2);
hold off;
% ylim([-0 3]);
title('Track 1');
xlabel('Time (s)');


figure(2);
plot(time,0.5*x3/max(x3),					'color',hex2rgb('#89BEFF'));
hold all;
plot(time(1:end-1e4),alpha2(1:end-1e4,2),	'color',hex2rgb('#FF0000'), 'LineWidth', 2);
hold off;
% ylim([-0 2]);
title('Track 2');
xlabel('Time (s)');


zwin = round(1.06)/ts:round(1.12/ts);
figure(3);
plot(time(zwin),0.5*x1(zwin)/max(x1),		'color',hex2rgb('#2386FF'), 'LineWidth', 2);
hold all;
plot(time(zwin),alpha2(zwin,1),				'color',hex2rgb('#FF0030'), 'LineWidth', 2);
hold off;
xlim([1.06 1.12]);
% ylim([-0 3]);
title(sprintf('Track 1 - 40ms window (%i samples)',length(zwin)));
xlabel('Time (s)');



figure(4);
subplot(211);
plot(time,0.5*t1/max(t1),				'color',hex2rgb('#FC9041'));
% plot(time,0.5*t1/max(t1),				'color',hex2rgb('#47FF6A'));
title('Mixed (L Channel)');
ylim([-1 1]);
% xlabel('Time (s)');
subplot(212);
plot(time,0.5*t2/max(t2),				'color',hex2rgb('#FC9041'));
% plot(time,0.5*t2/max(t2),				'color',hex2rgb('#47FF6A'));
title('Mixed (R Channel)');
xlabel('Time (s)');
ylim([-1 1]);