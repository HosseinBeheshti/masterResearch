clear;
clc;
close all;
tic;
%% monte carlo
max_mcr = 500;
%% number of measurements
Max_m = 20000;
Step_m = 500;
Min_m = 100;
T_it_number = floor((Max_m-Min_m)/Step_m)+1;
%% allocate vectors
Error_LP = zeros(1,T_it_number);
Error_CP = zeros(1,T_it_number);
Error_ACP = zeros(1,T_it_number);
%% file name
TempName = 'TempFile_';
SimFileName = 'SimResult';
%% signal properties
N = 1000; % size of x
s = 10; % sparsity of x
n = 50; % number of dictionary rows
T = 10; % number of batch
%%
disp("start simulation");
for mcr = 1:max_mcr
    parfor itr_i=1:T_it_number
        %% Generate signal
        % define the sparse vector x
        supp = sort(randsample(N,s));   % support of x
        x = zeros(N,1);
        x(supp) = randn(s,1);       	% entries of x on its support
        
        % Generate dictionary
        D = DictionaryGenerator(n,N);
        f = D*x;
        r = 2*norm(f);                  % an (over)estimation of the magnitude of f
        
        % specify the random measurements to be used
        m = (itr_i-1)*Step_m+Min_m;     % number of measurements
        A = randn(m,n);                 % measurement matrix
        
        %% LP
        fLP_main = LP_main(D,A,f,r);
        
        %% CP
        fCP_main = CP_main(D,A,f,r,r);
        
        %% Adaptive CP
        fACP_main = ACP_main(D,A,f,r,T);
        
        %% Compute error
        err_LP = norm(fLP_main-f)/norm(f);
        err_CP = norm(fCP_main-f)/norm(f);
        err_ACP = norm(fACP_main(:,end)-f)/norm(f);
        
        Error_LP(itr_i) = err_LP;
        Error_CP(itr_i) = err_CP;
        Error_ACP(itr_i) = err_ACP;
        
        fprintf('monte carlo : %d\n',mcr)
        fprintf('measurements: %d\n',itr_i)
    end
    
    FileName=[TempName,num2str(mcr)];
    save(FileName)
end

%% Compute data average
Error_LP_T = zeros(1,length(Error_LP));
Error_CP_T = zeros(1,length(Error_CP));
Error_ACP_T = zeros(1,length(Error_ACP));
for mcr =1:max_mcr
    FileName=[TempName,num2str(mcr)];
    load(FileName)
    Error_LP_T = Error_LP_T+Error_LP;
    Error_CP_T = Error_CP_T+Error_CP;
    Error_ACP_T = Error_ACP_T+Error_ACP;
end
Error_LP_T = Error_LP_T./max_mcr;
Error_CP_T = Error_CP_T./max_mcr;
Error_ACP_T = Error_ACP_T./max_mcr;

SimName=[SimFileName,'_N=',num2str(N),'_n=',num2str(n),'_s=',num2str(s),'_T=',num2str(T)];
save(SimName)

%% remove temporary file
for mcr =1:max_mcr
    FileName=[TempName,num2str(mcr)];
    delete Temp*
end
%% plot result
close all;
load('SimResult_N=1000_n=100_s=10_T=10');
hold on;
plot(((0:(T_it_number-1))*Step_m+Min_m),10*log10(Error_LP_T),'DisplayName','LP','Marker','*','LineStyle','-.',...
    'Color',[0 0.5 0],'LineWidth',1.5);
plot(((0:(T_it_number-1))*Step_m+Min_m),10*log10(Error_CP_T),'DisplayName','CP','Marker','diamond','LineStyle','--',...
    'Color',[1 0 0],'LineWidth',1.5);
plot(((0:(T_it_number-1))*Step_m+Min_m),10*log10(Error_ACP_T),'DisplayName','Our algorithm','Marker','square',...
    'Color',[0 0 1],'LineWidth',1.5);
legend('LP','CP','Our algorithm')
ylabel('Nomalized reconstruction error (dB)')
xlabel('Number of measurments')
hold off;
TikzName=['Tikz-',datestr(now, 'dd-mmm-yyyy'),'.tex'];
matlab2tikz(TikzName)
%%
toc

