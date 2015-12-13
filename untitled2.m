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
set = 30
se = zeros(size(set));
for j = 1 : length(set)
    sigma = win/set(j);
    error = [];
    t_test = [];
    t_pre = [];
    for i = 1000 : 10:  2000
        t1 = t_rms((1:win) * i,1);
        x1 = x_rms((1:win) * i,:);
        rank(x1);
        mu = ceil(win/2);
        sigma = win/30;
        weight = ((1:win) - mu).^2 / (2 * sigma^2);
        weight = exp(-weight);
        r = diag(weight);
        a = transpose(x1) * r * x1;
        coef = a \(transpose(x1) * r * t1);
        t_test = [t_test, t1(mu)];
        t_pre = [t_pre, x1(mu,:) * coef];
        e = (t1(mu) - x1(mu,:) * coef)^2;
        error = [error, e];
    end
    se(j) = sum(error);
end

figure
plot(t_test, 'x'); 
hold on 
plot(t_pre, 'o');


