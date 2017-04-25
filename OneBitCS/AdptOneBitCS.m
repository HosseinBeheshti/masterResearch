function x_adpt = AdptOneBitCS(x_org,n,s,m,plot_adpt)
% measure procedure
step    = zeros(m,1);
A       = zeros(m,n);
Phi     = zeros(n,m);
ndrct   = zeros(n,m);
y       = zeros(m,1);
yp      = zeros(m,1);
tau     = zeros(m,1);
% first & second measure
% #1
A(1,:)      = randn(1,n);
step(1)     = 1;
Phi(:,1)    = 0;
yp(1)       = A(1,:)*x_org-A(1,:)*Phi(:,1);
y(1)        = theta(yp(1));
tau(1)      = A(1,:)*Phi(:,1);
ndrct(:,1)  = (y(1).*A(1,:)')./norm(y(1).*A(1,:)');
% #2
A(2,:)      = A(1,:);
step(2)     = step(1)+1;
Phi(:,2)    = Phi(:,1)+step(1).*(ndrct(:,1));
yp(2)       = A(2,:)*x_org-A(2,:)*Phi(:,2);
y(2)        = theta(yp(2));
tau(2)      = A(2,:)*Phi(:,2);
ndrct(:,2)  = (y(2).*A(2,:)')./norm(y(2).*A(2,:)');
% block measure
for i=3:m
    if ndrct(:,i-1)+ndrct(:,i-2)~=0
        A(i,:)      = A(i-1,:);
        step(i)     = step(i-1)+1;
        Phi(:,i)    = Phi(:,i-1)+step(i-1).*(ndrct(:,i-1));
        yp(i)       = A(i,:)*x_org-A(i,:)*Phi(:,i);
        y(i)        = theta(yp(i));
        tau(i)      = A(i,:)*Phi(:,i);
        ndrct(:,i)  = (y(i).*A(i,:)')./norm(y(i).*A(i,:)');
    else
        A(i,:)      = randn(1,n);
        step(i)     = 1;
        Phi(:,i)    = Phi(:,i-1);
        yp(i)       = A(i,:)*x_org-A(i,:)*Phi(:,i);
        y(i)        = theta(yp(i));
        tau(i)      = A(i,:)*Phi(:,i);
        ndrct(:,i)  = (y(i).*A(i,:)')./norm(y(i).*A(i,:)');
    end
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
            pause(0.5)
            plot(t1,t2);
            plot(Phi(1,i),Phi(2,i),'*');
            xlim([-2*nrm_inf 2*nrm_inf]);
            ylim([-2*nrm_inf 2*nrm_inf]);
        end
        plot(x_org(1),x_org(2),'.r','markersize',40);
        pause(1)
        plot(x_adpt(1),x_adpt(2),'.b','markersize',35);
        hold off;
%         figure(2)
%         stem(step);
    end
end
end