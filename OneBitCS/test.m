clear;
close all;
clc;
tic;
%% parameter
n = 2;
itr = 10;
w_cvx       = zeros(1,itr);
%%
for i = 1:itr
    g = normrnd(0,1,1,n);
    cvx_begin quiet;
    variable z_cvx(n);
    maximize g*z_cvx;
    subject to
    norm(z_cvx)     <= 100;
    cvx_end
    w_cvx(i)    = abs(g*z_cvx)./norm(g);
end
%%
for i = 1:itr
W_k(i) = sum(w_cvx(1:i))./length(w_cvx(1:i));
end
plot(W_k);
%%
n = toc;