
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



%LWL
win = 3000;
mu = ceil(win/2);
set = 30
sigma = win/set;
alpha2_w = [];
alpha2 = [];
%{
for j = 1 : length(set)
    
    %error = [];
    t_test = [];
    t_pre = [];
    alpha2_w = [];
    alpha2 = [];
    
    for i = 1:floor(L/win)
        t2 = t_rms(1 + (i-1) * win : i * win,2);
        x1 = x_rms(1 + (i-1) * win : i * win,[1,3]);
        
        weight = ((1:win) - mu).^2 / (2 * sigma^2);
        weight = exp(-weight);
        r = diag(weight);
        %a = transpose(x1) * r * x1;
        %coef = a \(transpose(x1) * r * t2);
        %t_test = [t_test, t2(mu)];
        coef_w = (r * x1) \t2;
        coef = x1\t2;
        %t_pre = [t_pre, x1(mu,:) * coef];
        %e = (t2(mu) - x1(mu,:) * coef)^2;
        alpha2_w = [alpha2_w, coef_w(2)];
        alpha2 = [alpha2, coef(2)];
        %error = [error, e];
    end
%    se(j) = sum(error);
end
    %}
grid = 1000;
row_n = floor((L - win)/ grid) + 1;
for i = 0:(row_n - 1)
    t2 = t_rms(i * grid + 1: i * grid + win,2);
    x1 = x_rms(i * grid + 1: i * grid + win,[1,3]);
        
    weight = ((1:win) - mu).^2 / (2 * sigma^2);
    weight = exp(-weight);
    r = diag(weight);
        %a = transpose(x1) * r * x1;
        %coef = a \(transpose(x1) * r * t2);
        %t_test = [t_test, t2(mu)];
        coef_w = (r * x1) \t2;
        coef = x1\t2;
        %t_pre = [t_pre, x1(mu,:) * coef];
        %e = (t2(mu) - x1(mu,:) * coef)^2;
        alpha2_w = [alpha2_w, coef_w(2)];
        alpha2 = [alpha2, coef(2)];
        %error = [error, e];
    end

figure
subplot(2,1,1)
plot(alpha2);
subplot(2,1,2)
plot(alpha2_w);
ylim([0 8]);

