run('../always.m');
init_hotelcalifornia();

%align
chunk = chunk_class( 0.1, 116.513, ts, 1);
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

M = 3000;
[A1, B1] = cal_plot(x_rms, t_rms, M, 1, 'without noise term');
