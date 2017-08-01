function [xHT_Order1] = HT_Order1_round2(ytilde,B,s,R,u,v,w)

% ytilde: the vector of quantized measurements determined by the first round
% B: the matrix whose rows give the measurements
% s: the sparsity of the vector to be recovered
% R: an (over)estimation of the magnitude of the vector to be recovered
% u,v,w: vectors produced by the first round 

% This is the implementation of the hard-thresholding-based order-one scheme
% the second round outputs an approximation of the vector to be recovered

t = hard_threshold(B'*ytilde,s); 
t = t/norm(t);
xHT_Order1 = 2*R*( 1- sqrt(1-(t'*v)^2)/(t'*v) )*u;

end