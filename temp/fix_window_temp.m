%{
run('../always.m');
init_hotelcalifornia();

%}


win_length = [600, 700, 800, 900];
figure,
for i = 1:length(win_length)
    [w_L, w_R] = find_coef_fixed(x, t, win_length(i));
    perdict_t = sum(x(1:length(w_L),:) .* transpose(w_L),2);
    temp_t_L = t(1:length(w_L),1);
    subplot(2,2,i)
    plot(temp_t_L); 
    ylim([-2 2])
    hold on;
    plot(perdict_t);
    title(sprintf('window length %d',win_length(i)))
end
    