function f_CP = CP(y,A,D,th_var,tau)
[m,n]= size(A);
% compute optimal solution
cvx_begin;
variable h(n);
variable u;
minimize(norm(D'*h,1)+abs(u));
subject to
y.*(A*h-(u/th_var).*tau) >= 0;
norm(A*h-(u/th_var).*tau,1)<= 1;
cvx_end

f_CP = (th_var/u).*h;
end