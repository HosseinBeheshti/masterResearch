clear;
close all;
clc;
tic;
%% monte carlo
itr_avg     = 1;
itr_m       = 1;
%% plot control
plot_adpt           = 1;
%%
dtr_x               = 0;
%% signal parameter
n                   = 20; % signal dimension
s                   = 2; % sparsity
% number of measurment
m_temp           	= 120;
% m_temp              = ceil(s*log(n/s));

blk_s   = 30;

Rmax    = 9; % upper bound for ||x||
Rmin    = 5; % lower bound for ||x||
L_inf   = 9; % upper bound of ||x||_{\inf}

tau     = Rmin;% Threshold parameter: an alternative is
tau2    = Rmin/2+Rmax/2; %(works better with convex minimizaiton);

x_org           = zeros(n,itr_avg);
x_AdptOneBitCS  = zeros(n,itr_avg);
xhatPV          = zeros(n+1,itr_avg);
xsharpPV        = zeros(n,itr_avg);
normxEstPV      = zeros(1,itr_avg);
xhatAlt         = zeros(n,itr_avg);
xsharpAlt       = zeros(n-1,itr_avg);
normxEstAlt     = zeros(1,itr_avg);
normxEstEDF     = zeros(1,itr_avg);
trueNorm        = zeros(1,itr_avg);

avg_Gpv_err     = zeros(1,itr_m);
avg_Gbiht_err   = zeros(1,itr_m);
avg_Apv_err     = zeros(1,itr_m);
avg_PV_err      = zeros(1,itr_m);
avg_Alt_err     = zeros(1,itr_m);
avg_adpt_err    = zeros(1,itr_m);

for i=1:itr_m
    m   = m_temp+10*(itr_m-1);
    for j=1:itr_avg
        %% signal generator
        [x_org(:,j), trueNorm(j)]   = signal_generator(n, s, dtr_x, Rmin, Rmax);
        %% convex optimization Gpv
        % x_Gpv(:,i)               = Gpv(x_org,n,s,m);
        %% GBIHT
        % x_Gbiht(:,i)             = GBIHT(x_org,n,s,m);
        %% convex optimization Apv
        % x_Apv(:,i)               = Apv(x_org,n,s,m);
        %% AdptOneBitCS algorithm 1
        x_AdptOneBitCS(:,j)     = AdptOneBitCS(x_org(:,j),n,s,m,L_inf,blk_s,plot_adpt);
        %%
        [ xhatPV(:,j), xsharpPV(:,j), normxEstPV(j), xhatAlt(:,j), xsharpAlt(:,j), normxEstAlt(j), normxEstEDF(j) ] = KarinKnudson(x_org(:,j), n, s, m, tau, tau2);
    end
    %% Error compute
    % Gpv_err         = r_err_c(x_Gpv,x_org);
    % Gbiht_err       = r_err_c(x_Gbiht,x_org);
    % Apv_err         = r_err_c(x_Apv,x_org);
    PV_err          = r_err_c(xsharpPV,x_org);
%     Alt_err         = r_err_c(xsharpAlt,x_org);
    adpt_err        = r_err_c(x_AdptOneBitCS,x_org);
    
    
    % avg_Gpv_err(i)    = sum(Gpv_err)./size(Gpv_err,2);
    % avg_Gbiht_err(i)  = sum(Gbiht_err)./size(Gbiht_err,2);
    % avg_Apv_err(i)    = sum(Apv_err)./size(Apv_err,2);
    avg_PV_err(i)   = sum(PV_err)./size(PV_err,2);
%     avg_Alt_err(i)  = sum(Alt_err)./size(Alt_err,2);
    avg_adpt_err(i) = sum(adpt_err)./size(adpt_err,2);
end
%%

% disp(['avg_Gpv_err = ',num2str(avg_Gpv_err)])
% disp(['avg_Gbiht_err = ',num2str(avg_Gbiht_err)])
% disp(['avg_Apv_err = ',num2str(avg_Apv_err)])
disp(['avg_PV_err = ',num2str(avg_PV_err)])
% disp(['avg_Alt_err = ',num2str(avg_Alt_err)])
disp(['avg_adpt_err = ',num2str(avg_adpt_err)])
disp(m)
%%
toc