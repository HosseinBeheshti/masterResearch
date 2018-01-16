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
%% sparsity level
Max_s = 30;
Step_s = 10;
Min_s = 10;
%% monte carlo
max_mcr = 1;
%% number of measurements
Max_m = 20000;
Step_m = 200;
Min_m = 100;
T_it_number = floor((Max_m-Min_m)/Step_m)+1;
%% allocate vectors
Error_CP = zeros(1,T_it_number);
Error_ACP = zeros(1,T_it_number);
Error_CP_T = zeros(1,length(Error_CP));
Error_ACP_T = zeros(1,length(Error_ACP));
%% file name
TempName = 'TempFile_';
SimFileName = 'SimResult';
%% 
for sprst=Min_s:Step_s:Max_s
    
    for mcr =1:max_mcr
        
        parfor itr_i=1:T_it_number
            %% Generate signal
            % define the sparse vector x
            N = 1000;                      	% size of x
            s = sprst;                      % sparsity of x
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
        
        FileName=[TempName,num2str(mcr)];
        save(FileName)
    end
    
    %% Compute data average
    
    for mcr =1:max_mcr
        FileName=[TempName,num2str(mcr)];
        load(FileName)
        Error_CP_T = Error_CP_T+Error_CP;
        Error_ACP_T = Error_ACP_T+Error_ACP;
    end
    Error_CP_T = Error_CP_T./max_mcr;
    Error_ACP_T = Error_ACP_T./max_mcr;
    
    SimName=[SimFileName,'_N=',num2str(1000),'_n=',num2str(50),'_s=',num2str(sprst)];
    save(SimName)
end
%% remove temporary file
for mcr =1:max_mcr
    FileName=[TempName,num2str(mcr)];
    delete Temp*
end
%% load data
T_s_it_number = floor((Max_s-Min_s)/Step_s)+1;
Error_CP_r = zeros(T_s_it_number,length(Error_CP));
Error_ACP_r = zeros(T_s_it_number,length(Error_ACP));

for s_it=1:T_s_it_number
    SimName=[SimFileName,'_N=',num2str(1000),'_n=',num2str(50),'_s=',num2str((s_it-1)*Step_s+Min_s)];
    load(SimName)
    Error_CP_r(s_it,:)= Error_CP_T;
    Error_ACP_r(s_it,:)= Error_ACP_T;
end

%% plot result
close all;
hold all;
legendInfo = cell(1,2*s_it);
for s_it=1:T_s_it_number
    plot(((0:(T_it_number-1))*Step_m+Min_m),10*log10(Error_CP_r(s_it,:)));
    legendInfo{s_it} = ['CP s = ' num2str((s_it-1)*Step_s+Min_s)];
end
for s_it=1:T_s_it_number
    plot(((0:(T_it_number-1))*Step_m+Min_m),10*log10(Error_ACP_r(s_it,:)));
    legendInfo{s_it+T_s_it_number} = ['ACP s = ' num2str((s_it-1)*Step_s+Min_s)];
end

legend(legendInfo)
ylabel('Reconstruction Error (dB)')
xlabel('measurments')

hold off;
%%
toc
