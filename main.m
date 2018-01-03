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
Max_itr_i = 100000;
Step_itr_i = 100;
Min_itr_i = 100;
it_number = floor((Max_itr_i-Min_itr_i)/Step_itr_i);
Error_CP = zeros(1,it_number);
Error_ACP = zeros(1,it_number);

for itr_i=Min_itr_i:Step_itr_i:Max_itr_i
%%
% define the sparse vector x
N = 1000;                      	% size of x
s = 10;                         % sparsity of x
supp = sort(randsample(N,s));   % support of x
x = zeros(N,1);
x(supp) = randn(s,1);       	% entries of x on its support

% Generate dictionary
n = 50;                        % number of dictionary rows
DType = 'Rl';                   % dictionary type /in {ODFT}
D = DictionaryGenerator(n,N,DType);
f = D*x;
kapa = numel(find(abs(D'*f)>0.1))/s;
r = 2*norm(f);                % an (over)estimation of the magnitude of f

%%
% specify the random measurements to be used
m = itr_i;                      % number of measurements
A = randn(m,n);              % measurement matrix
%% CP
fCP_main = CP_main(D,A,f,r,r);
err_CP = norm(fCP_main-f)/norm(f);

%% Adaptive CP
T = 10; % number of batch
fACP_main = ACP_main(D,A,f,r,r,T);


%% plot result
close all;
F = f.*ones(n,T+1);
err_ACP_Temp = fACP_main-F;
norm_err_ACP = zeros(1,T);
for i = 2:T+1
    norm_err_ACP(i-1) = norm(err_ACP_Temp(:,i));
end
norm_err_ACP = norm_err_ACP/norm(f);

Error_CP(itr_i/Step_itr_i) = err_CP;
Error_ACP(itr_i/Step_itr_i) = norm_err_ACP(end);
clc;
MPrc = (itr_i/Max_itr_i)*100;
fprintf('main pass percent: %f\n',MPrc)
end
%% plot result
close all;
hold on;
plot(10*log10(Error_CP),'.r','markersize',20);
plot(10*log10(Error_ACP),'.b','markersize',20)
legend('CP','ACP')
hold off;
