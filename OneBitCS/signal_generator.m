function x_org = signal_generator(n,s,m,dtr_x)
%% Generating a s-sparse signal in R^n
if dtr_x && (n == 2)
    x_org           = [10;0];  
else
    x_org           = zeros(n,1);
    rp              = randperm(n);
    x_org(rp(1:s))  = randn(s,1);   
end
end