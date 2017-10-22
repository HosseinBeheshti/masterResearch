function [xSOCP_main,XSOCP_main] = SOCP_main(x,A,s,R,T,e,b)

% x: the vector to be recovered
% A: the matrix whose rows give the measurements
% s: the sparsity of x
% R: an (over)estimation of the magnitude of the vector to be recovered
% T: the number of adaptive groups of measurements
% e: a vector prequantization measurement errors
% b: a vector of bit flips

% This is the implementation of the algorithm based on second-order cone programming

[m,n] = size(A);
if nargin < 7
    b=ones(m,1);
end
if nargin < 6
    e=zeros(m,1);
end

xSOCP_main = zeros(n,1);
XSOCP_main = zeros(n,T);
for t = 1:T
    At = A((t-1)*m/T+1:t*m/T,:);
    et = e((t-1)*m/T+1:t*m/T);
    bt = b((t-1)*m/T+1:t*m/T);
    tau = R/2^(t-1)*randn(m/T,1);
    yt = bt.*sign(At*(xSOCP_main-x)-tau+et);
    z = SOCP_Order1(yt,At,R/2^(t-1),tau);
    xSOCP_main = hard_threshold(xSOCP_main-z,s);
    XSOCP_main(:,t) = xSOCP_main;
end

end