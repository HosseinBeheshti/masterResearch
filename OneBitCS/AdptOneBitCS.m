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
    if 1
        current_Polyhedron = Polyhedron(ply_nrml,ply_ofst);
        current_Polyhedron = current_Polyhedron.computeVRep;
        Vply            = current_Polyhedron.V;
        A_center        = sum(Vply)./(size(Vply,1));
        dist            = zeros(size(Vply,1)+1,1);
        for i = 1:size(Vply,1)
            dist(i)     = norm(A_center-Vply(i,:));
        end
        A_radious       = max(dist);
        disp('compute MTP3 polyhedron')
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
   
    % next stage parameter
    w_cvx(i)        = A_radious;
    Phi_var(i+1)    =  w_cvx(i);
    ofset(:,i+1)   	= A_center;
    
    x_adpt          = x_opt;
    %% visiual adaptivity
    if 1
        hold on;
        if n==2
            plot(current_Polyhedron,'color','blue','alpha',0.2,'linestyle','--')
        end
        if n==3
            plot(current_Polyhedron,'color','blue','alpha',0.2,'linestyle','--')
        end
        if i== stage
            hold off;
        end
    end
end
save log;
end