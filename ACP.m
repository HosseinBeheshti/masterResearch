function f_ACP = ACP(y,A,D,fACP,tau,r)
% Second-order cone programming 
[m,n]= size(A);
cvx_begin quiet;
variable h(n);
minimize(norm(D'*(h-fACP),1));
subject to
y.*(A*h-A*fACP-tau) >= 0;
norm(h-fACP,2) <= r;
cvx_end

f_ACP = h;
end