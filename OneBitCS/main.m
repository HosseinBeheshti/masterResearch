clear;
close all;
clc;
tic;
%% monte carlo
itr = 5;
%% plot control
plot_adpt           = 0;
%%
cs_m_en             = 0;
dtr_x               = 0;
%% signal parameter
n                   = 10;% signal dimension
s                   = 2; % sparsity
% number of measurment      
m            	= 150; % ceil(s*log(n/s));

Rmax    = 20; %upper bound for ||x||
Rmin    = 10; %lower bound for ||x||

tau     = Rmin;% Threshold parameter: an alternative is 
tau2    = Rmin/2+Rmax/2; %(works better with convex minimizaiton);

x_org           = zeros(n,itr);
x_AdptOneBitCS  = zeros(n,itr);
xhatPV          = zeros(n+1,itr);
xsharpPV        = zeros(n,itr);
normxEstPV      = zeros(1,itr);
xhatAlt         = zeros(n,itr);
xsharpAlt       = zeros(n-1,itr);
normxEstAlt     = zeros(1,itr);
normxEstEDF     = zeros(1,itr);
trueNorm        = zeros(1,itr);

for i=1:itr
%% signal generator
[x_org(:,i), trueNorm(i)]   = signal_generator(n, s, dtr_x, Rmin, Rmax);
%% convex optimization Gpv
% x_Gpv(:,i)               = Gpv(x_org,n,s,m);
%% GBIHT 
% x_Gbiht(:,i)             = GBIHT(x_org,n,s,m);
%% convex optimization Apv
% x_Apv(:,i)               = Apv(x_org,n,s,m);
%% AdptOneBitCS algorithm 1
x_AdptOneBitCS(:,i)     = AdptOneBitCS(x_org(:,i),n,s,m,plot_adpt);
%% 
[ xhatPV(:,i), xsharpPV(:,i), normxEstPV(i), xhatAlt(:,i), xsharpAlt(:,i), normxEstAlt(i), normxEstEDF(i) ] = KarinKnudson(x_org(:,i), n, s, m, tau, tau2);
end
%% norm 
% Gpv_err         = r_err_c(x_Gpv,x_org);
% Gbiht_err       = r_err_c(x_Gbiht,x_org);
% Apv_err         = r_err_c(x_Apv,x_org);
PV_err         = r_err_c(xsharpPV,x_org);
Alt_err         = r_err_c(xsharpAlt,x_org);
adpt_err        = r_err_c(x_AdptOneBitCS,x_org);

% disp(['Gpv_err = ',num2str(Gpv_err)])
% disp(['Gbiht_err = ',num2str(Gbiht_err)])
% disp(['Apv_err = ',num2str(Apv_err)])
disp(['PV_err = ',num2str(PV_err)])
disp(['Alt_err = ',num2str(Alt_err)])
disp(['adpt_err = ',num2str(adpt_err)])

disp(m)
%%
toc