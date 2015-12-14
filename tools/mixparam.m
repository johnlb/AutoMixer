function A = mixparam(X,Y)
% X(k,n,m): mixing data
%           k, frequency; n, time (frame number); m, mixing channel
% A(m,k): mixing parameters
%
% Y(k,n): master
%
% for every k
%
%   Y(k,:)(1xN)' = X(k,:,:)(NxM)*A(:,k)(Mx1)
%
%   A(:,k)(Mx1) = X(k,N,M)(MxN)\Y'(k,:)(Nx1)
%
% end
%


[K,N,M] = size(X);
A = ones(M,K);
for k = 1:K
  Xk = abs(reshape(X(k,:,:),N,M));


  Ex = sum(Xk,1);
  Ex = Ex';
  ptrs = Ex > .05;
  
  Yk = abs(Y(k,:)');
  A(ptrs,k) = pinv(Xk(:,ptrs))*Yk;
end