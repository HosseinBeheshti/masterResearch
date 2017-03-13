function z_adpt = adpt(x_temp,n,m,step)
% measure procedure
    delta_r = zeros(m,1);
    A   = zeros(m,n);
    tau = zeros(m,1);
    y   = zeros(m,1);
    A(1,:)  = randn(1,n);
    tau(1,1)  = randn(1,1);
    y(1,1)    = sign(A(1,:)*x_temp-tau(1));
    for i=1:m-1
        if (y(i)>= 0 && tau(i)>= 0)||(y(i)<0 && tau(i)<0)
            delta_r(i+1) = delta_r(i)+step;
        else
            delta_r(i+1) = delta_r(i)-step;
        end
        A(i+1,:)  = randn(1,n);
        tau(i+1)  = randn(1)+delta_r(i+1);  
        y(i+1,1)    = sign(A(i+1,:)*x_temp-tau(i+1));
    end
% recovery procedure
    z_adpt = 1;
end