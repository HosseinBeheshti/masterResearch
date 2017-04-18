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
Rmax = 1; %upper bound for ||x||
Rmin = .1; %lower bound for ||x||

tau =Rmin% Threshold parameter: an alternative is 
tau2 = Rmin/2+Rmax/2 %(works better with convex minimizaiton);
%% signal generator
x_org               = signal_generator(n, s, dtr_x, Rmin, Rmax);
%% convex optimization Gpv
x_Gpv               = Gpv(x_org,n,s,m,plot_Gpv);
%% convex optimization Apv
x_Apv               = Apv(x_org,n,s,m,plot_Apv);
%% GBIHT 
x_Gbiht             = GBIHT(x_org,n,s,m,plot_GBIHT);
%% AdptOneBitCS algorithm 1
x_adpt              = AdptOneBitCS(x_org,n,s,m,plot_adpt);
%% 
% [ xhatPV, xsharpPV, normxEstPV, xhatAlt, xsharpAlt, normxEstAlt, normxEstEDF ] = KarinKnudson(x_org, n, s, m, tau, tau2);
%% plot result
if o_plot
figure
subplot(2,1,1);
hold on;
stem(x_Gpv,'s');
stem(x_Gbiht,'o');
stem(x_adpt,'*');
stem(x_org,'d');
legend('x_{Gpv}','x_{Gbiht}','x_{adpt}','x0');
hold off;

subplot(2,1,2);
hold on;
stem(x_org-x_Gpv,'s');
stem(x_org-x_Gbiht,'o');
stem(x_org-x_adpt,'*');
legend('x_{pv} err','x_{biht} err','x_{AdptOneBitCS} err');
hold off;
end
%% norm 


Gpv_err         = r_err_c(x_Gpv,x_org);
Apv_err       = r_err_c(x_Apv,x_org);
Gbiht_err       = r_err_c(x_Gbiht,x_org);
adpt_err        = r_err_c(x_adpt,x_org);

disp(['Gpv_err = ',num2str(Gpv_err)])
disp(['Apv_err = ',num2str(Apv_err)])
disp(['Gbiht_err = ',num2str(Gbiht_err)])
disp(['adpt_err = ',num2str(adpt_err)])

disp(m)
%%
toc