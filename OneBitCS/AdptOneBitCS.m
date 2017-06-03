function x_adpt = AdptOneBitCS(x_org,n,s,m,L_inf,blk_s,plot_adpt)
stage       = ceil(m/blk_s);
A_var       = 1;
Phi_var     = 5*ones(stage,1);
w_cvx       = zeros(1,stage);
ofset       = zeros(n,stage);
% l_{\inf} polyhedron
ATemp   = kron(eye(n),ones(2,1));
PhiTemp = L_inf.*kron(eye(n),[1; -1])';
tauTemp = sum(ATemp'.*PhiTemp)';
yTemp   = tauTemp;

A           = ATemp;
Phi         = PhiTemp;
tau         = tauTemp;
y           = -yTemp;

for i = 1:stage
    %% measure procedure
    A_temp      = normrnd(0,A_var,blk_s,n);
    Phi_temp    = normrnd(0,Phi_var(i),n,blk_s)+ofset(:,i);
    yp_temp     = A_temp*x_org-sum(A_temp'.*Phi_temp)';
    y_temp      = theta(yp_temp);
    tau_temp    = sum(A_temp'.*Phi_temp)';
    %% recovery procedure
    % polyhedron normal and ofset
    A   = [A ; A_temp];
    y   = [y ; y_temp];
    Phi = [Phi Phi_temp];
    tau = [tau ; tau_temp];

    % compute optimal solution
    cvx_begin quiet;
    variable x_opt(n);
    minimize(norm(x_opt,1));
    subject to
    y.*(A*x_opt-tau)    >= 0;
    norm(x_opt,inf)     <= L_inf;
    cvx_end
    
    % Computing Chebyshev center
    ply_nrml = -y.*A;
    ply_ofst = -y.*tau;

    cvx_begin quiet;
    variable r_c(1)
    variable x_c(n)
    maximize ( r_c )
    subject to
    for k = 1:length(y)
        ply_nrml(k,:)*x_c +r_c*norm(ply_nrml(k,:)',2) <= ply_ofst(k);
    end
    cvx_end

    w_cvx(i)    = r_c;
    % set parameter
    if i==stage(end)
        x_adpt          = x_opt;
    else
        if ~isnan(x_c)
            if norm(x_c,inf) < L_inf
                ofset(:,i+1)   	= x_c;
            else
                ofset(:,i+1)   	= x_opt;
            end
        else
            
            ofset(:,i+1)   	= x_opt;
        end
        if ~isnan(w_cvx(i))
            Phi_var(i+1)    =  sqrt(abs(w_cvx(i)));
        else
            Phi_var(i+1)    = Phi_var(i);
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
            for k = 1:length(y)
                    t2 = -((A(k,1)/A(k,2))*(t1-Phi(1,k)))+Phi(2,k);
                    plot(t1,t2);
                    xlim([-L_inf L_inf]);
                    ylim([-L_inf L_inf]);
            end
            % x and xhat
            plot(x_c(1),x_c(2),'.g','markersize',40);
            CTheta = 0:pi/100:2*pi;
            plot( x_c(1) + r_c*cos(CTheta), x_c(2) + r_c*sin(CTheta), 'r');
            plot(x_opt(1),x_opt(2),'.b','markersize',35);
            pause(1)
            hold off;
        end
        if i == stage
            figure(2);
            stem(w_cvx);
        end
    end
save log;
end
end