clear;
clc;
close all;
cvx_quiet true;
%%
% define the sparse vector x
N = 100;                      	% size of x
s = 10;                         % sparsity of x
supp = sort(randsample(N,s));   % support of x
x = zeros(N,1);
x(supp) = randn(s,1);       	% entries of x on its support

% Generate dictionary
n = 50;                        % number of dictionary rows
DType = 'Rl';                   % dictionary type /in {ODFT}
D = DictionaryGenerator(n,N,DType);
f = D*x;

r = 2*norm(f);                % an (over)estimation of the magnitude of f

%%
% specify the random measurements to be used
m = 50000;                      % number of measurements
A = randn(m,n);              % measurement matrix
%% CP
fCP_main = CP_main(D,A,f,r,r);
err_CP = norm(fCP_main-f)/norm(f);

%% Adaptive CP
T = 10; % number of batch
fACP_main = ACP_main(D,A,f,r,r,T);

%% HT
fHT_main = HT_main(D,A,f,r,r);
err_CP = norm(fHT_main-f)/norm(f);

%% Adaptive AHT
T = 10; % number of batch
fAHT_main = AHT_main(D,A,f,r,r,T);

%%

F = f.*ones(n,T+1);
err_ACP_Temp = fACP_main-F;
norm_err_ACP = zeros(1,T+1);
for i = 1:T+1
    norm_err_ACP(i) = norm(err_ACP_Temp(:,i));
end
norm_err_ACP = norm_err_ACP/norm(f);
norm_err_ACP(1) = err_CP;
disp(norm_err_ACP)
stem(norm_err_ACP)
