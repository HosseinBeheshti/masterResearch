function z_adpt = adpt(x_temp,n,m,s,step,R)
% measure procedure
    A       = randn(m,n);
    Phi     = zeros(n,m);
    drct    = zeros(n,m);
    y       = zeros(m,1);
    tau     = zeros(m,1);
    y(1)    = sign(A(1,:)*x_temp-A(1,:)*Phi(:,1));
    tau(1)  = A(1,:)*Phi(:,1);
    for i=1:m-1
        drct(:,i)   = y(i).*A(i,:)';
    	Phi(:,i+1)  = Phi(:,i)+step.*(drct(:,i))/norm(drct(:,i));
        y(i+1)      = theta(A(i+1,:)*x_temp-A(i+1,:)*Phi(:,i+1));
        tau(i+1)    = A(i+1,:)*Phi(:,i+1);
    end
% visiual adaptivity for n = 2
    if n == 2 
        figure(1);
        hold on;
        plot(x_temp(1),x_temp(2),'.r','markersize',40);   
        t1 = -R:0.1:R;
        for i =1:m
            t2 = -((A(i,1)/A(i,2))*(t1-Phi(1,i)))+Phi(2,i);
            pause(0.1)
            plot(t1,t2);
            plot(Phi(1,i),Phi(2,i),'*'); 
            xlim([-4*nthroot(R, n) 4*nthroot(R, n)])
            ylim([-4*nthroot(R, n) 4*nthroot(R, n)])
        end 
        hold off;
    end
%% recovery procedure
% cvx 
    cvx_begin 
        variable x_adpt(n);
        minimize(norm(x_adpt,1));
        subject to
            A*x_adpt<=(-y.*tau);
    cvx_end
z_adpt = x_adpt;    
end