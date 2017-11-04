function f_ALP = ALP(y,A,D,f_estimate,th_var,tau)
[m,n]= size(A);
% compute optimal solution
cvx_begin;
variable h(n);
variable u;
minimize(norm(D'*h,1)+norm(u,1));
subject to
y.*(A*(h-f_estimate)-(u/th_var).*tau) >= 0;
norm(A*(h-f_estimate)-(u/th_var).*tau,1) <= 1;
cvx_end

f_ALP = (th_var/u).*h;
end