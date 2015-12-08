function [coef_L, coef_R] = cal_plot( x_rms, t_rms, M, p, word)
    M = 3000;
    L = length(x_rms);
    row_n = floor(L/M);
    coef_L= zeros(size(x_rms,2),row_n * M);
    coef_R = zeros(size(x_rms,2),row_n * M);

    for i = 0:(row_n - 1)
        idx = 1 + i * M: (i + 1) * M;
        temp = x_rms(idx,:);
        y_L = t_rms(idx ,1);
        y_R = t_rms(idx,2);
        coef_L(:,idx) = repmat(temp\y_L,1,M);
        coef_R(:,idx) = repmat(temp\y_R,1,M);
    end
    if p == 1
        figure
        n = size(x_rms,2);
        for i = 1:n
            subplot(ceil(n/2), 2, i);
            plot(coef_L(i,:), '-');
            ylim([-5 5])
            hold on
            %{
            subplot(ceil(n/2), 2, i);
            plot(coef_R(i,:), 'g-');
            ylim([-5 5])
            hold on
            %}
        end
        title(word);
    end


end

