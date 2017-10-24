clear;
clc;                     % clear the workspace and the screen 
%%
% define the sparse vector x 
N = 100;                      	% size of x
s = 10;                         % sparsity of x
supp = sort(randsample(N,s));   % support of x 
x = zeros(N,1); 
x(supp) = randn(s,1);       	% entries of x on its support

% Generate dictionary
n = 10;                        % number of dictionary rows
DType = 'Rl';                   % dictionary type /in {ODFT}
D = DictionaryGen(n,N,DType);
f = D*x;

r = 1.5*norm(f);                % an (over)estimation of the magnitude of f

%%
% specify the random measurements to be used
m = 10000;                      % number of measurements
A = randn(m,n);                 % matrix whose rows give the measurements

T = 8;                    % number of adaptive groups of measurements
fLP_main = LP_main(x,A,s,r,T);






















