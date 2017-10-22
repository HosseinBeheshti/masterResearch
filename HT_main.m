function [xHT_main,XHT_main] = HT_main(x,A,s,R,T,e,b)

% x: the vector to be recovered
% A: the matrix whose rows give the measurements
% s: the sparsity of x
% R: an (over)estimation of the magnitude of the vector to be recovered
% T: the number of adaptive groups of measurements
% e: a vector prequantization measurement errors
% b: a vector of bit flips

% This is the implementation of the algorithm based on hard thresholding

[m,n] = size(A);
if nargin < 7
    b=ones(m,1);
end
if nargin < 6
    e=zeros(m,1);
end

xHT_main = zeros(n,1);
XHT_main = zeros(n,T);
for t=1:T
    At1 = A((t-1)*m/T+1:(2*t-1)*m/(2*T),:);
    et1 = e((t-1)*m/T+1:(2*t-1)*m/(2*T));
    bt1 = b((t-1)*m/T+1:(2*t-1)*m/(2*T));
    At2 = A((2*t-1)*m/(2*T)+1:t*m/T,:);
    et2 = e((2*t-1)*m/(2*T)+1:t*m/T);
    bt2 = b((2*t-1)*m/(2*T)+1:t*m/T);
    yt1 = bt1.*sign(At1*(xHT_main-x)+et1);
    [u,v,w] = HT_Order1_round1(yt1,At1,2*s,(R/2^(t-1)));
    yt2 = bt2.*sign(At2*(w-(xHT_main-x))+et2);
    z = HT_Order1_round2(yt2,At2,2*s,(R/2^(t-1)),u,v,w);
    xHT_main = hard_threshold(xHT_main-z,s);
    XHT_main(:,t) = xHT_main;
end

end