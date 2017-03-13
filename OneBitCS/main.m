clear;
close all;
clc;
tic;
%% signal parameter
n   = 2;     % signal dimension
s   = 2;       % sparsity
m   = 10;       % number of measurment
%% Generating a s-sparse signal in R^n
x_temp = zeros(n,1);
rp = randperm(n);
x_temp(rp(1:s)) = randn(s,1); 
r = norm(x_temp);
x0 = [x_temp ; -1];
%% Gaussian sensing matrix and associated 1-bit sensing
N = randn(m,n+1);
y = theta(N*x0);
%% Gnomonic projection(GP)
z0 = x0./sqrt(r^2+1);
%% convex optimization cvx1
z_l1 = cvx1(y,n,s,m,N);
%% BIHT 
z_biht = BIHT(y,n,s,m,N);
%% Adaptive algorithm 1
step    = 1;
z_adpt = adpt(x_temp,n,m,step);
%% IGP
x_biht = z_biht.*(sqrt(r^2+1));
x_l1    = z_l1.*(sqrt(r^2+1));

%% plot result
close all;
hold on;
plot(x0);
plot(x_l1);
plot(x_biht);
hold off;
legend('x0','x_l1','x_biht');
figure;
plot(x_l1-x0);
plot(x_biht-x0);

%%
toc