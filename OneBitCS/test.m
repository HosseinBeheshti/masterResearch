clear, clc, close all

%Dimension of the problem
n = 2;

%Number of summation terms
m = 4;

%Random vector b


%Random array A


%% optimization
L_inf = 10;
%%
func = @log_barrier;
x0 = [1,1]';
A = [1,eps;1,eps;eps,1;eps,1];
b = [1;2;1;2];
Aeq = [];
beq = [];
lb = [];
ub = [];
x = fmincon(func,x0,A,b,Aeq,beq,lb,ub);


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



