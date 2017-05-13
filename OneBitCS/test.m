clear;
close all;
clc;
tic;
%% parameter
n = 2;
s = 2;
m = 100;
itr = 200;
Rmax    = 90; %upper bound for ||x||
Rmin    = 70; %lower bound for ||x||
%%
A       = normrnd(0,1,m,n);
tau     = normrnd(0,1,m,1);
w_cvx   = zeros(1,itr);
[x_org, trueNorm]   = signal_generator(n, s, 0, Rmin, Rmax);
y       = theta(A*x_org-tau);
for i = 1:itr
    g = normrnd(0,1,1,n);
    cvx_begin quiet;
    variable z_cvx(n);
    maximize g*z_cvx;
    subject to
    y.*(A*z_cvx-tau) >= 0;
    norm(z_cvx)     <= Rmax;
    cvx_end
    w_cvx(i)    = abs(g*z_cvx)./norm(g);
end
%%
for i = 1:itr
    W_k(i) = sum(w_cvx(1:i))./length(w_cvx(1:i));
end
plot(W_k);
%%
n = toc