function aps3 = aveoct3(ps3)
% calculate the average of ps3 (1/3 octave power spectra)
% ps3 in dimension of cFxN
aps3 = mean(ps3,2);