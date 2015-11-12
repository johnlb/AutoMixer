function poct = poct3(X, f, cF)
bw = [cF*2^(-1/6),cF*2^(1/6)];
bN = length(cF);
poct = zeros(bN,1);
i3 = find(f>bw(1,1) & f<bw(end,end));
f3 = f(i3);
N = length(f3);
for i = 1:N
  %if(f3(i)<bw(1,1)) continue; end;
  j = 1;
  while(bw(j,2)<f3(i)) j = j+1; end;
  %if(j <= bN) poct(j)=poct(j)+abs(X(i)^2); end;
  poct(j)=poct(j)+abs(X(i+i3(1)-1))^2;
end