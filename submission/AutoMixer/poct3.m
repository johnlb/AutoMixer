function poct = poct3(X, f, cF)
% X, STFT data of dimension KxNxM
bw = [cF*2^(-1/6),cF*2^(1/6)];  % lower and upper of 1/3 octaves
bN = length(cF);                % band number (same as cF)
fw = [f-f(2)/2,f+f(2)/2];       % lower and upper of STFT
fN = length(fw);                % STFT number
poct = zeros(bN,1);
i = 1; j = 1;                   % while loop 1 <= i <= fN
while(j <= bN && i <=fN)        %            1 <= j <= bN
  if(fw(i,2) < bw(j,1))         % if fw upper < bw lower
      i = i+1;                  % fw ++ and do nothing
      continue;
  end;
  r = (min(fw(i,2),bw(j,2))-max(fw(i,1),bw(j,1)))/f(2); % overlap rate
  poct(j) = poct(j)+r*abs(X(i))^2;  % add to poct partially
  if(fw(i,2)<bw(j,2))           % if fw upper < bw upper
      i = i+1;                  % fw ++
  else
      j = j+1;                  % else bw ++
  end;
end