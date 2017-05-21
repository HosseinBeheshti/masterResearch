clear;
close all;
clc;
tic;
%% parameter
n = 2;
s = 2;
m = 15;
itr = 10;
Rmax    = 5; %upper bound for ||x||
Rmin    = 1; %lower bound for ||x||
%%
A       = normrnd(0,1,m,n);
tau     = 3*normrnd(0,1,m,1);
[x_org, trueNorm]   = signal_generator(n, s, 0, Rmin, Rmax);
y       = theta(A*x_org-tau);

g = normrnd(0,1,1,n);
cvx_begin quiet;
variable w_s(n);
maximize g*w_s;
subject to
y.*(A*w_s-tau) >= 0;
norm(w_s,inf)  <= Rmax;
cvx_end

cvx_begin quiet;
variable w_i(n);
maximize -g*w_i;
subject to
y.*(A*w_i-tau) >= 0;
norm(w_i,inf)  <= Rmax;
cvx_end

w_cvx    = abs(w_s-w_i);

%%
L_inf = 10;
t1 = -L_inf:(L_inf/100):L_inf;
close all;
figure(1)
hold on;
for j =1:m
    t2 = -(A(j,1)/A(j,2))*t1+(tau(j)/A(j,2));
    plot(t1,t2);
    xlim([-L_inf L_inf]);
    ylim([-L_inf L_inf]);
end
plotv(g');
plot(x_org(1),x_org(2),'.r','markersize',40);
plot(w_s(1),w_s(2),'.b','markersize',40);
plot(w_i(1),w_i(2),'.g','markersize',40);
hold off;
%%
n = toc