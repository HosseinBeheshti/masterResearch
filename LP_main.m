function fLP_main = LP_main(D,A,f,th_var)

[m,n]= size(A);
tau = DitherGenerator(m,th_var);
y = sign(A*f-tau);
fLP_main =  LP(y,A,D,th_var,tau);

end