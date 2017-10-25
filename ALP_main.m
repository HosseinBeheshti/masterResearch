function [fLP_main,h,u] = ALP_main(D,A,f,sigma,T)

[m,n]= size(A);
DitherType = 'LP';

for t = 1:T
    ATemp = A((t-1)*m/T+1:t*m/T,:);
    tauTemp = DitherGenerator(m,2^(1-t).*sigma,DitherType);
    yTemp = sign(ATemp*(f-x)-tauTemp);
fLP = LP(y,A,D,sigma,tauTemp);
end








end