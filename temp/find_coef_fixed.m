function [ coef_L,coef_R ] = find_coef_fixed(x, t, window_length)
    
    row_n = floor(length(x) / window_length);
    coef_L = zeros(size(x,2),row_n);
    coef_R = zeros(size(x,2),row_n);
    for i = 0:(row_n - 1)
        temp = x(1 + i * window_length: (i + 1) * window_length,:);
        if(rank(temp) >= size(x,2))
            y_L = t(1 + i * window_length:(i + 1) * window_length ,1);
            y_R = t(1 + i * window_length: (i + 1) * window_length,2);
            temp_L = LSS.CFS(temp, y_L);
            temp_R = LSS.CFS(temp, y_R);
            for k = 1:window_length
                coef_L(:,i*window_length + k) = temp_L;
                coef_R(:,i*window_length + k) = temp_R;
            end
        end
    end
end

