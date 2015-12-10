function [coef_L, coef_R] = cal_plot( x_rms, t_rms, M, p, word)
    M = 3000;
    L = length(x_rms);
    row_n = floor(L/M);
    coef_L= zeros(size(x_rms,2),row_n * M);
    coef_R = zeros(size(x_rms,2),row_n * M);
    reduced_coef_L = zeros(size(x_rms,2),row_n * M);
    reduced_coef_R = zeros(size(x_rms,2),row_n * M);
    col_x = length(x_rms(1,:));
    
    sum_rms = zeros(size(x_rms, 2), row_n * M);

    for i = 0:(row_n - 1)
        idx = 1 + i * M: (i + 1) * M;
        temp = x_rms(idx,:);
        y_L = t_rms(idx ,1);
        y_R = t_rms(idx,2);
        coef_L(:,idx) = repmat(temp\y_L,1,M);
        coef_R(:,idx) = repmat(temp\y_R,1,M);
        % to add constraint to those gain coefficient.
        threshold = 10; % threshold to sum of rms to reduce the gain to zero
        for j = 1 : size(x_rms, 2)
            sum_rms(j, idx) = repmat(sum(x_rms(idx, j)), 1, M);
            reduced_coef_L(j,idx) = coef_L(j,idx) .* (sum_rms(j, idx) > threshold);
            reduced_coef_R(j,idx) = coef_R(j,idx) .* (sum_rms(j, idx) > threshold);
        end
        
    end
    
    if p == 1
        figure
        n = size(x_rms,2);
        for i = 1:n
            subplot(ceil(n/2), 2, i);
            plot(coef_L(i,:), '-r');
            hold on
            plot(reduced_coef_L(i,:), '-g');
        end
        legend('original_gain', 'reduced_gain');
        title(word);
    end


end

