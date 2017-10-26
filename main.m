clear;
clc;
close all;

%%
% define the sparse vector x
N = 100;                      	% size of x
s = 3;                         % sparsity of x
supp = sort(randsample(N,s));   % support of x
x = zeros(N,1);
x(supp) = randn(s,1);       	% entries of x on its support

% Generate dictionary
n = 10;                        % number of dictionary rows
DType = 'Rl';                   % dictionary type /in {ODFT}
D = DictionaryGenerator(n,N,DType);
f = D*x;

r = 2*norm(f);                % an (over)estimation of the magnitude of f

%%
% specify the random measurements to be used
m = 100;                      % number of measurements
A = randn(m,n);              % measurement matrix

%% LP 
fLP_main = LP_main(D,A,f,r);
err_LP = norm(fLP_main-f)/norm(f);

%% CP
fCP_main = CP_main(D,A,f,r,r);
err_CP = norm(fCP_main-f)/norm(f);

%% Adaptive LP
T = 10; % number of batch

fALP_main = ALP_main(D,A,f,r,T);
%%
F = f.*ones(n,T+1);
err_ALP_Temp = fALP_main-F;
norm_err_ALP = zeros(1,T+1);
for i = 1:T+1
    norm_err_ALP(i) = norm(err_ALP_Temp(:,i));
end
norm_err_ALP = norm_err_ALP/norm(f);
norm_err_ALP(1) = err_LP;
disp(norm_err_ALP)
stem(norm_err_ALP)
