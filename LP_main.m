function [fLP_main,FLP_main] = LP_main(f,A,s,r,T,eb,ea)

% f: the vector to be recovered
% A: the matrix whose rows give the measurements
% s: the sparsity of x
% r: an (over)estimation of the magnitude of the vector to be recovered
% T: the number of adaptive groups of measurements
% eb: a vector prequantization measurement errors
% ea: a vector of bit flips

% This is the implementation of the algorithm based on second-order cone programming

[m,n] = size(A);
if nargin < 7
    ea=ones(m,1);
end
if nargin < 6
    eb=zeros(m,1);
end

fLP_main = zeros(n,1);
FLP_main = zeros(n,T);
for t = 1:T
    ATemp               = A((t-1)*m/T+1:t*m/T,:);
    ebTemp              = eb((t-1)*m/T+1:t*m/T);
    eaTemp              = ea((t-1)*m/T+1:t*m/T);
    tau                 = r/2^(t-1)*randn(m/T,1);
    yTemp               = eaTemp.*sign(ATemp*(fLP_main-f)-tau+ebTemp);
    z                   = Delta_0(yTemp,ATemp,r/2^(t-1),tau);
    fLP_main            = hard_threshold(fLP_main-z,s);
    FLP_main(:,t)       = fLP_main;
end

end