function f_ACP = ACP(y,A,D,f_estimate,tau,r)
[m,n]= size(A);
% Second-order cone programming 
cvx_begin;
variable h(n);
minimize(norm(D'*h,1));
subject to
y.*(A*(h-f_estimate)-tau) >= 0;
norm(h,2) <= r;
cvx_end

f_ACP = h;
end