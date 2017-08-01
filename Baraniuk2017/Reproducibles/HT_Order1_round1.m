function [u,v,w] = HT_Order1_round1(y,A,s,R)

% y: the vector of quantized measurements 
% A: the matrix whose rows give the measurements
% s: the sparsity of the vector to be recovered
% R: an (over)estimation of the magnitude of the vector to be recovered

% This is the implementation of the hard-thresholding-based order-one scheme
% the first round constructs vectors for the second round of measurements 

[u,supp] = hard_threshold(A'*y,s);
u = u/norm(u);
v = zeros(size(u)); 
v(supp(1)) = u(supp(2)); 
v(supp(2)) = -u(supp(1)); 
v = v/norm(v);
w = 2*R*(u+v);

end