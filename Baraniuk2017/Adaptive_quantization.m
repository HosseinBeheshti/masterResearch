function y = Adaptive_quantization(A_x,A,n,m,s,tau,q)
T = ceil(m/q);
x0 = 0;
for i = 1:T
    yp_temp     = A_temp*x_org-sum(A_temp'.*Phi_temp)';
    y_temp      = theta(yp_temp);
    tau_temp    = sum(A_temp'.*Phi_temp)';
end
end