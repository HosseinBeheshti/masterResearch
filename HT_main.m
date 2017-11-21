function fHT_main = HT_main(D,A,f,t,th_var,r)

[m,n]= size(A);
DitherType = 'HT';
tau = DitherGenerator(m,th_var,DitherType);
y = sign(A*f-tau);
z = HardThreshold(D'*A'*y,t-1);
fHT_main = ((-th_var^2)/(tau'*y)).*D*z;
end