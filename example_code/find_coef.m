%{
run('../../always.m');
init_hotelcalifornia();
%}

%Create cell array with fixed window length
%Plan: to calculate coef for each time point
%Result: time-consuming
x_sub = x(1:end,:);
t_sub = t(1:end,:);

window_length = 500;
row_n = floor(length(x_sub) / window_length);

coef_L = zeros(size(x_sub,2),row_n);
coef_R = zeros(size(x_sub,2),row_n);
for i = 0:(row_n - 1)
    temp = x_sub(1 + i * window_length: (i + 1) * window_length,:);
    if(rank(temp) >= size(x_sub,2))
        %{
        for j = 1:window_length
            y_L = zeros(window_length,1) + t_sub(i * window_length + j,1);
            y_R = zeros(window_length,1) + t_sub(i * window_length + j,2);
        
            coef_L(:,i) = regress(y_L, temp);
            coef_R(:,i) = regress(y_R, temp);
        end
        %}
            y_L = t_sub(1 + i * window_length:(i + 1) * window_length ,1);
            y_R = t_sub(1 + i * window_length: (i + 1) * window_length,2);
            coef_L(:,i) = regress(y_L, temp);
            coef_R(:,i) = regress(y_R, temp);
    end
end

if(row_n * window_length < length(x_sub))
    temp = x_sub(length(x_sub) - window_length + 1: end,:);
    if(rank(temp) > size(x,2))
            y_L = t_sub(length(x_sub) - window_length + 1: end,1);
            y_R = t_sub(length(x_sub) - window_length + 1: end,2);
        
            coef_L = horzcat(coef_L,regress(y_L, temp));
            coef_R = horzcat(coef_R,regress(y_R, temp));
    end
end

fprintf('End Computation\n')
coef_result_L = sum(sum(coef_L,1) ~= 0);

