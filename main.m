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
        m = (T_it_number-1)*Step_m+Min_m;                      % number of measurements
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
        
        Error_CP(itr_i) = err_CP;
        
        Error_ACP(itr_i) = norm_err_ACP(end);
        clc;
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
    Error_CP_T = Error_CP_T+   Error_CP;
    Error_ACP_T = Error_ACP_T+   Error_ACP;
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

