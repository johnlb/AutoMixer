%{
run('../always.m');
init_hotelcalifornia();

%}


win_length = 1000;
step = [600, 700, 800, 900];
figure,
for i = 1:length(step)
    [w_L, w_R] = find_coef_sliding(x, t, win_length, step(i));
    perdict_t = sum(x(1:length(w_L),:) .* transpose(w_L),2);
    temp_t_L = t(1:length(w_L),1);
    subplot(2,2,i)
    plot(temp_t_L); 
    ylim([-2 2])
    hold on;
    plot(perdict_t);
    title(sprintf('window length %d with step %d',win_length, step(i)));
end