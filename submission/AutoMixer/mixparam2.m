function A = mixparam2(X,Y)
% X(k,n,m) with dimension of KxNxM
%          k: frequency, n: time, m: sub-track
% Y(k,n) with dimension of KxN
% A(m,k): the mixing parameters for track m and frequency k,
%               Y(k,:)' = X(k,:,:)*A(:,k)
%                Nx1        NxM     Mx1
% For N > M, the least-squares solution
%               A(:,k) = X(k,:,:)\Y(k,:)'
%                Mx1       MxN     Nx1
[K,N,M] = size(X);
A = zeros(M,K);
for k = 1:K
    Xk = reshape(X(k,:,:),N,M);
    Yk = Y(k,:)';
    %A(:,k) = Xk\Yk;
    A(:,k) = pinv(Xk,0.5)*Yk;
end

  
