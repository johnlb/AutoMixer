always;
init_recording;
[data_len, M] = size(x);
len = 1024;
for m = 1:M
  X(:,:,m) = STFT(x(1:1000000,m),len,len/2);
end
[K,N,M] = size(X);
M = M-3;
Y1 = STFT(t(1:1000000,1),len,len/2);
Y2 = STFT(t(1:1000000,2),len,len/2);
A1 = mixparam(X(:,:,[1,2,4,6,7,8]),Y1);
A2 = mixparam(X(:,:,[1,3,5,6,7,9]),Y2);
l_names = x_names([1,2,4,6,7,8]);
r_names = x_names([1,3,5,6,7,9]);
fn = 1+len/2;
f = fs*[0:len-1]/len;
f = f(1:fn);
figure(1);
for m = 1:M
  subplot(M,2,2*m-1); plot(f,abs(A1(m,:)));
  title(l_names(m));
  subplot(M,2,2*m); plot(f,abs(A2(m,:)));
  title(r_names(m));
end
subplot(M,2,M+M-1); xlabel('frequency (Hz)');
subplot(M,2,M+M); xlabel('frequency (Hz)');


figure(10);
for m = 1:M
  subplot(M,2,2*m-1); imagesc(abs(X(1:10,:,m)));
  title(l_names(m));
  subplot(M,2,2*m); imagesc(abs(X(1:10,:,m)));
  title(r_names(m));
end

figure(11);
subplot(211);
imagesc(abs(Y1(1:10,:)));
subplot(212);
imagesc(abs(Y2(1:10,:)));



figure(12);
subplot(211);
imagesc(abs(Y1(1:10,:)));
subplot(212);
imagesc(abs(X(1:10,:,1)));

coefficients = ones(1,20)/20;
smoothplot = filter(coefficients,1,abs(A1(1,:)));

coefficients2 = ones(1,40)/40;
smoothplot2 = filter(coefficients2,1,abs(A1(1,:)));

figure(13);
semilogx(f,abs(A1(1,:)));
hold all;
%plot(f,abs(A1(1,:)));
semilogx(f,smoothplot2);
hold off;