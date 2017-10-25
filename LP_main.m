function [fLP_main,h,u] = LP_main(D,A,f,sigma)
[m,n]= size(A);
DitherType = 'LP';
tau = DitherGenerator(m,sigma,DitherType);
y = sign(A*f-tau);
[fLP_main,h,u] = LP(y,A,D,sigma,tau);
end