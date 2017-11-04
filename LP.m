function f_LP = LP(y,A,D,th_var,tau)
% y: the vector of quantized measurements 
% A: the matrix whose rows give the measurements
% D: the dictionary whose give the s-sparse vector

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

f_LP = (th_var/u).*h;
end