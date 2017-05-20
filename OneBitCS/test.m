% Boyd & Vandenberghe "Convex Optimization"
% Joëlle Skaf - 04/29/08
%
% The analytic center of a set of linear inequalities and equalities:
%           a_i^Tx <= b_i   i=1,...,m,
%           Fx = g,
% is the solution of the unconstrained minimization problem
%           minimize    -sum_{i=1}^m log(b_i-a_i^Tx).

% Input data
n = 2;
m = 4;
L_inf = 10;

A = [-1,eps;1,eps;eps,-1;eps,1];
b = [1;2;1;2];
% Analytic center
cvx_begin
    variable x(n)
    minimize -sum(log(b-A*x))
cvx_end

disp(['The analytic center of the set of linear inequalities and ' ...
      'equalities is: ']);
disp(x);
%%
t1 = -4*L_inf:(L_inf/100):4*L_inf;
close all;
figure(1)
hold on;
for j =1:m
    t2 = -(A(j,1)/A(j,2))*t1+(b(j)/A(j,2));
    plot(t1,t2);
    xlim([-L_inf L_inf]);
    ylim([-L_inf L_inf]);
end
plot(x(1),x(2),'.g','markersize',40);
hold off;
