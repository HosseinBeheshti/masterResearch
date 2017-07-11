clear;
close all;
clc;
tic;
%% monte carlo
itr_avg     = 1;
itr_m       = 1;
%% display control
disp_en           = 1;
%%
dtr_x             = 0;
%% signal parameter
n                   = 2; % signal dimension
s                   = 2; % sparsity
% number of measurment
m_temp           	= 90;
% m_temp              = ceil(s*log(n/s));

blk_s   = 30;

Rmax    = 20; % upper bound for ||x||
Rmin    = 8; % lower bound for ||x||
L_inf   = Rmax; % upper bound of ||x||_{\inf}

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
    disp(['iteration = ',num2str(itr_m)])
    m   = m_temp+10*(itr_m-1);
    for j=1:itr_avg
        %% signal generator
        [x_org(:,j), trueNorm(j)]   = signal_generator(n, s, dtr_x, Rmin, Rmax);
        %% AdptOneBitCS algorithm 1
        x_AdptOneBitCS(:,j)     = AdptOneBitCS(x_org(:,j),n,s,m,L_inf,blk_s,disp_en);
        %%
        [ xhatPV(:,j), xsharpPV(:,j), normxEstPV(j), xhatAlt(:,j), xsharpAlt(:,j), normxEstAlt(j), normxEstEDF(j) ] = KarinKnudson(x_org(:,j), n, s, m, tau, tau2);
    end
    %% Error compute
    PV_err          = r_err_c(xsharpPV,x_org);
%     Alt_err         = r_err_c(xsharpAlt,x_org);
    adpt_err        = r_err_c(x_AdptOneBitCS,x_org);

    avg_PV_err(i)   = sum(PV_err)./size(PV_err,2);
%     avg_Alt_err(i)  = sum(Alt_err)./size(Alt_err,2);
    avg_adpt_err(i) = sum(adpt_err)./size(adpt_err,2);
end
%%
disp(['avg_PV_err = ',num2str(avg_PV_err)])
% disp(['avg_Alt_err = ',num2str(avg_Alt_err)])
disp(['avg_adpt_err = ',num2str(avg_adpt_err)])
disp(m)
%%
toc