clear;
clc;
close all;
tic;
%% monte carlo
max_mcr = 200;
%% number of measurements
Max_m = 40000;
Step_m = 1000;
Min_m = 500;
T_it_number = floor((Max_m-Min_m)/Step_m)+1;
%% allocate vectors
Error_LP = zeros(1,T_it_number);
Error_CP = zeros(1,T_it_number);
Error_ACP = zeros(1,T_it_number);
time_LP = zeros(1,T_it_number);
time_CP = zeros(1,T_it_number);
time_ACP = zeros(1,T_it_number);
%% file name
TempName = 'TempFile_';
SimFileName = 'SimResult';
%% signal properties
N = 1000; % size of x
n = 50; % number of dictionary rows
T = 10; % number of batch
s = [5 10 20]';
for sparsity_irt = 1:length(s)
    %%
    notif = ['start simulation with sparsity: ',num2str(s(sparsity_irt))];
    disp(notif);
    for mcr = 1:max_mcr
        fprintf('\n monte carlo : %d\n',mcr)
        fprintf('measuerment :');
        parfor itr_i=1:T_it_number
            %% Generate signal
            % define the sparse vector x
            supp = sort(randsample(N,s(sparsity_irt)));
            x = zeros(N,1);
            x(supp) = randn(s(sparsity_irt),1);
            % Generate dictionary
            D = DictionaryGenerator(n,N);
            f = D*x;
            r = 2*norm(f);
            % specify the random measurements to be used
            m = (itr_i-1)*Step_m+Min_m;
            A = randn(m,n);
            %% LP
            tic;
            fLP_main = LP_main(D,A,f,r);
            time_LP(itr_i) = toc;
            %% CP
            tic;
            fCP_main = CP_main(D,A,f,r,r);
            time_LP(itr_i) = toc;
            %% Adaptive CP
            tic;
            fACP_main = ACP_main(D,A,f,r,T);
            time_LP(itr_i) = toc;
            %% Compute error
            err_LP = norm(fLP_main-f)/norm(f);
            err_CP = norm(fCP_main-f)/norm(f);
            err_ACP = norm(fACP_main(:,end)-f)/norm(f);
            Error_LP(itr_i) = err_LP;
            Error_CP(itr_i) = err_CP;
            Error_ACP(itr_i) = err_ACP;
            fprintf(' %d ',itr_i)
        end
        FileName=[TempName,num2str(mcr)];
        save(FileName)
    end
    %% Compute data average
    Error_LP_T = zeros(1,length(Error_LP));
    Error_CP_T = zeros(1,length(Error_CP));
    Error_ACP_T = zeros(1,length(Error_ACP));
    time_LP_T = zeros(1,length(Error_LP));
    time_CP_T = zeros(1,length(Error_CP));
    time_ACP_T = zeros(1,length(Error_ACP));
    for mcr =1:max_mcr
        FileName=[TempName,num2str(mcr)];
        load(FileName)
        Error_LP_T = Error_LP_T+Error_LP;
        Error_CP_T = Error_CP_T+Error_CP;
        Error_ACP_T = Error_ACP_T+Error_ACP;
        time_LP_T = time_LP_T+Error_LP;
        time_CP_T = time_CP_T+Error_CP;
        time_ACP_T = time_ACP_T+Error_ACP;
    end
    Error_LP_T = Error_LP_T./max_mcr;
    Error_CP_T = Error_CP_T./max_mcr;
    Error_ACP_T = Error_ACP_T./max_mcr;
    time_LP_T = time_LP_T./max_mcr;
    time_CP_T = time_CP_T./max_mcr;
    time_ACP_T = time_ACP_T./max_mcr;
    %% remove temporary file and save
    for mcr =1:max_mcr
        FileName=[TempName,num2str(mcr)];
        delete Temp*
    end
    SimName=[SimFileName,'_N=',num2str(N),'_n=',num2str(n),'_s=',num2str(s(sparsity_irt)),'_T=',num2str(T),'_montecarlo_itr=',num2str(max_mcr)];
    save(SimName);
end

%%
disp("simulation finished");
toc

