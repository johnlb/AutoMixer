
%{
run('../always.m');
init_hotelcalifornia();

%align
chunk = chunk_class(3.214-0.1, 6.513, ts, 1);
win = chunk.get_win_ind();
L = length(win);

[x_new t_new] = chunk.get_aligned_data(x(:,5:7),t);

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


%}
%LWL
win = 9;
mu = ceil(win/2);
sigma = win/30;
row_n = floor(length(x_rms) / win);
coef_L = zeros(size(x_rms,2),row_n);
coef_R = zeros(size(x_rms,2),row_n);
weight = ((1:win) - mu).^2 / (2 * sigma^2);
weight = exp(-weight);
r = diag(weight);
for i = 0:(row_n - 1)
    temp = x_rms(1 + i * win: (i + 1) * win,:);
    a = temp' * r * temp;
    if(rank(a) >= size(x_rms,2))
        y_L = t(1 + i * win:(i + 1) * win ,1);
        y_R = t(1 + i * win: (i + 1) * win,2);
        temp_L =  a\(temp' * r * y_L);
        temp_R =  a\(temp' * r * y_R);
        coef_L(:,i + 1) = temp_L;
        coef_R(:,i + 1) = temp_R;
    end
end

x_pre = x_rms(floor(win/2) + (0:row_n - 1) * win,:);
t_test = t_rms(floor(win/2) + (0:row_n - 1) * win,1);
t_pre = sum(x_pre .* transpose(coef_L),2);

figure
plot(floor(win/2) + (0:row_n - 1) * win, t_test, '-'); 
hold on 
plot(floor(win/2) + (0:row_n - 1) * win, t_pre, '-');


