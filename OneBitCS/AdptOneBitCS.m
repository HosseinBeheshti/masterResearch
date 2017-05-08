function x_adpt = AdptOneBitCS(x_org,n,s,m,Rmax,plot_adpt)
blk_s       = 10;
stage       = ceil(m/blk_s);
A_var       = 1;
Phi_var     = sqrt(Rmax).*ones(stage,1);
w_cvx       = zeros(1,stage);
A           = zeros(blk_s,n,stage);
Phi         = zeros(n,blk_s,stage);
ofset       = zeros(n,stage);
yp          = zeros(blk_s,1,stage);
y           = zeros(blk_s,1,stage);
tau         = zeros(blk_s,1,stage);
for i = 1:stage
    % measure procedure
    for j = 1:blk_s
        A(j,:,i)    = normrnd(0,A_var,1,n);
        Phi(:,j,i)	= normrnd(0,Phi_var(i),n,1)+ofset(:,i);
        yp(j,:,i)   = A(j,:,i)*x_org-A(j,:,i)*Phi(:,j,i);
        y(j,:,i)    = theta(yp(j,:,i));
        tau(j,:,i)  = A(j,:,i)*Phi(:,j,i);
    end
    %% recovery procedure
    % cvx
    cvx_begin quiet;
    variable x_cvx(n);
    minimize(norm(x_cvx,1));
    subject to
    for k = 1:i
        for j=1:blk_s
            if y(j,:,k)>=0
                A(j,:,k)*x_cvx >= tau(j,:,k);
            else
                A(j,:,k)*x_cvx <= tau(j,:,k);
            end
        end
    end
    norm(x_cvx)     <= Rmax;
    cvx_end
    
    % Computing Gaussian width
    g = normrnd(0,1,1,n);
    cvx_begin quiet;
    variable z_cvx(n);
    maximize g*z_cvx;
    subject to
    for k = 1:i
        for j=1:blk_s
            if y(j,:,k)>=0
                A(j,:,k)*(z_cvx+x_cvx) >= tau(j,:,k);
            else
                A(j,:,k)*(z_cvx+x_cvx) <= tau(j,:,k);
            end
        end
    end
    norm(z_cvx)     <= Rmax;
    cvx_end
    
    w_cvx(i)    = abs(g*z_cvx)./norm(g);
    
    % set parameter
    if i==stage(end)
        x_adpt          = x_cvx;
    else
        ofset(:,i+1)   	= x_cvx;
        %         Phi_var(i+1)    = w_cvx(i);
    end
    
    %% visiual adaptivity
    if plot_adpt
        if n == 2
            close all;
            figure(1);
            hold on;
            plot(x_org(1),x_org(2),'.r','markersize',40);
            nrm_inf = norm(x_org,inf);
            t1 = -4*nrm_inf:0.1:4*nrm_inf;
            for j =1:blk_s
                t2 = -((A(j,1,i)/A(j,2,i))*(t1-Phi(1,j,i)))+Phi(2,j,i);
                %                 pause(0.5)
                plot(t1,t2);
                xlim([-2*nrm_inf 2*nrm_inf]);
                ylim([-2*nrm_inf 2*nrm_inf]);
            end
            % norm constraint
            ang=0:0.01:2*pi;
            xp = Rmax*cos(ang);
            yp = Rmax*sin(ang);
            plot(xp,yp);
            % x and xhat
            plot(x_org(1),x_org(2),'.r','markersize',40);
            pause(1)
            plot(x_cvx(1),x_cvx(2),'.b','markersize',35);
            pause(1)
            hold off;
        end
    end
end
end