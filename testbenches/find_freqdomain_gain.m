% assumes run_find_coeffs has been run.
clear find_freqdomain_gain


N       = size(x,1);
K       = size(x,2);
FFT_LEN   = 8192;
FFT_OVL   = round(FFT_LEN/4);
FFT_STEP  = FFT_LEN-FFT_OVL;


% Do STFT on all the things
for k = 1:K
  fprintf('Doing STFT for Track %i\n', k);
  X(:,:,k) = STFT(x(:,k), FFT_LEN,FFT_OVL);
end
X = abs(X);


[~, Nf, ~] = size(X);
YL = STFT(t(:,1), FFT_LEN,FFT_OVL);
YR = STFT(t(:,2), FFT_LEN,FFT_OVL);
YL = abs(YL(:,:));
YR = abs(YR(:,:));

XL = X(:,:,pan(:,1));
XR = X(:,:,pan(:,2));




% Find Transfer Function
AL = mixparam(XL,YL)';
AR = mixparam(XR,YR)';






% Fit a system





% Run the fit system on the data.
xL_eq = zeros(size(xL));
xR_eq = zeros(size(xR));
for ii = 1:K
	xL_eq(:,ii) = 
	xR_eq(:,ii) = 
end



% Do mixing
yL = sum(aL.*xL_eq, 2);
yR = sum(aR.*xR_eq, 2);


audiowrite([DATA_PATH '/hotel_california/output/prediction_eq_after.wav'],[yL yR],fs);