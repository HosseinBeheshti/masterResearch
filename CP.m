function f_CP = CP(y,A,D,tau,r)
[m,n]= size(A);
% Second-order cone programming 
cvx_begin quiet;
variable h(n);
minimize(norm(D'*h,1));
subject to
y.*(A*h-tau) >= 0;
norm(h,2)<= r;
cvx_end

f_CP = h;
end