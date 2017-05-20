function x_LB = log_barrier(x)
A = [1,eps;1,eps;eps,1;eps,1];
b = [1;2;1;2];
x_LB = -sum(log(b-A*x));
end