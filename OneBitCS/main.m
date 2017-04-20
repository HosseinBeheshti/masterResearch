clear;
close all;
clc;
tic;
%% plot control
o_plot              = 0;
plot_Gpv            = 0;
plot_Apv            = 0;
plot_GBIHT          = 0;
plot_adpt           = 1;
%%
cs_m_en             = 0;
dtr_x               = 0;
%% signal parameter
n                   = 300;% signal dimension
s                   = 10;% sparsity
% number of measurment      
if cs_m_en
    m               = ceil(s*log(n/s));
else
    m            	= 1000;
end
Rmax = 20; %upper bound for ||x||
Rmin = 10; %lower bound for ||x||

tau =Rmin% Threshold parameter: an alternative is 
tau2 = Rmin/2+Rmax/2 %(works better with convex minimizaiton);
%% signal generator
x_org               = signal_generator(n, s, dtr_x, Rmin, Rmax);
%% convex optimization Gpv
% x_Gpv               = Gpv(x_org,n,s,m,plot_Gpv);
%% GBIHT 
% x_Gbiht             = GBIHT(x_org,n,s,m,plot_GBIHT);
%% convex optimization Apv
x_Apv               = Apv(x_org,n,s,m,plot_Apv);
%% AdptOneBitCS algorithm 1
x_AdptOneBitCS   	= AdptOneBitCS(x_org,n,s,m,plot_adpt);
%% 
[ xhatPV, xsharpPV, normxEstPV, xhatAlt, xsharpAlt, normxEstAlt, normxEstEDF ] = KarinKnudson(x_org, n, s, m, tau, tau2);

%% norm 


% Gpv_err         = r_err_c(x_Gpv,x_org);
% Gbiht_err       = r_err_c(x_Gbiht,x_org);
Apv_err         = r_err_c(x_Apv,x_org);
bb_err         = r_err_c(xsharpPV,x_org);
aa_err         = r_err_c(xsharpAlt,x_org);
adpt_err        = r_err_c(x_AdptOneBitCS,x_org);

% disp(['Gpv_err = ',num2str(Gpv_err)])
% disp(['Gbiht_err = ',num2str(Gbiht_err)])
disp(['Apv_err = ',num2str(Apv_err)])
disp(['adpt_err = ',num2str(adpt_err)])

disp(m)
%%
toc