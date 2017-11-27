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
N = 1000;                      	% size of x
s = 10;                         % sparsity of x
supp = sort(randsample(N,s));   % support of x
x = zeros(N,1);
x(supp) = randn(s,1);       	% entries of x on its support

% Generate dictionary
n = 900;                        % number of dictionary rows
DType = 'Rl';                   % dictionary type /in {ODFT}
D = DictionaryGenerator(n,N,DType);
f = D*x;
kapa = numel(find(abs(D'*f)>0.1))/s;
r = 2*norm(f);                % an (over)estimation of the magnitude of f

%%
% specify the random measurements to be used
m = 500;                      % number of measurements
A = randn(m,n);              % measurement matrix
%% CP
% fCP_main = CP_main(D,A,f,r,r);
% err_CP = norm(fCP_main-f)/norm(f);

%% Adaptive CP
T = 10; % number of batch
% fACP_main = ACP_main(D,A,f,r,r,T);

%% HT
HT_sigma = r;

HT_eps = 1;
HT_epsPrim = ((r*HT_sigma)/(2*(r^2+HT_sigma^2)))*HT_eps;
t_HT = ceil(16*((HT_epsPrim/8)^(-2))*kapa*(s+1));
fHT_main = HT_main(D,A,f,t_HT,r,x);
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
