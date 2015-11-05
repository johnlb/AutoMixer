function [ coef_L, coef_R ] = find_coef_sliding(x, t, window_length, step )
    row_n = floor((length(x) - window_length)/ step) + 1;

    coef_L = zeros(size(x,2),row_n);
    coef_R = zeros(size(x,2),row_n);
    for i = 0:(row_n - 1)
        temp = x(i * step + 1: i * step + window_length,:);
        if(rank(temp) >= size(x,2))
            y_L = t(i * step + 1: i * step + window_length,1);
            y_R = t(i * step + 1: i * step + window_length,2);
            coef_L(:,i) = LSS.CFS(temp, y_L);
            coef_R(:,i) = LSS.CFS(temp, y_R);
        end
    end

end

