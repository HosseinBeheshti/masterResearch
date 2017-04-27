function x_adpt = AdptOneBitCS(x_org,n,s,m,plot_adpt)
blk_s   = 10;
stage   = ceil(m/blk_s);
A_var   = 1;
A       = zeros(blk_s,n,stage);
Phi     = randn(n,1,stage);
yp      = zeros(blk_s,1,stage);
y       = zeros(blk_s,1,stage);
tau     = zeros(blk_s,1,stage);
for i = 1:stage
    % measure procedure
    A(:,:,i)    = normrnd(0,A_var,blk_s,n);
    yp(:,:,i)   = A(:,:,i)*x_org-A(:,:,i)*Phi(:,i);
    y(:,:,i)    = theta(yp(:,:,i));
    tau(:,:,i)  = A(:,:,i)*Phi(:,i);
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
    cvx_end
    
    if i==stage(end)
        x_adpt    	= x_cvx;
    else
%         Phi(:,i+1)  = x_cvx;
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
                t2 = -((A(j,1,i)/A(j,2,i))*(t1-Phi(1,i)))+Phi(2,i);
                pause(0.5)
                plot(t1,t2);
                xlim([-2*nrm_inf 2*nrm_inf]);
                ylim([-2*nrm_inf 2*nrm_inf]);
            end
            plot(x_org(1),x_org(2),'.r','markersize',40);
            pause(1)
            plot(x_cvx(1),x_cvx(2),'.b','markersize',35);
            hold off;
        end
    end
end
end