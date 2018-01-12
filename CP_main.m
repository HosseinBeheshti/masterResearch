function fCP_main = CP_main(D,A,f,th_var,r)

[m,n]= size(A);
tau = DitherGenerator(m,th_var);
y = sign(A*f-tau);
fCP_main =  CP(y,A,D,tau,r);

end