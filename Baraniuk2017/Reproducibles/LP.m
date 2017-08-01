function [xLP]=LP(y,A)

% y: the vector of quantized measurements 
% A: the matrix whose rows give the measurements

% This is the linear program proposed in
% ONE-BIT COMPRESSED SENSING BY LINEAR PROGRAMMING
% by Plan and Vershynin

[m,n] = size(A);
cvx_begin
  variable xLP(n);
  minimize( norm(xLP,1) );
  subject to
    y.*(A*xLP) >= 0;
    sum(y.*(A*xLP)) == m;
cvx_end

end