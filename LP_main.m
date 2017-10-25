function fLP_main = LP_main(y,A,D,sigma,tau)
% This is the implementation of the algorithm based on linear programming
[m,n]= size(A);
% compute optimal solution
cvx_begin;
variable h(n);
variable u;
minimize(norm(D'*h,1)+abs(u));
subject to
y.*(A*h-(u/sigma).*tau) >= 0;
norm(A*h-(u/sigma).*tau,1)<= 1;
cvx_end

fLP_main = (sigma/u).*h;

end