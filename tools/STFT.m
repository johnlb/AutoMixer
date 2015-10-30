function [X,Xact] = STFT(x, len, ovl)
%REQ: x is a row vector of doubles, len is an integer, inc is an even
%     integer.
%MOD: none.
%EFF: Returns the STFT of [x] using a Hanning window of length
%     [len] samples and an overlap of [ovl] samples.
%     any points in [x] beyond the max integer number of
%     windows is discarded.

    [L blah] = size(x);
    inc = len - ovl;

    %Number of increments
    N = floor( (L-len)/inc );
    
    
    %Window function
    w = hann(len);
    

    X = zeros(len, N);
    for i = 1:N
        
        %Starting index
        start = (i-1)*inc + 1;
        
        %Windowed x
        xw = w.*x( (start):(start+len-1) );
        
        X(:,i) = fft(xw);
    end
Xact = X;
    %Remove redundant information.
    X(len/2+2:end,:) = [];
    
end