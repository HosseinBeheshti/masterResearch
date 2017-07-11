% compute cube
%%
clear;

Rmax    = 8; % upper bound for ||x||
Rmin    = 1; % lower bound for ||x||
L_inf   = Rmax; % upper bound of ||x||_{\inf}

n = 3;
if 1
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

slice_poly = slice(current_Polyhedron,1,1,'keepDim',true);

F = projection(slice_poly,2:3);
disp(volume(F))

current_Polyhedron.plot('alpha',0.2,'color','lightblue'); hold on;
F.plot('color','blue','alpha',0.2,'linestyle','--','linewidth',3);
axis tight;
