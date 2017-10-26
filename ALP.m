function f_ALP = ALP(y,A1,A2,D)
[m,n]= size(A1);
q = size(A2,2);
% compute optimal solution
cvx_begin;
variable h(n);
variable u(q);
minimize(norm(D'*h,1)+norm(u,1));
subject to
y.*(A1*h-A2*u) >= 0;
norm(A1*h-A2*u)<2= 1;
cvx_end

f_ALP =h;
end