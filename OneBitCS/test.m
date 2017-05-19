clear, clc, close all

%Dimension of the problem
n = 2;

%Number of summation terms
m = 4;

%Random vector b
b = [1;1;2;2];

%Random array A
A = [1,0;0,1;1,0;0,1];

%CVX optimization
cvx_begin
variable x(n)
minimize(- sum(log(b - A*x)))
subject to      %Initially without this line
b - A*x > 0 %Initially without this line
cvx_end
%%
L_inf = 100;
t1 = -4*L_inf:(L_inf/100):4*L_inf;
hold on;
for j =1:m
    t2 = -(A(j,1)/A(j,2))*t1+(b(j)/A(j,2));
    plot(t1,t2);
    xlim([-L_inf L_inf]);
    ylim([-L_inf L_inf]);
end
hold off;



