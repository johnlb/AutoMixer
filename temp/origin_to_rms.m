

run('../always.m');
init_hotelcalifornia();

%align
chunk = chunk_class(3.214-0.1, 6.513, ts, 1);
win = chunk.get_win_ind();
L = length(win);

[x_new t_new] = chunk.get_aligned_data(x(:,4:7),t);

nwin = round(0.2e-3/ts);

%get rms
x_rms = [];
t_rms = [];

for i = 1:size(x_new,2)
    x_rms = horzcat(x_rms, ampl2rms(x_new(:,i), nwin));
end

for i = 1:size(t_new,2)
    t_rms = horzcat(t_rms, ampl2rms(t_new(:,i), nwin));
end

%constant error
x_rms_error = horzcat(x_rms, ones(L,1));
%mgn white noise
p = 0;
x_rms_white = horzcat(x_rms, wgn(L,1,p));
%boostrap
e_idx = find(sum(x_rms,2) == 0);

b_error = t_rms(e_idx,:);
b_error = b_error(b_error ~= 0);



b_idx = ceil(rand(1, length(x_rms)) * length(b_error));
x_rms_boot = horzcat(x_rms, b_error(b_idx));
t_rms_boot = t_rms - repmat(b_error(b_idx), 1,2);


%###########################################################
M = 3000;
[A1, B1] = cal_plot(x_rms, t_rms, M, 0, 'without noise term');
[A2, B2] = cal_plot(x_rms_error, t_rms, M,0, 'with constant noise term');
[A3, B3] = cal_plot(x_rms_white, t_rms, M,0, 'with white noise term');
[A4, B4] = cal_plot(x_rms_boot, t_rms,M,0, 'with bootstrap noise term');
[A5, B5] =cal_plot(x_rms, t_rms_boot,M,1, 'substract noise term from output');
figure
plot(A1(2,:), 'r-');
hold on 
plot(A2(2,:)),'g-';
hold on 
plot(A3(2,:),'y-');
hold on 
plot(A4(2,:),'k-');
hold on 
plot(A5(2,:),'b-');
legend('no noise','constant', 'white', 'boot','boot_sub', 'Location','northwest');
