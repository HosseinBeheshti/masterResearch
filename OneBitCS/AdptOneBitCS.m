function x_adpt = AdptOneBitCS(x_org,n,s,m,L_inf,blk_s,disp_en)
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
    if disp_en==1
        disp(['stage = ',num2str(i)])
    end
    %% measure procedure
    A_temp      = normrnd(0,A_var,blk_s,n);
    Phi_temp    = normrnd(0,Phi_var(i),n,blk_s)+ofset(:,i);
    yp_temp     = A_temp*x_org-sum(A_temp'.*Phi_temp)';
    y_temp      = theta(yp_temp);
    tau_temp    = sum(A_temp'.*Phi_temp)';
    if disp_en==1
        disp('measure procedure')
    end
    %% recovery procedure
    % polyhedron normal and ofset
    A           = [A ; A_temp];
    y           = [y ; y_temp];
    Phi         = [Phi Phi_temp];
    tau         = [tau ; tau_temp];
    ply_nrml    = -y.*A;
    ply_ofst    = -y.*tau;
    if disp_en==1
        [V,nr,nre]=lcon2vert(ply_nrml,ply_ofst);
        save log;
        disp('compute V-polyhedron')
    end
    % compute optimal solution
    cvx_begin quiet;
    variable x_opt(n);
    minimize(norm(x_opt,1));
    subject to
    ply_nrml*x_opt  <= ply_ofst;
    cvx_end
    if disp_en==1
        disp('compute optimal solution')
    end
    % Maximum volume inscribed ellipsoid in a polyhedron
    cvx_begin quiet;
    variable B_mve(n,n) symmetric
    variable d_mve(n)
    maximize( det_rootn( B_mve ) )
    subject to
    for i = 1:length(ply_ofst)
        norm( B_mve*ply_nrml(i,:)', 2 ) + ply_nrml(i,:)*d_mve <= ply_ofst(i);
    end
    cvx_end
    save log;
    if disp_en==1
        disp('compute inscribed ellipsoid')
    end
    lambda_B = svd(B_mve);
    w_cvx(i)        = norm(d_mve);
    ofset(:,i+1)   	= d_mve;
    
    x_adpt          = x_opt;
    
    if ~isnan(w_cvx(i))
        Phi_var(i+1)    =  sqrt(abs(w_cvx(i)));
    else
        Phi_var(i+1)    = Phi_var(i);
    end
    
    
    %% visiual adaptivity
    if disp_en
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
            noangles = 200;
            angles   = linspace( 0, 2 * pi, noangles );
            ellipse_inner  = B_mve * [ cos(angles) ; sin(angles) ] + d_mve * ones( 1, noangles );
            plot(d_mve(1),d_mve(2),'.g','markersize',40);
            plot(x_opt(1),x_opt(2),'.b','markersize',35);
            plot( ellipse_inner(1,:), ellipse_inner(2,:), 'r--' );
            figure(2);
            stem(w_cvx);
            pause(1)
            hold off;
        end
    end
end
save log;
end