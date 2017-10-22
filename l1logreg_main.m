function [xl1logreg_main,Xl1logreg_main] = l1logreg_main(x,A,s,R,T,e,b)

% x: the vector to be recovered
% A: the matrix whose rows give the measurements
% s: the sparsity of x
% R: an (over)estimation of the magnitude of the vector to be recovered
% T: the number of adaptive groups of measurements
% e: a vector prequantization measurement errors
% b: a vector of bit flips

% This is the implementation of the algorithm based on L_1-regularized logistic regression

[m,n] = size(A);
if nargin < 7
    b=ones(m,1);
end
if nargin < 6
    e=zeros(m,1);
end
lambda = 20;
tol = 1e-5;
NbIter = 2000;

xl1logreg_main = zeros(n,1);
Xl1logreg_main = zeros(n,T);
for t = 1:T
    At = A((t-1)*m/T+1:t*m/T,:);
    et = e((t-1)*m/T+1:t*m/T);
    bt = b((t-1)*m/T+1:t*m/T);
    tau = R/2^(t-1)*randn(m/T,1);
    yt = bt.*sign(At*(xl1logreg_main-x)-tau+et);
    if std(et)>0
        z = l1logreg_fista_tau_e((yt+1)/2,At,tau,std(et)*sqrt(3)/pi,lambda,tol,NbIter);
    else
        z = l1logreg_fista_tau_e((yt+1)/2,At,tau,.01,lambda,tol,NbIter);
    end
    xl1logreg_main = hard_threshold(xl1logreg_main-z,s);
    Xl1logreg_main(:,t) = xl1logreg_main;
end

end