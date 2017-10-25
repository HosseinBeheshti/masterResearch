function fALP_main = ALP_main(D,A,f,th_var,T)

[m,n]= size(A);
DitherType = 'LP';
fALP_main= zeros(n,T+1); 
ofset = zeros(m/T,1);
for t = 1:T
    ATemp = A((t-1)*m/T+1:t*m/T,:);
    tauTemp = DitherGenerator(m/T,(2)^(1-t).*th_var,DitherType);
    yTemp = sign(ATemp*(f)-(ofset+tauTemp));
    fLPTemp = LP(yTemp,ATemp,D,2^(1-t).*th_var,ofset+tauTemp);
    ofset = ATemp*(fLPTemp+fALP_main(:,t));
    fALP_main(:,t+1) = fLPTemp;
end
end