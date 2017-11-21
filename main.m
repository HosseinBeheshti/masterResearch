clear;
clc;
close all;
%% CVX setup
if isunix
    cd('./cvx_linux');
    cvx_setup;
    cd ..
end
if ispc
    cd('./cvx_win');
    cvx_setup;
    cd ..
end
cvx_quiet true;
%%
% define the sparse vector x
N = 2;                      	% size of x
s = 1;                         % sparsity of x
supp = sort(randsample(N,s));   % support of x
x = zeros(N,1);
x(supp) = randn(s,1);       	% entries of x on its support

% Generate dictionary
n = 2;                        % number of dictionary rows
DType = 'Rl';                   % dictionary type /in {ODFT}
D = DictionaryGenerator(n,N,DType);
f = D*x;

r = 2*norm(f);                % an (over)estimation of the magnitude of f

%%
% specify the random measurements to be used
m = 100;                      % number of measurements
A = randn(m,n);              % measurement matrix
%% CP
fCP_main = CP_main(D,A,f,r,r);
err_CP = norm(fCP_main-f)/norm(f);

%% Adaptive CP
T = 10; % number of batch
fACP_main = ACP_main(D,A,f,r,r,T);

%% HT
t_HT = ceil((s+1));
fHT_main = HT_main(D,A,f,t_HT,r,r);
err_HT = norm(fHT_main-f)/norm(f);

%% Adaptive AHT
% T = 10; % number of batch
% fAHT_main = AHT_main(D,A,f,r,r,T);

%% plot result
close all;

F = f.*ones(n,T+1);
err_ACP_Temp = fACP_main-F;
norm_err_ACP = zeros(1,T);
for i = 2:T+1
    norm_err_ACP(i-1) = norm(err_ACP_Temp(:,i));
end
norm_err_ACP = norm_err_ACP/norm(f);

disp(norm_err_ACP)
hold all;
stem(err_CP.*ones(1,T));
stem(norm_err_ACP)
hold off;