function x_Apv = Apv(x_org,n,s,m)
%   min ||(z,u)||_1  
%   z\in R^n u\in R    
%   s.t
%   \sum^{m}_{i=1} |<a_i,z>+u/\tau b_i| = m     and     sign(<a_i,z>+u/\tau b_i) = sign(<a_i,x>+b_i)    (6)
    %% Gaussian sensing matrix and associated 1-bit sensing
    A     	= randn(m,n);
    tau     = 1;
    b       = (tau^2).*randn(m,1);
    y     	= theta(A*x_org+b);
    %% cvx
    cvx_begin 
        variable x_temp(n);
        variable u_temp(1);
        minimize(norm([x_temp;u_temp],1));
        subject to
            sum((A*x_temp+(u_temp/tau).*b).*y) == m ;
            (A*x_temp+(u_temp/tau).*b).*y >= 0
        cvx_end
    x_Apv   = tau.*(x_temp)./u_temp;
end