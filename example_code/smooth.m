datapath = '../stems';

[a,Fs] = audioread([datapath '/hotel_california/Vox_Guitar.mp3']);
y = a(:,1); %data
z = abs(y); %absolute value of data

sec = size(y); %size of data
x = 1:sec; 
plot(x,y); %plot of data

figure(2);
plot(x,z); %plot of abs value


filter_length = 0.5*Fs; %1 second
filter_threshold = 0.022;

envelope = smooth(z,filter_length,'loess');
fig = figure(3);
plot(x,envelope); %plot smooth

%shrinks data for faster computation
shrink = Fs;
shrink_size = floor(sec/shrink);
envelope1 = zeros(1,shrink_size(1));
for i = 1:shrink_size(1)
    envelope1(i) = envelope(i*shrink);
end

figure(4);
x1 = 1:shrink_size(1);
plot(x1,envelope1);

%smooth data even more
filter_length1 = 20;
envelope1 = smooth(envelope1,filter_length1,'loess');
fig1 = figure(5);
x1 = 1:shrink_size(1);
plot(x1,envelope1);

%find min points below threshold
below = 1;
below_min = 0;
indice = 0;
min_points = [0];
for k = 1:shrink_size(1);
    if envelope1(k) <= filter_threshold
        if below == 0
           below = 1;
           below_min = envelope1(k);
           indice = k;
        else
            if envelope1(k) < below_min
                below_min = envelope1(k);
                indice = k;
            end
        end
    else
        if below == 1
            below = 0;
            min_points(end+1) = indice;
        end
    end
end
