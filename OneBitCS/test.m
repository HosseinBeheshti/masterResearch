clear, clc, close all

%Dimension of the problem
n = 2;  

%Number of summation terms
m = 20;

%Random vector c
c = 0*rand(n, 1);

%Random vector b
b = rand(m, 1);

%Random array A
A = rand(m, n);

%CVX optimization
cvx_begin
    variable x(n)
    minimize(c.'*x - sum(log(b - A*x)))
    subject to      %Initially without this line
        b - A*x > 0 %Initially without this line
cvx_end