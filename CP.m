function [xCP]=CP(y,A,s)

% y: the vector of quantized measurements
% A: the matrix whose rows give the measurements
% s: the sparsity of the vector to be recovered

% This is the linear program proposed in
% ROBUST 1-BIT COMPRESSED SENSING AND SPARSE LOGISTIC REGRESSION: A CONVEX PROGRAMMING APPROACH
% by Plan and Vershynin

[m,n] = size(A);
cvx_begin
  variable xCP(n);
  maximize( y'*(A*xCP) );
  subject to
    norm(xCP) <= 1;
    norm(xCP,1) <= sqrt(s);
cvx_end

end