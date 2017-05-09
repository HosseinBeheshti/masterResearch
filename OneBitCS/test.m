clear;
close all;
clc;
tic;
%% parameter
n = 2;
m = 10;
itr = 10;

%%

        A       = normrnd(0,1,m,n);
        Phi     = normrnd(0,1,n,m);
        tau     = A*Phi;

        g = normrnd(0,1,1,n);
    cvx_begin quiet;
    variable z_cvx(n);
    maximize g*z_cvx;
    subject to
    norm(z_cvx)     <= 100;
    cvx_end
    w_cvx    = abs(g*z_cvx)./norm(g);

%%
for i = 1:itr
W_k(i) = sum(w_cvx(1:i))./length(w_cvx(1:i));
end
plot(W_k);
%%
n = toc;