clear;
close all;
clc;
tic;
%% signal parameter
n   = 2;        % signal dimension
s   = 2;        % sparsity
m   = 20;      % number of measurment
R   = 100;      % amplitude
%% Generating a s-sparse signal in R^n
x_temp              = zeros(n,1);
rp                  = randperm(n);
x_temp(rp(1:s))     = nthroot(R, n).*randn(s,1); 
r                   = norm(x_temp);
x0                  = [x_temp ; -1];
%% Gaussian sensing matrix and associated 1-bit sensing
N   = randn(m,n+1);
y   = theta(N*x0);
%% Gnomonic projection(GP)
z0  = x0./sqrt(r^2+1);
%% convex optimization cvx1
% z_l1 = cvx1(y,n,s,m,N);
%% BIHT 
z_biht  = BIHT(y,n,s,m,N);
%% Adaptive algorithm 1
step    = 1;
z_adpt  = adpt(x_temp,n,m,s,step,R);
err     = z_adpt-x_temp
%% IGP
x_biht  = z_biht.*(sqrt(r^2+1));
% x_l1    = z_l1.*(sqrt(r^2+1));
%%
toc