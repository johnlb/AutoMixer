%% find_eq: you guessed it.
function [AL AR] = find_eq(xL,xR, tL,tR, ts)

	N       = size(xL,1);
	K       = size(xL,2);
	fs 		= 1/ts;

	FFT_LEN   = 8192;
	FFT_OVL   = round(FFT_LEN/4);
	FFT_STEP  = FFT_LEN-FFT_OVL;

	freq = (0:FFT_LEN/2)*fs/FFT_LEN;



	% Run STFT
	for k = 1:K
	  fprintf('Doing STFT for Track %i\n', k);
	  XL(:,:,k) = STFT(xL(:,k), FFT_LEN,FFT_OVL);
	  XR(:,:,k) = STFT(xR(:,k), FFT_LEN,FFT_OVL);
	end
	XL = abs(XL);
	XR = abs(XR);


	[~, Nf, ~] = size(XL);
	YL = STFT(tL, FFT_LEN,FFT_OVL);
	YR = STFT(tR, FFT_LEN,FFT_OVL);
	YL = abs(YL);
	YR = abs(YR);



	% Find LS EQ curves
	AL = mixparam(XL,YL)';
	AR = mixparam(XR,YR)';



	% Smooth EQ curves
	fprintf('Smoothing frf\n');
	AL = 20.*log10(abs(AL));
	AR = 20.*log10(abs(AR));
	for ii = 1:K
		[AL(:,ii) AL_oct(:,ii)] = generate_smooth_tf(freq,AL(:,ii));
		[AR(:,ii) AR_oct(:,ii)] = generate_smooth_tf(freq,AR(:,ii));
	end




	% Find FIR filter
	AL_ = zeros(FFT_LEN,K);
	AR_ = zeros(FFT_LEN,K);
	for ii = 1:K
		AL_(:,ii) = gain2fir(AL(:,ii),1);
		AR_(:,ii) = gain2fir(AR(:,ii),1);
		% AL(:,ii) = gain2fir(AL(:,ii),1);
		% AR(:,ii) = gain2fir(AR(:,ii),1);
	end

	AL = AL_;
	AR = AR_;


end