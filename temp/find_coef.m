%{
run('../../always.m');
init_hotelcalifornia();
%}

%Create cell array with fixed window length


window_length = 3000;
row_n = floor(length(x) / window_length);


coef_L = zeros(size(x,2),row_n);
coef_R = zeros(size(x,2),row_n);
for i = 0:(row_n - 1)
    temp = x(1 + i * window_length: (i + 1) * window_length,:);
    if(rank(temp) >= size(x,2))
            y_L = t(1 + i * window_length:(i + 1) * window_length ,1);
            y_R = t(1 + i * window_length: (i + 1) * window_length,2);
            coef_L(:,i) = LSS.CFS(temp, y_L);
            coef_R(:,i) = LSS.CFS(temp, y_R);
    end
end

if(row_n * window_length < length(x))
    temp = x(length(x) - window_length + 1: end,:);
    if(rank(temp) > size(x,2))
            y_L = t(length(x) - window_length + 1: end,1);
            y_R = t(length(x) - window_length + 1: end,2);
        
            coef_L = horzcat(coef_L,regress(y_L, temp));
            coef_R = horzcat(coef_R,regress(y_R, temp));
    end
end


fprintf('End Computation\n')
coef_result_L = sum(sum(coef_L,1) ~= 0);

