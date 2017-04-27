function x_adpt = AdptOneBitCS(x_org,n,s,m,Rmax,plot_adpt)
blk_s       = 10;
stage       = ceil(m/blk_s);
A_var       = 1;
Phi_var     = zeros(stage);
A           = zeros(blk_s,n,stage);
Phi         = zeros(n,blk_s,stage);
ofset       = zeros(n,stage);
yp          = zeros(blk_s,1,stage);
y           = zeros(blk_s,1,stage);
tau         = zeros(blk_s,1,stage);

Phi_var(1)  = sqrt(Rmax);
for i = 1:stage
    % measure procedure
    for j = 1:blk_s
        A(j,:,i)    = normrnd(0,A_var,1,n);
        Phi(:,j,i)	= normrnd(0,Phi_var,n,1)+ofset(:,i);
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
    for j=1:blk_s
        if y(j,:,i)>=0
            A(j,:,i)*x_cvx >= tau(j,:,i);
        else
            A(j,:,i)*x_cvx <= tau(j,:,i);
        end
    end
    norm(x_cvx)     <= Rmax;
    cvx_end
    
    % Computing Gaussian width
    
    
    if i==stage(end)
        x_adpt          = x_cvx;
    else
        ofset(:,i+1)   	= x_cvx;
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
                pause(0.5)
                plot(t1,t2);
                xlim([-2*nrm_inf 2*nrm_inf]);
                ylim([-2*nrm_inf 2*nrm_inf]);
            end
            plot(x_org(1),x_org(2),'.r','markersize',40);
            pause(1)
            plot(x_cvx(1),x_cvx(2),'.b','markersize',35);
            pause(2)
            hold off;
        end
    end
end
end