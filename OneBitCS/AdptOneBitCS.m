function x_adpt = AdptOneBitCS(x_org,n,s,m,L_inf,blk_s,disp_en)
stage       = ceil(m/blk_s);
A_var       = 1;
Phi_var     = 5*ones(stage,1);
w_cvx       = zeros(1,stage);
ofset       = zeros(n,stage);
% l_{\inf} polyhedron
ATemp       = kron(eye(n),ones(2,1));
PhiTemp     = L_inf.*kron(eye(n),[1; -1])';
tauTemp     = sum(ATemp'.*PhiTemp)';
yTemp       = tauTemp;

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
        disp('measure procedure ended')
    end
    %% recovery procedure
    % polyhedron normal and ofset
    A           = [A ; A_temp];
    y           = [y ; y_temp];
    Phi         = [Phi Phi_temp];
    tau         = [tau ; tau_temp];
    ply_nrml    = -y.*A;
    ply_ofst    = -y.*tau;
    if 1
        current_Polyhedron = Polyhedron(ply_nrml,ply_ofst);
        disp('MPT3 polyhedron computed')
    end
    
    % Compute optimal solution
    cvx_begin quiet;
    variable x_opt(n);
    minimize(norm(x_opt,1));
    subject to
    ply_nrml*x_opt  <= ply_ofst;
    cvx_end
    if disp_en==1
        disp('optimal solution computed')
    end
    
    % Computing Analytic center
    cvx_begin quiet;
    variable x_ac(n);
    minimize -sum(log(ply_ofst-ply_nrml*x_ac));
    cvx_end
    if disp_en==1
        disp('Analytic center computed')
    end
    
    % Computing Gaussian width
    E_W_size    = 10;
    w_cvx_temp  = zeros(1,E_W_size);
    for k = 1:E_W_size
        g = normrnd(0,1,1,n);
        % sup
        cvx_begin quiet;
        variable w_s(n);
        maximize g*w_s;
        subject to
        ply_nrml*w_s  <= ply_ofst;
        cvx_end
        % inf
        cvx_begin quiet;
        variable w_i(n);
        minimize g*w_i;
        subject to
        ply_nrml*w_i  <= ply_ofst;
        cvx_end
        % average
        w_cvx_temp(k)  = norm(abs(w_s-w_i));
    end
    if disp_en==1
        disp('Gaussian width computed')
    end    
    
    
    % next stage parameter
    w_cvx(i)        = sum(w_cvx_temp')./E_W_size;
    Phi_var(i+1)    = w_cvx(i);
    ofset(:,i+1)   	= x_ac;
    
    x_adpt          = x_opt;
    %% visiual adaptivity
    if n==2 || n==3
        if i== 1
            hold on;
        end
        if n==2
            plot(current_Polyhedron,'color','blue','alpha',0.2)
            plot(x_ac(1),x_ac(2),'.g','markersize',40);
            plot(w_s(1),w_s(2),'*r','markersize',15);
            plot(w_i(1),w_i(2),'*r','markersize',15);
        end
        if n==3
            plot(current_Polyhedron,'color','blue','alpha',0.2)
            plot3(x_ac(1),x_ac(2),x_ac(3),'.g','markersize',40);
            plot3(w_s(1),w_s(2),w_s(3),'*r','markersize',15);
            plot3(w_i(1),w_i(2),w_i(3),'*r','markersize',15);
        end
        if i== stage
            hold off;
        end
    end
end
save log;
end