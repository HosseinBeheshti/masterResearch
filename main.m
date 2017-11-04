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
n = 30;                        % number of dictionary rows
DType = 'Rl';                   % dictionary type /in {ODFT}
D = DictionaryGenerator(n,N,DType);
f = D*x;

r = 2*norm(f);                % an (over)estimation of the magnitude of f

%%
% specify the random measurements to be used
m = 1000;                      % number of measurements
A = randn(m,n);              % measurement matrix
%% CP
fCP_main = CP_main(D,A,f,r,r);
err_CP = norm(fCP_main-f)/norm(f);

%% Adaptive CP
T = 10; % number of batch

fACP_main = ACP_main(D,A,f,r,r,T);

%%
for t = 1:T
    %% visiual adaptivity
    if n==2
        if t== 1
            hold on;
            plot(f(1),f(2),'.g','markersize',10);
        end
        pause(1);
        plot(fACP_main(1,t),fACP_main(2,t),'.b','markersize',10);
    end
    if t== T
        hold off;
    end
end
%%


F = f.*ones(n,T+1);
err_ALP_Temp = fACP_main-F;
norm_err_ALP = zeros(1,T+1);
for i = 1:T+1
    norm_err_ALP(i) = norm(err_ALP_Temp(:,i));
end
norm_err_ALP = norm_err_ALP/norm(f);
norm_err_ALP(1) = err_LP;
disp(norm_err_ALP)
stem(norm_err_ALP)
