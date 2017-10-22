function [xSOCP_Order1] = SOCP_Order1(y,A,R,tau)

% y: the vector of quantized measurements
% A: the matrix whose rows give the measurements
% R: an (over)estimation of the magnitude of the vector to be recovered
% tau: the thresholds used in producing the vector y

% This is the implementation of the second-order-cone-programming-based order one scheme 

[m,n] = size(A);
cvx_begin
    variable xSOCP_Order1(n);
    minimize( norm(xSOCP_Order1,1) );
    subject to 
      y.*(A*xSOCP_Order1-tau) >= zeros(m,1);
      norm(xSOCP_Order1,2) <= R;
cvx_end

end