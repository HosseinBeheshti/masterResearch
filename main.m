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
m = 100;                      % number of measurements
A = randn(m,n);              % measurement matrix 

%% LP main
DitherType = 'LP';
sigma = r;
tau = DitherGenerator(m,sigma,DitherType);

y = sign(A*f-tau);
fLP_main = LP_main(y,A,D,sigma,tau);
%% Adaptive LP




















