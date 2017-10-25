clear;
clc;                     % clear the workspace and the screen
%%
% define the sparse vector x
N = 10;                      	% size of x
s = 1;                         % sparsity of x
supp = sort(randsample(N,s));   % support of x
x = zeros(N,1);
x(supp) = randn(s,1);       	% entries of x on its support

% Generate dictionary
n = 2;                        % number of dictionary rows
DType = 'Rl';                   % dictionary type /in {ODFT}
D = DictionaryGenerator(n,N,DType);
f = D*x;

r = 1.5*norm(f);                % an (over)estimation of the magnitude of f

%%
% specify the random measurements to be used
m = 1000;                      % number of measurements
A = randn(m,n);              % measurement matrix

%% LP main
[fLP_main,h,u] = LP_main(D,A,f,r);

%% Adaptive LP
T = 10; % number of batch

% [fLP_main,h,u] = ALP_main(y,A,D,sigma,tau,T);
% 
% fALP = zeros(n,1);
% FALP = zeros(n,T);
% for t = 1:T
%     ATemp =
% end
