clear;
clc;
close all;
%%
N = 1000; % size of x
n = 2; % number of dictionary rows
T = 20; % number of batch
s = 2;
m = 10000;
%% Generate signal
% define the sparse vector x
supp = sort(randsample(N, s));
x = zeros(N, 1);
x(supp) = randn(s, 1);
% Generate dictionary
D = DictionaryGenerator(n, N);
f = D * x;
r = 2 * norm(f);
% specify the random measurements to be used
A = randn(m, n);
%% CP
fCP_main = CP_main(D, A, f, r, r);
%% Adaptive CP
fACP_main = ACP_main(D, A, f, r, T);