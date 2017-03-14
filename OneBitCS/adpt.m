function z_adpt = adpt(x_temp,n,m,step)
% measure procedure
    A   = randn(m,n);
    tau = zeros(m,1);
    Phi = zeros(n,m);
    y   = zeros(m,1);
    y(1)    = sign(A(1,:)*x_temp+A(1,:)*Phi(:,1)-tau(1));
    y(2)    = sign(A(2,:)*x_temp+A(2,:)*Phi(:,2)-tau(2));
    for i=2:m-1
    	Phi(:,i+1) = step.*(y(i).*A(i,:)'+y(i-1).*A(i-1,:)')/2;
        y(i+1)    = sign(A(i+1,:)*x_temp+A(i+1,:)*Phi(:,i+1)-tau(i+1));
    end
% visiual adaptivity for n = 2
    if n == 2
        close all;
        figure;
        hold on;
        plot(Phi(1,:),Phi(2,:),'*'); 
        plot(x_temp(1),x_temp(2),'o'); 
        hold off;
    end
% recovery procedure
    z_adpt = 1;
end