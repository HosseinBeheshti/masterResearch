function [fLP_main,h,u] = LP_main(D,A,f,th_var)
[m,n]= size(A);
DitherType = 'LP';
tau = DitherGenerator(m,th_var,DitherType);
y = sign(A*f-tau);
fLP_main = LP(y,A,D,th_var,tau);
end