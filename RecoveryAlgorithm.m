function [x_out] = RecoveryAlgorithm(y,A,r,tau,t,type)
% y: the vector of quantized measurements
% A: the matrix whose rows give the measurements
% R: an (over)estimation of the magnitude of the vector to be recovered
% tau: the thresholds used in producing the vector y

% This is the implementation of the second-order-cone-programming-based order one scheme 

[m,n] = size(A);
cvx_begin
    variable xSOCP_Order1(n);
    minimize( norm(x_out,1) );
    subject to 
      y.*(A*x_out-tau) >= zeros(m,1);
      norm(x_out,2) <= r;
cvx_end

end