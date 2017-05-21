function x_adpt = AdptOneBitCS(x_org,n,s,m,L_inf,blk_s,plot_adpt)
stage       = ceil(m/blk_s);
A_var       = 1;
Phi_var     = 5*ones(stage,1);
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
    % compute optimal solution
    cvx_begin quiet;
    variable x_cvx(n);
    minimize(norm(x_cvx,1));
    subject to
    for k = 1:i
        y(:,:,k).*(A(:,:,k)*x_cvx-tau(:,:,k)) >= 0;
    end
    norm(x_cvx,inf)     <= L_inf;
    cvx_end
    
    % Computing Analytic center
    cvx_begin quiet;
    variable x_ac(n);
    minimize -sum(log(y(:,:,i).*(A(:,:,i)*x_ac-tau(:,:,i))));
    subject to
    norm(x_ac,inf) <= L_inf;
    cvx_end
    
    % Computing Gaussian width
    g = normrnd(0,1,1,n);
    % sup
    cvx_begin quiet;
    variable w_s(n);
    maximize g*w_s;
    subject to
    for k = 1:i
        y(:,:,k).*(A(:,:,k)*w_s-tau(:,:,k)) >= 0;
    end
    norm(w_s,inf)     <= L_inf;
    cvx_end
    % inf
    cvx_begin quiet;
    variable w_i(n);
    maximize -g*w_i;
    subject to
    for k = 1:i
        y(:,:,k).*(A(:,:,k)*w_i-tau(:,:,k)) >= 0;
    end
    norm(w_i,inf)     <= L_inf;
    cvx_end
    
    w_cvx(i)    = sum(sqrt((w_i-w_s).^2));
    
    % set parameter
    if i==stage(end)
        x_adpt          = x_cvx;
    else
        if ~isnan(x_ac)
            ofset(:,i+1)   	= x_cvx;
        else
            ofset(:,i+1)   	= x_ac;
        end
        if ~isnan(w_cvx(i))
            Phi_var(i+1)    = Phi_var(i);
        else
            Phi_var(i+1)    = sqrt(w_cvx(i));
        end
    end
    
    %% visiual adaptivity
    if plot_adpt
        if n == 2
            close all;
            figure(1);
            hold on;
            % norm constraint
            sp  = -L_inf:(L_inf/100):L_inf;
            plot(L_inf*ones(length(sp)),sp,'.b','markersize',5);
            plot(-L_inf*ones(length(sp)),sp,'.b','markersize',5);
            plot(sp,L_inf*ones(length(sp)),'.b','markersize',5);
            plot(sp,-L_inf*ones(length(sp)),'.b','markersize',5);
            plot(x_org(1),x_org(2),'.r','markersize',40);
            t1 = -4*L_inf:(L_inf/100):4*L_inf;
            for k = i:i
                for j =1:blk_s
                    t2 = -((A(j,1,k)/A(j,2,k))*(t1-Phi(1,j,k)))+Phi(2,j,k);
                    plot(t1,t2);
                    xlim([-L_inf L_inf]);
                    ylim([-L_inf L_inf]);
                end
            end
            % x and xhat
            plot(x_ac(1),x_ac(2),'.g','markersize',40);
            plot(x_cvx(1),x_cvx(2),'.b','markersize',35);
            pause(1)
            hold off;
        end
        if i == stage
            figure(2);
            stem(w_cvx);
        end
    end
end
end