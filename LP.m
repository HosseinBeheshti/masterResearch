function [f_LP,h,u] = LP(y,A,D,sigma,tau)
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

f_LP = (sigma/u).*h;
end