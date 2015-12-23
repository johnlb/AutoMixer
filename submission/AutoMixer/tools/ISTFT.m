function x = ISTFT(X, ovl)
%REQ: X is a 2-D array of doubles, inc is an even integer
%     X is the LOWER HALF of an STFT (i.e. it is mirrored
%     before inverting).
%MOD: none.
%EFF: returns the inverse STFT of X using an overlap of [ovl].
    
    [L N] = size(X);
    
    %Mirror X about endpoint (in frequency)
    for i = 2:L
       
        X(2*L - i,:) = conj( X(i,:) );
        
    end

    [L N] = size(X);
    
    
    %initialize x
    x = [];
    
    
    %Overlap-add
    for i = 1:N
        
        %Get the current window of data.
        curWin = ifft(X(:,i))./hann(L);
        
        %Remove overlap/2 points from ends of window.
        curWin(1:ovl/2) = [];
        curWin(end-ovl/2+1:end) = [];
        
        %Append to x.
        x = [x; curWin];
        
    end

    
end