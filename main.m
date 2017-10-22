%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This file contains the reproducible experiments mentioned in the article
% Adaptive dictionary-sparse signal
% by Baraniuk, Foucart, Needell, Plan, and Wooters
% Created 12 Feb 2014
% Last modified 29 July 2014
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% To run the script, make sure that CVX is installed and set up correctly 
cvx_setup    
% the command only works if you are in the directory containing cvx
% return to the directory "reproducibles" afterwards

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %%
%%%%%                         Experiment 1                          %%%%%
% Verification that the auxiliary and main algorithms work as intended %% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear; clc;                     % clear the workspace and the screen 
cvx_quiet true                  % turn off the messages delivered to the screen 

% define the sparse vector x to be recovered
n = 100;                        % size of x
s = 10;                         % sparsity of x
supp = sort(randsample(n,s));   % support of x 
x = zeros(n,1); 
x(supp) = randn(s,1);           % entries of x on its support
R = 1.5*norm(x);                % an (over)estimation of the magnitude of x

% specify the random measurements to be used
m = 10000;                      % number of measurements
A = randn(m,n);                 % matrix whose rows give the measurements

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% testing classical minimization algorithms

% recovery via the linear program of Plan-Vershynin
y = sign(A*x);
xLP = LP(y,A);

% recovery via the convex program of Plan-Vershynin
y = sign(A*x);
xCP = CP(y,A,s);

% recovery via L1-regularized logistic regression
y = sign(A*x);
lambda = 20;
tol = 1e-5;
NbIter = 2000;
xLR = l1logreg_fista((y+1)/2,A,lambda,tol,NbIter);

% recovery via binary iterative hard thresholding
y = sign(A*x);
NbIter = 2000;
xBIHT = BIHT(y,A,s,NbIter);

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% testing the auxiliary algorithms

% recovery via the hard-thresholding-based order-one scheme
% this (deterministic) scheme needs to make two rounds of measurements:
% the second round of measurements depend on the outcome of the first round
A1 = A(1:m/2,:);                       % the measurements for the first round
y1 = sign(A1*x);                       % the first-round quantized measurements 
[u,v,w] = HT_Order1_round1(y1,A1,s,R); % vectors determining the next round
A2 = A(m/2+1:m,:);                     % the measurements for the second round
y2 = sign(A2*(w-x));                   % the second-round quantized measurements
xHT_Order1 = HT_Order1_round2(y2,A2,s,R,u,v,w); % the output of the scheme

% recovery via the second-order-cone-programming-based order-one scheme
% this scheme involves random thresholds                        
tau = R*randn(m,1);                          % the vector of random thresholds
y = sign(A*x-tau);                           % the quantized measurements
xSOCP_Order1 = SOCP_Order1(y,A,R,tau);       % the output of the scheme

% recovery via L1-regularized logistic regression with known dithers
% this scheme involves random thresholds
lambda = 20;
tol = 1e-5;
NbIter = 2000;
xLR_t = l1logreg_fista_tau((y+1)/2,A,tau,lambda,tol,NbIter);


% all auxiliary algorithms should estimate the direction of x relatively well,
% as the following screen messages should reveal
x_nzed = x/norm(x);
xLP_nzed = xLP/norm(xLP);
xCP_nzed = xCP/norm(xCP);
xLR_nzed = xLR/norm(xLR);
xBIHT_nzed = xBIHT/norm(xBIHT);
xHT_Order1_nzed = xHT_Order1/norm(xHT_Order1);
xSOCP_Order1_nzed = xSOCP_Order1/norm(xSOCP_Order1);
xLR_t_nzed = xLR_t/norm(xLR_t);
fprintf('the error between the normalized x and \n')
fprintf('  the normalized output of the linear program is: %f\n',...
    norm(x_nzed-xLP_nzed))
fprintf('  the normalized output of the convex program is: %f\n',...
    norm(x_nzed-xCP_nzed))
fprintf('  the normalized output of the regularized logistic regression is: %f\n',...
    norm(x_nzed-xLR_nzed))
fprintf('  the normalized output of the binary IHT algorithm is: %f\n',...
    norm(x_nzed-xBIHT_nzed))
fprintf('  the normalized output of the hard-thesholding-based order-one scheme is: %f\n',...
    norm(x_nzed-xHT_Order1_nzed))
fprintf('  the normalized output of the second-order-cone-programming-based order-one scheme is: %f\n',...
    norm(x_nzed-xSOCP_Order1_nzed))
fprintf('  the normalized output of the regularized logistic regression with dithers is: %f\n',...
    norm(x_nzed-xLR_t_nzed))

% but only the order-one schemes should estimate both direction and magnitude well
% as the following screen messages should reveal
fprintf('the relative error between x and \n')
fprintf('  the output of the linear program is: %f\n',...
    norm(x-xLP)/norm(x))
fprintf('  the output of the convex program is: %f\n',...
    norm(x-xCP)/norm(x))
fprintf('  the output of the regularized logistic regression is: %f\n',...
    norm(x-xLR)/norm(x))
fprintf('  the output of the binary IHT algorithm is: %f\n',...
    norm(x-xBIHT)/norm(x))
fprintf('  the output of the hard-thresholding-based order-one scheme is: %f\n', ...
    norm(x-xHT_Order1)/norm(x))
fprintf('  the output of the second-order-cone-programming-based order-one scheme is: %f\n', ...
    norm(x-xSOCP_Order1)/norm(x))
fprintf('  the output of the regularized logistic regression with dithers is: %f\n', ...
    norm(x-xLR_t)/norm(x))


% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% testing the main iterative algorithms
T = 8;                    % number of adaptive groups of measurements

% recovery via the hard-threshold-based version of the main algorithm
xHT_main = HT_main(x,A,s,R,T);

% recovery via the second-order-cone-programming-based version of the main algorithm
xSOCP_main = SOCP_main(x,A,s,R,T);

% recovery via the regularized-logistic-regression-based version of the main algorithm
xLR_main = l1logreg_main(x,A,s,R,T);

% the main algorithm offers significant improvements over classical methods 
% as the following screen messages should reveal
fprintf('for comparison, the relative error between x and \n')
fprintf('  the output of the hard-thresholding-based main algorithm is: %f\n',...
    norm(x-xHT_main)/norm(x))
fprintf('  the output of the second-order-cone-programming-based main algorithm is: %f\n',...
    norm(x-xSOCP_main)/norm(x))
fprintf('  the output of the regularized-logistic-regression-based main algorithm is: %f\n',...
    norm(x-xLR_main)/norm(x))

save('Exp1.mat')


    
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %%
%%%%%                    Experiment 2                  %%%%%
% Verification of the exponential decay for the error rate %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Exp 2a: the algorithm based on hard thresholding
% the code produces recovery errors as the number of measurements increases

clear all; clc;     % clear the workspace and the screen 

n_2a = 100;         % size of the vectors to be recovered
T_2a = 6;           % number of adaptive groups of measurements
NbTests_2a = 500;   % number of vectors on which the algorithm is tested

% test for a first sparsity level
s1_2a = 10;                             % the sparsity level
mmin_s1_2a = 2000*s1_2a*T_2a;           % initial number of msmts
mmax_s1_2a = 20000*s1_2a*T_2a;          % final number of msmts
deltam_s1_2a = 2000*s1_2a*T_2a;         % increment in the number of msmts
M_s1_2a = mmin_s1_2a:deltam_s1_2a:mmax_s1_2a;     % all numbers of msmts used 
errors_s1_2a = ones(NbTests_2a,size(M_s1_2a,2));  % table of errors
tic;
for k = 1:NbTests_2a
    supp = sort(randsample(n_2a,s1_2a));
    x = zeros(n_2a,1); 
    x(supp) = randn(s1_2a,1);
    R = 1.5*norm(x);
    A=randn(mmax_s1_2a,n_2a);
    for l = 1:size(M_s1_2a,2)
        m = M_s1_2a(l);
        errors_s1_2a(k,l) = norm(x-HT_main(x,A(1:m,:),s1_2a,R,T_2a))/norm(x);
    end
end
t_s1_2a = toc

% test for a second sparsity level
s2_2a = 15;                             % the sparsity level
mmin_s2_2a = 2000*s2_2a*T_2a;           % initial number of msmts
mmax_s2_2a = 20000*s2_2a*T_2a;          % final number of msmts
deltam_s2_2a = 2000*s2_2a*T_2a;         % increament in the number of msmts
M_s2_2a = mmin_s2_2a:deltam_s2_2a:mmax_s2_2a;     % all numbers of msmts used 
errors_s2_2a = ones(NbTests_2a,size(M_s2_2a,2));  % table of errors
tic;
for k = 1:NbTests_2a
    supp = sort(randsample(n_2a,s2_2a));
    x = zeros(n_2a,1); 
    x(supp) = randn(s2_2a,1);
    R = 1.5*norm(x);
    A=randn(mmax_s2_2a,n_2a);
    for l = 1:size(M_s2_2a,2)
        m = M_s2_2a(l);
        errors_s2_2a(k,l) = norm(x-HT_main(x,A(1:m,:),s2_2a,R,T_2a))/norm(x);
    end
end
t_s2_2a = toc

% test for a third sparsity level
s3_2a = 20;                             % the sparsity level
mmin_s3_2a = 2000*s3_2a*T_2a;           % initial number of msmts
mmax_s3_2a = 20000*s3_2a*T_2a;          % final number of msmts
deltam_s3_2a = 2000*s3_2a*T_2a;         % increment in the number of msmts
M_s3_2a = mmin_s3_2a:deltam_s3_2a:mmax_s3_2a;     % all numbers of msmts used 
errors_s3_2a = ones(NbTests_2a,size(M_s3_2a,2));  % table of errors
tic;
for k = 1:NbTests_2a
    supp = sort(randsample(n_2a,s3_2a));
    x = zeros(n_2a,1); 
    x(supp) = randn(s3_2a,1);
    R = 1.5*norm(x);
    A=randn(mmax_s3_2a,n_2a);
    for l = 1:size(M_s3_2a,2)
        m = M_s3_2a(l);
        errors_s3_2a(k,l) = norm(x-HT_main(x,A(1:m,:),s3_2a,R,T_2a))/norm(x);
    end
end
t_s3_2a = toc

% test for a fourth sparsity level
s4_2a = 25;                             % the sparsity level
mmin_s4_2a = 2000*s4_2a*T_2a;           % initial number of msmts
mmax_s4_2a = 20000*s4_2a*T_2a;          % final number of msmts
deltam_s4_2a = 2000*s4_2a*T_2a;         % increment in the number of msmts
M_s4_2a = mmin_s4_2a:deltam_s4_2a:mmax_s4_2a;     % all numbers of msmts used 
errors_s4_2a = ones(NbTests_2a,size(M_s4_2a,2));  % table of errors
tic;
for k = 1:NbTests_2a
    supp = sort(randsample(n_2a,s4_2a));
    x = zeros(n_2a,1); 
    x(supp) = randn(s4_2a,1);
    R = 1.5*norm(x);
    A=randn(mmax_s4_2a,n_2a);
    for l = 1:size(M_s4_2a,2)
        m = M_s4_2a(l);
        errors_s4_2a(k,l) = norm(x-HT_main(x,A(1:m,:),s4_2a,R,T_2a))/norm(x);
    end
end
t_s4_2a = toc

save('Exp2a.mat')


%% Exp 2b: the algorithm based on second-order cone programming
% the code produces recovery errors as the number of measurements increases
% note that the problem scale is much lower

clear all; clc;  % clear the workspace and the screen 
cvx_quiet true   % turn off the messages delivered to the screen

n_2b = 100;        % size of the vectors to be recovered
T_2b = 5;          % number of adaptive groups of measurements
NbTests_2b = 100;  % number of vectors on which the algorithm is tested

% test for a first sparsity level
s1_2b = 10;                             % the sparsity level
mmin_s1_2b = 20*s1_2b*T_2b;             % initial number of msmts
mmax_s1_2b = 200*s1_2b*T_2b;            % final number of msmts
deltam_s1_2b = 20*s1_2b*T_2b;           % increment in the number of msmts
M_s1_2b = mmin_s1_2b:deltam_s1_2b:mmax_s1_2b;    % all numbers of msmts used 
errors_s1_2b = ones(NbTests_2b,size(M_s1_2b,2)); % table of errors
tic;
for k = 1:NbTests_2b
    supp = sort(randsample(n_2b,s1_2b));
    x = zeros(n_2b,1); 
    x(supp) = randn(s1_2b,1);
    R = 1.5*norm(x);
    A=randn(mmax_s1_2b,n_2b);
    for l = 1:size(M_s1_2b,2)
        m = M_s1_2b(l);
        errors_s1_2b(k,l) = norm(x-SOCP_main(x,A(1:m,:),s1_2b,R,T_2b))/norm(x);
    end
end
t_s1_2b = toc
 
% test for a second sparsity level
s2_2b = 15;                             % the sparsity level
mmin_s2_2b = 20*s2_2b*T_2b;             % initial number of msmts
mmax_s2_2b = 200*s2_2b*T_2b;            % final number of msmts
deltam_s2_2b = 20*s2_2b*T_2b;           % increment in the number of msmts
M_s2_2b = mmin_s2_2b:deltam_s2_2b:mmax_s2_2b;    % all numbers of msmts used 
errors_s2_2b = ones(NbTests_2b,size(M_s2_2b,2)); % table of errors
tic;
for k = 1:NbTests_2b
    supp = sort(randsample(n_2b,s2_2b));
    x = zeros(n_2b,1); 
    x(supp) = randn(s2_2b,1);
    R = 1.5*norm(x);
    A=randn(mmax_s2_2b,n_2b);
    for l = 1:size(M_s2_2b,2)
        m = M_s2_2b(l);
        errors_s2_2b(k,l) = norm(x-SOCP_main(x,A(1:m,:),s2_2b,R,T_2b))/norm(x);
    end
end
t_s2_2b = toc

% test for a third sparsity level
s3_2b = 20;                             % the sparsity level
mmin_s3_2b = 20*s3_2b*T_2b;             % initial number of msmts
mmax_s3_2b = 200*s3_2b*T_2b;            % final number of msmts
deltam_s3_2b = 20*s3_2b*T_2b;           % increment in the number of msmts
M_s3_2b = mmin_s3_2b:deltam_s3_2b:mmax_s3_2b;    % all numbers of msmts used 
errors_s3_2b = ones(NbTests_2b,size(M_s3_2b,2)); % table of errors
tic;
for k = 1:NbTests_2b
    supp = sort(randsample(n_2b,s3_2b));
    x = zeros(n_2b,1); 
    x(supp) = randn(s3_2b,1);
    R = 1.5*norm(x);
    A=randn(mmax_s3_2b,n_2b);
    for l = 1:size(M_s3_2b,2)
        m = M_s3_2b(l);
        errors_s3_2b(k,l) = norm(x-SOCP_main(x,A(1:m,:),s3_2b,R,T_2b))/norm(x);
    end
end
t_s3_2b = toc

% test for a fourth sparsity level
s4_2b = 25;                             % the sparsity level
mmin_s4_2b = 20*s4_2b*T_2b;             % initial number of msmts
mmax_s4_2b = 200*s4_2b*T_2b;            % final number of msmts
deltam_s4_2b = 20*s4_2b*T_2b;           % increment in the number of msmts
M_s4_2b = mmin_s4_2b:deltam_s4_2b:mmax_s4_2b;    % all numbers of msmts used 
errors_s4_2b = ones(NbTests_2b,size(M_s4_2b,2)); % table of errors
tic;
for k = 1:NbTests_2b
    supp = sort(randsample(n_2b,s4_2b));
    x = zeros(n_2b,1); 
    x(supp) = randn(s4_2b,1);
    R = 1.5*norm(x);
    A=randn(mmax_s4_2b,n_2b);
    for l = 1:size(M_s4_2b,2)
        m = M_s4_2b(l);
        errors_s4_2b(k,l) = norm(x-SOCP_main(x,A(1:m,:),s4_2b,R,T_2b))/norm(x);
    end
end
t_s4_2b = toc

save('Exp2b.mat')


%% Experiment 2
% Visualization of the results

try load('Exp2a.mat')
catch
    load('Exp2a_default.mat')
end

% define the oversampling ratio corresponding each sparsity level
lambda_s1_2a = M_s1_2a/(s1_2a*log(n_2a/s1_2a));
lambda_s2_2a = M_s2_2a/(s2_2a*log(n_2a/s2_2a));
lambda_s3_2a = M_s3_2a/(s3_2a*log(n_2a/s4_2a));
lambda_s4_2a = M_s4_2a/(s4_2a*log(n_2a/s4_2a));

figure(1)
set(gca,'fontsize',30)
semilogy(lambda_s1_2a,mean(errors_s1_2a),'x-k', ...
         lambda_s2_2a,mean(errors_s2_2a),'s--g', ...
         lambda_s3_2a,mean(errors_s3_2a),'o:r', ...
         lambda_s4_2a,mean(errors_s4_2a),'d-.b', 'LineWidth', 4)
legend({strcat('s=',num2str(s1_2a)),...
       strcat('s=',num2str(s2_2a)),...
       strcat('s=',num2str(s3_2a)),... 
       strcat('s=',num2str(s4_2a))}, 'FontSize', 22)
xlabel('m/(s log(n/s))', 'FontSize', 30)
ylabel('||x-x*|| / ||x||', 'FontSize', 30)
str(1) = {strcat( num2str(NbTests_2a), ' hard-thresholding-based tests' )};
str(2) = {strcat( 'n=', num2str(n_2a), ...
    ', m/s=2000:2000:20000', ', T= ', num2str(T_2a), ...
    ' (', num2str(round((t_s1_2a+t_s2_2a+t_s3_2a+t_s4_2a)/3600)), ' hours)' )};
title(str, 'FontSize', 16)

try load('Exp2b.mat')
catch
    load('Exp2b_default.mat')
end

% define the oversampling ratio corresponding each sparsity level
lambda_s1_2b = M_s1_2b/(s1_2b*log(n_2b/s1_2b));
lambda_s2_2b = M_s2_2b/(s2_2b*log(n_2b/s2_2b));
lambda_s3_2b = M_s3_2b/(s3_2b*log(n_2b/s4_2b));
lambda_s4_2b = M_s4_2b/(s4_2b*log(n_2b/s4_2b));

figure(2)
set(gca,'fontsize',30)
semilogy(lambda_s1_2b,mean(errors_s1_2b),'x-k', ...
         lambda_s2_2b,mean(errors_s2_2b),'s--g', ...
         lambda_s3_2b,mean(errors_s3_2b),'o:r', ...
         lambda_s4_2b,mean(errors_s4_2b),'d-.b', 'LineWidth', 4)
legend({strcat('s=',num2str(s1_2b)),...
       strcat('s=',num2str(s2_2b)),...
       strcat('s=',num2str(s3_2b)),... 
       strcat('s=',num2str(s4_2b))}, 'FontSize', 22)
xlabel('m/(s log(n/s))', 'FontSize', 30)
ylabel('||x-x*|| / ||x||', 'FontSize', 30)
str(1) = {strcat( num2str(NbTests_2b), ' second-order-cone-programming-based tests' )};
str(2) = {strcat( 'n=', num2str(n_2b), ...
    ', m/s=20:20:200', ', T= ', num2str(T_2b), ...
    ' (', num2str(round((t_s1_2b+t_s2_2b+t_s3_2b+t_s4_2b)/3600)), ' hours)' )};
title(str, 'FontSize', 16)

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %%
%%%%%                 Experiment 3                %%%%%
% Verification of the robustness to measurement error %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Exp 3a: the main algorithm based on hard thresholding
% the code produces recovery errors as the iteration count increases
% in the perfect situation, with prequantization noise, and with bit flips

clear all; clc;  % clear the workspace and the screen 

n_3a = 100;         % size of the vectors to be recovered
s_3a = 15;          % sparsity of the vectors to be recovered
m_3a = 100000;      % number of measurements
T_3a = 10;          % number of adaptive groups of measurements
noise_3a = 1e-1;    % standard deviation of the prequantization noise
flips_3a = 1/20;    % fraction of bits that are flipped
NbTests_3a = 1000;  % number of vectors on which the algorithm is tested

errors_exact_3a = zeros(NbTests_3a,T_3a);  % table of errors 
errors_noise_3a = zeros(NbTests_3a,T_3a);  % table of errors with noise
errors_flips_3a = zeros(NbTests_3a,T_3a);  % table of errors with bit flips
tic;
for k = 1:NbTests_3a
    supp = sort(randsample(n_3a,s_3a));
    x = zeros(n_3a,1); 
    x(supp) = randn(s_3a,1);
    R = 1.5*norm(x);
    A = randn(m_3a,n_3a);
    [~,XHT_main] = HT_main(x,A,s_3a,R,T_3a);   
    for t = 1:T_3a
        errors_exact_3a(k,t) = norm(x-XHT_main(:,t))/norm(x);
    end
    e = noise_3a*randn(m_3a,1);
    [~,XHT_main] = HT_main(x,A,s_3a,R,T_3a,e);
    for t = 1:T_3a
        errors_noise_3a(k,t) = norm(x-XHT_main(:,t))/norm(x);
    end;
    b = ones(m_3a,1); 
    b(randsample(m_3a,m_3a*flips_3a)) = -ones(m_3a*flips_3a,1);
    [~,XHT_main] = HT_main(x,A,s_3a,R,T_3a,zeros(m_3a,1),b);
    for t = 1:T_3a
        errors_flips_3a(k,t) = norm(x-XHT_main(:,t))/norm(x); 
    end
end
t_3a = toc

save('Exp3a.mat')


%% Exp 3b: the main algorithm based on second-order cone programming
% and, for comparison, on L_1-regularized logistic regression
% the code produces recovery errors as the iteration count increases
% the problem scale is much lower and bit flips are not handled

clear all; clc;  % clear the workspace and the screen 
cvx_quiet true   % turn off the messages delivered to the screen

n_3b = 100;        % size of the vectors to be recovered
s_3b = 10;         % sparsity of the vectors to be recovered
m_3b = 20000;      % number of measurements
T_3b = 5;          % number of adaptive groups of measurements
noise_3b = 5e-3;   % standard deviation of the prequantization noise
NbTests_3b = 1000; % number of vectors on which the algorithm is tested

errors_exact_3b = zeros(NbTests_3b,T_3b);     % table of errors 
errors_noise_3b = zeros(NbTests_3b,T_3b);     % table of errors with noise
errors_noise_3b_LR = zeros(NbTests_3b,T_3b);  % table of errors with noise
tic;
for k = 1:NbTests_3b
    supp = sort(randsample(n_3b,s_3b));
    x = zeros(n_3b,1); 
    x(supp) = randn(s_3b,1);
    R = 1.5*norm(x);
    A = randn(m_3b,n_3b);
    [~,XSOCP_main] = SOCP_main(x,A,s_3b,R,T_3b);   
    for t = 1:T_3b
        errors_exact_3b(k,t) = norm(x-XSOCP_main(:,t))/norm(x);
    end
    e = noise_3b*randn(m_3b,1);
    [~,XSOCP_main] = SOCP_main(x,A,s_3b,R,T_3b,e);
    [~,XLR_main] = l1logreg_main(x,A,s_3b,R,T_3b,e);
    for t = 1:T_3b
        errors_noise_3b(k,t) = norm(x-XSOCP_main(:,t))/norm(x);
        errors_noise_3b_LR(k,t) = norm(x-XLR_main(:,t))/norm(x);
    end;
end
t_3b = toc

save('Exp3b.mat')


%% Experiment 3
% Visualization of the results

try load('Exp3a.mat')
catch
    load('Exp3a_default.mat')
end

figure(3)
set(gca,'fontsize',30)
plot(3:T_3a,mean(errors_exact_3a(:,3:T_3a)),'x-k',...
     3:T_3a,mean(errors_noise_3a(:,3:T_3a)),'s--g',...
     3:T_3a,mean(errors_flips_3a(:,3:T_3a)),'o:r', 'LineWidth', 4)
legend({'perfect one-bit measurements',...
    strcat('pre-quantization noise (st. dev.= ', num2str(noise_3a), ')'),...
    strcat('bit flips (', num2str(flips_3a*100), '%)')}, 'FontSize', 22)
xlabel('t', 'FontSize', 30)
ylabel('||x-x*|| / ||x||', 'FontSize', 30)
str(1) = {strcat( num2str(NbTests_3a), ' hard-thresholding-based tests' )};
str(2) = {strcat( 'n=', num2str(n_3a), ', s=', num2str(s_3a), ...
    ', m=', num2str(m_3a), ', T= ', num2str(T_3a), ...
    ' (', num2str(round(t_3a/60)), ' minutes)' )};
title(str, 'FontSize', 16)


try load('Exp3b.mat')
catch
    load('Exp3b_default.mat')
end

figure(4)
set(gca,'fontsize',30)
plot(1:T_3b,mean(errors_exact_3b(:,1:T_3b)),'x-k',...
     1:T_3b,mean(errors_noise_3b(:,1:T_3b)),'s--g',...
     1:T_3b,mean(errors_noise_3b_LR(:,1:T_3b)),'o:b', 'LineWidth', 4)
legend({'perfect one-bit measurements',...
    strcat('pre-quantization noise (st. dev.= ', num2str(noise_3b), ')'),...
    vertcat('with same pre-quantization noise,', 'regularized logistic regression  ')},...
    'FontSize', 22)
xlabel('t', 'FontSize', 30)
ylabel('||x-x*|| / ||x||', 'FontSize', 30)
str(1) = {strcat( num2str(NbTests_3b), ' second-order-cone-programming-based tests' )};
str(2) = {strcat( 'n=', num2str(n_3b), ', s=', num2str(s_3b), ...
    ', m=', num2str(m_3b), ', T= ', num2str(T_3b), ...
    ' (', num2str(round(t_3b/3600)), ' hours)' )};
title(str, 'FontSize', 16)

%%

