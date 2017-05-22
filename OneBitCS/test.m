% Boyd & Vandenberghe, "Convex Optimization"
% Joëlle Skaf - 08/16/05
% (a figure is generated)
%
% The goal is to find the largest Euclidean ball (i.e. its center and
% radius) that lies in a polyhedron described by linear inequalites in this
% fashion: P = {x : a_i'*x <= b_i, i=1,...,m} where x is in R^2

load log;
ply_nrml = -y(:,:,i).*A(:,:,i);
ply_ofst = -y(:,:,i).*tau(:,:,i);
% Computing Chebyshev center
cvx_begin quiet;
variable r(1)
variable x_c(n)
maximize (r)
for k = 1:blk_s
ply_nrml(k,:)*x_c +r*norm(ply_nrml(k,:)',2) <= ply_ofst(k);
end
cvx_end
%%
close all;
figure(1);
hold on;
% norm constraint
sp  = -L_inf:(L_inf/100):L_inf;
plot(L_inf*ones(length(sp)),sp,'.b','markersize',5);
plot(-L_inf*ones(length(sp)),sp,'.b','markersize',5);
plot(sp,L_inf*ones(length(sp)),'.b','markersize',5);
plot(sp,-L_inf*ones(length(sp)),'.b','markersize',5);
plot(x_org(1),x_org(2),'.r','markersize',40);
t1 = -4*L_inf:(L_inf/100):4*L_inf;
for k = 1:i
    for j =1:blk_s
        t2 = -((A(j,1,k)/A(j,2,k))*(t1-Phi(1,j,k)))+Phi(2,j,k);
        plot(t1,t2);
%         pause(3);
        xlim([-L_inf L_inf]);
        ylim([-L_inf L_inf]);
    end
end
% x and xhat
plot(x_c(1),x_c(2),'.g','markersize',40);


% Generate the figure
x = linspace(-2,2);
theta = 0:pi/100:2*pi;
plot( x_c(1) + r*cos(theta), x_c(2) + r*sin(theta), 'r');
plot(x_c(1),x_c(2),'k+')
hold off;
