function z_adpt = adpt(x_temp,n,m,step,R)
% measure procedure
    A   = randn(m,n);
    tau = zeros(m,1);
    Phi = zeros(n,m);
    d   = zeros(n,m);
    y   = zeros(m,1);
    y(1)    = sign(A(1,:)*x_temp-A(1,:)*Phi(:,1)-tau(1));
    for i=1:m-1
        d(:,i) = y(i).*A(i,:)';
    	Phi(:,i+1) = Phi(:,i)+step.*(d(:,i))/norm(d(:,i));
        y(i+1)    = sign(A(i+1,:)*x_temp-A(i+1,:)*Phi(:,i+1)-tau(i+1));
    end
% visiual adaptivity for n = 2
    if n == 2 
        figure(1);
        hold on;
        plot(x_temp(1),x_temp(2),'.r','markersize',40);   
        t1 =-nthroot(R, n):0.1:nthroot(R, n);
        for i =1:m
            t2 = -((A(i,1)/A(i,2))*(t1-Phi(1,i)))+Phi(2,i)+(tau(i)/A(i,2));
%             pause(1)
%             plot(t1,t2);
            plot(Phi(1,i),Phi(2,i),'*'); 
        end 
        hold off;
    a = abs(Phi(1,:)+1i*Phi(2,:));
    end
    
% recovery procedure
    z_adpt = 1;
end