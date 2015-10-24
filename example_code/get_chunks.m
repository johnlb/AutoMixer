
thresh = 10^(-60/20);



datapath = '../stems';

[raw fs] = audioread([datapath '/hotel_california/Vox_Guitar.mp3']);
tsamp = 1/fs;


x = raw(:,1);


[vals locs] = findpeaks(x);


ptrs = find(vals<thresh);

tpks = locs