% Section 8.4.1, Boyd & Vandenberghe "Convex Optimization"
% Original version by Lieven Vandenberghe
% Updated for CVX by Almir Mutapcic - Jan 2006
% (a figure is generated)
%
% We find the ellipsoid E of maximum volume that lies inside of
% a polyhedra C described by a set of linear inequalities.
%
% C = { x | a_i^T x <= b_i, i = 1,...,m } (polyhedra)
% E = { Bu + d | || u || <= 1 } (ellipsoid)
%
% This problem can be formulated as a log det maximization
% which can then be computed using the det_rootn function, ie,
%     maximize     log det B
%     subject to   || B a_i || + a_i^T d <= b,  for i = 1,...,m

clear;
close all;
load log;
A = ply_nrml;
b = ply_ofst;

% formulate and solve the problem
cvx_begin
variable B_mve(n,n) symmetric
variable d_mve(n)
maximize( det_rootn( B_mve ) )
subject to
for i = 1:length(b)
    norm( B_mve*A(i,:)', 2 ) + A(i,:)*d_mve <= b(i);
end
cvx_end

% make the plots


% plot(px,py)
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
for k = 1:length(y)
    t2 = -((A(k,1)/A(k,2))*(t1-Phi(1,k)))+Phi(2,k);
    plot(t1,t2);
    xlim([-L_inf L_inf]);
    ylim([-L_inf L_inf]);
end
% x and xhat
plot(d_mve(1),d_mve(2),'.g','markersize',40);
plot(x_opt(1),x_opt(2),'.b','markersize',35);
pause(1)
plot( ellipse_inner(1,:), ellipse_inner(2,:), 'r--' );
plot( ellipse_outer(1,:), ellipse_outer(2,:), 'r--' );
hold off