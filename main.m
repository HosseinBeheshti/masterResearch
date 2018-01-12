clear;
clc;
close all;
tic;
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
%% monte carlo
BaseName = 'TempFile_';
max_mcr = 10;
for mcr =1:max_mcr
    Max_m = 50000;
    Step_m = 100;
    Min_m = 100;
    T_it_number = floor((Max_m-Min_m)/Step_m);
    Error_CP = zeros(1,T_it_number);
    Error_ACP = zeros(1,T_it_number);
    
    parfor itr_i=1:T_it_number
        %% Generate signal
        % define the sparse vector x
        N = 1000;                      	% size of x
        s = 10;                         % sparsity of x
        supp = sort(randsample(N,s));   % support of x
        x = zeros(N,1);
        x(supp) = randn(s,1);       	% entries of x on its support
        
        % Generate dictionary
        n = 50;                         % number of dictionary rows
        D = DictionaryGenerator(n,N);
        f = D*x;
        r = 2*norm(f);                    % an (over)estimation of the magnitude of f
        
        % specify the random measurements to be used
        m = (itr_i-1)*Step_m+Min_m;     % number of measurements
        A = randn(m,n);                 % measurement matrix
        
        %% CP
        fCP_main = CP_main(D,A,f,r,r);
        
        %% Adaptive CP
        T = 10; % number of batch
        fACP_main = ACP_main(D,A,f,r,T);
 
        %% Compute error
        err_CP = norm(fCP_main-f)/norm(f);
        err_ACP = norm(fACP_main(:,end)-f)/norm(f);
              
        Error_CP(itr_i) = err_CP;
        Error_ACP(itr_i) = err_ACP;
        
        fprintf('monte carlo iteration: %d\n',mcr)
        fprintf('main iteration: %d\n',itr_i)
    end
    
    FileName=[BaseName,num2str(mcr)];
    save(FileName)
end

%% load data for average
Error_CP_T = zeros(1,length(Error_CP));
Error_ACP_T = zeros(1,length(Error_ACP));
for mcr =1:max_mcr
    FileName=[BaseName,num2str(mcr)];
    load(FileName)
    Error_CP_T = Error_CP_T+Error_CP;
    Error_ACP_T = Error_ACP_T+Error_ACP;
end
Error_CP_T = Error_CP_T./max_mcr;
Error_ACP_T = Error_ACP_T./max_mcr;
save('MySimulation')

%% plot result
close all;
hold on;
plot(((0:(T_it_number-1))*Step_m+Min_m),10*log10(Error_CP_T),'r');
plot(((0:(T_it_number-1))*Step_m+Min_m),10*log10(Error_ACP_T),'b')
legend('CP','ACP')
ylabel('Reconstruction Error (dB)')
xlabel('measurment')
hold off;
toc
