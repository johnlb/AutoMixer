function [ val ] = gof( tL, yL )
%gof returns the similarity between two functions
%   Detailed explanation goes here

%perform time alignment
nwins_ta = 99;
winSize = 2000;
N = size(tL,1);

[nwins_ta winSize_ta nwins winSize] = find_window_sizes(nwins_ta, winSize, N);
wins_timealign  = 1 + bsxfun(@plus, (0:winSize_ta-1)',winSize_ta*(0:nwins_ta-1));
[yLnew nL] = time_align(yL,tL, wins_timealign);

%calc inner product
init_inner = tL'*tL;
out_inner = yLnew'*tL;

out = abs(out_inner./init_inner);
fprintf('out is, %d', out);

%calc rms diff
init_rms = rms(tL);
out_rms = rms(yLnew);

if out_rms < init_rms 
    diff = abs(init_rms-out_rms);
else
    diff = 200*abs(init_rms-out_rms).^2;
end
    
fprintf('diff is, %d', diff);

%minimize rms difference(diff) while maximizing similarity(out)
val = out - diff;


end

