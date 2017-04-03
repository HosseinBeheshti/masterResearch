clear;
close all;
clc;
tic;
%% plot control
o_plot              = 0;
cs_m_en             = 0;
dtr_x               = 0;
%% signal parameter
n                   = 2;% signal dimension
s                   = 2;% sparsity
% number of measurment      
if cs_m_en
    m               = ceil(s*log(n/s));
else
    m            	= 20;
end
%% Generating a s-sparse signal in R^n
if dtr_x && (n == 2)
    x_org           = [100;0];  
else
    x_org           = zeros(n,1);
    rp              = randperm(n);
    x_org(rp(1:s))  = randn(s,1);   
end
r                   = norm(x_org);
x0                  = [x_org ; -1];
%% Gaussian sensing matrix and associated 1-bit sensing
N                   = randn(m,n+1);
y                   = theta(N*x0);
%% Gnomonic projection(GP)
z0                  = x0./sqrt(r^2+1);
%% convex optimization cvx1
z_pv                = pv(y,n,s,m,N);
%% BIHT 
z_biht              = BIHT(y,n,s,m,N);
%% Adaptive algorithm 1
t                   = 5;
x_adpt              = adpt(x_org,n,m,s);
%% IGP
x_biht_temp         = z_biht.*(sqrt(r^2+1));
x_biht              = x_biht_temp(1:end-1);
x_pv_temp           = z_pv.*(sqrt(r^2+1));
x_pv                = x_pv_temp(1:end-1);
%% plot result
if o_plot
figure
subplot(2,1,1);
hold on;
stem(x_pv,'s');
stem(x_biht,'o');
stem(x_adpt,'*');
stem(x_org,'d');
legend('x_{pv}','x_{biht}','x_{adpt}','x0');
hold off;

subplot(2,1,2);
hold on;
stem(x_org-x_pv,'s');
stem(x_org-x_biht,'o');
stem(x_org-x_adpt,'*');
legend('x_{pv} err','x_{biht} err','x_{adpt} err');
hold off;
end
%%
disp('pv biht adpt')
disp(norm(x_org-x_pv))
disp(norm(x_org-x_biht))
disp(norm(x_org-x_adpt))
disp(m)
disp(r)
%%
toc