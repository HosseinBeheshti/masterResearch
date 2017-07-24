function y = Adaptive_quantization(x,A,n,m,s,tau,q)
T       = ceil(m/q);
x       = zeros(1,n);
Sigma   = zeors(1,m);
for i = 1:T
    Sigma((i-1)*T+1:(i)*T)      = A((i-1)*T,:)*x;
    y((i-1)*T+1:(i)*T)          = 
    y_temp      = theta(yp_temp);
    tau_temp    = sum(A_temp'.*Phi_temp)';
end
end