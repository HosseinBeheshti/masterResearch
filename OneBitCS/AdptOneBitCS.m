function x_adpt = AdptOneBitCS(x_org,n,s,m,plot_adpt)
% measure procedure
dh      = m;
step    = zeros(m,1);
A       = randn(m,n);
Phi     = zeros(n,m);
nrm_Phi = zeros(m,1);
drct    = zeros(n,m);
y       = zeros(m,1);
yp      = zeros(m,1);
tau     = zeros(m,1);
y(1)    = theta(A(1,:)*x_org-A(1,:)*Phi(:,1));
yp(1)   = A(1,:)*x_org-A(1,:)*Phi(:,1);
tau(1)  = A(1,:)*Phi(:,1);
step(1:dh) = 1;
for i=1:m-1
    drct(:,i)   = y(i).*A(i,:)';
    nrm_Phi(i)  = norm(Phi(:,i));
    j           = floor(i/dh);
    if j>=1
        if nrm_Phi(dh*j)-nrm_Phi(dh*(j-1)+1) >= 2
            step(dh*j:dh*(j+1)) = step(dh*(j-1)+1)*2;
        else
            step(dh*j:dh*(j+1)) = step(dh*(j-1)+1)/2;
        end
    end
    Phi(:,i+1)  = Phi(:,i)+step(i).*(drct(:,i))/norm(drct(:,i));
    y(i+1)      = theta(A(i+1,:)*x_org-A(i+1,:)*Phi(:,i+1));
    yp(i+1)     = A(i+1,:)*x_org-A(i+1,:)*Phi(:,i+1);
    tau(i+1)    = A(i+1,:)*Phi(:,i+1);
end
%% recovery procedure
% cvx
cvx_begin quiet;
variable x_cvx(n);
minimize(norm(x_cvx,1));
subject to
for i=1:m
    if y(i)>=0
        A(i,:)*x_cvx >= tau(i);
    else
        A(i,:)*x_cvx <= tau(i);
    end
end
cvx_end

% Best K-term (threshold)
x_adpt                      = x_cvx;
% [trash, x_adpt_idx]         = sort(abs(x_adpt), 'descend');
% x_adpt(x_adpt_idx(s+1:end)) = 0;

%% visiual adaptivity
if plot_adpt
    if n == 2
        close all;
        figure(1);
        hold on;
        plot(x_org(1),x_org(2),'.r','markersize',40);
        nrm_inf = norm(x_org,inf);
        t1 = -4*nrm_inf:0.1:4*nrm_inf;
        for i =1:m
            t2 = -((A(i,1)/A(i,2))*(t1-Phi(1,i)))+Phi(2,i);
%             pause(0.5)
            plot(t1,t2);
            plot(Phi(1,i),Phi(2,i),'*');
            xlim([-2*nrm_inf 2*nrm_inf]);
            ylim([-2*nrm_inf 2*nrm_inf]);
        end
        plot(x_org(1),x_org(2),'.r','markersize',40);
%         pause(1)
        plot(x_adpt(1),x_adpt(2),'.b','markersize',35);
        hold off;
%         figure(2)
%         stem(step);
    end
end
end