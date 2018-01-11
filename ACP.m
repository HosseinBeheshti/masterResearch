function f_ACP = ACP(y,A,D,phi,r)
% Second-order cone programming 
[m,n]= size(A);
cvx_begin quiet;
variable h(n);
minimize(norm(D'*h,1));
subject to
y.*(A*h-phi) >= 0;
norm(h,2) <= r;
cvx_end

f_ACP = h;
end