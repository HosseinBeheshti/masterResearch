
%% signal parameter
n                   = 2; % signal dimension
s                   = 2; % sparsity
% number of measurment
m_temp           	= 120;

Rmax    = 2; % upper bound for ||x||
Rmin    = 1; % lower bound for ||x||
L_inf   = 10; % upper bound of ||x||_{\inf}
A_var       = 1;
n = 2;
m = 10;

[x_org,~]  = signal_generator(n, s, 0, Rmin, Rmax);

A       = normrnd(0,1,m,n);
tau     = 5*normrnd(0,1,m,1);
yp      = A*x_org-tau;
y       = theta(yp);


% Analytic center
cvx_begin
variable x(n)
minimize -sum(log(y.*(A*x-tau)));
cvx_end

disp(x);
%%
t1 = -5*L_inf:(L_inf/100):5*L_inf;
close all;
figure(1)
hold on;
for j =1:m
    t2 = -(A(j,1)/A(j,2))*t1+(tau(j)/A(j,2));
    plot(t1,t2);
    xlim([-L_inf L_inf]);
    ylim([-L_inf L_inf]);
end
plot(x_org(1),x_org(2),'.r','markersize',40);
plot(x(1),x(2),'.g','markersize',40);
hold off;
