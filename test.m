% compute cube
%%
clear;

load log;
if 0
    % l_{\inf} polyhedron
    ATemp       = kron(eye(n),ones(2,1));
    PhiTemp     = L_inf.*kron(eye(n),[1; -1])';
    tauTemp     = sum(ATemp'.*PhiTemp)';
    yTemp       = theta(tauTemp);
    
    A           = ATemp;
    Phi         = PhiTemp;
    tau         = tauTemp;
    y           = -yTemp;
    
    ply_nrml    = -y.*A;
    ply_ofst    = -y.*tau;
end
current_Polyhedron = Polyhedron(ply_nrml,ply_ofst);
%%
% % test_poly = slice
%%
close all;
sweep_d = -L_inf:2:L_inf;
Volume_clt = zeros(n,length(sweep_d));
dim_vec     = 1:n;
if n==2 || n==3
    figure(1)
    plot(current_Polyhedron,'color','blue','alpha',0.1)
end
figure(2)
hold on;
for i = 1:n
    for k =1:length(sweep_d)
        slice_poly = slice(current_Polyhedron,i,sweep_d(k),'keepDim',true);
        dim_proj = [dim_vec(1:i-1) dim_vec(i+1:n)];
        F = projection(slice_poly,dim_proj);
        Volume_clt(i,k) = volume(F);
    end
    plot(Volume_clt(i,:))
end
hold off;

volume(current_Polyhedron)
