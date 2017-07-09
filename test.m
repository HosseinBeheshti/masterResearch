clear;
close all;
clc;
%%

%%
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
ply_nrml    = [ply_nrml;1,0.9;-1,-1;-1,1];
ply_ofst    = [ply_ofst; -1;7;12];
end
current_Polyhedron = Polyhedron(ply_nrml,ply_ofst);

       ply_nrml = current_Polyhedron.H(:,(1:end-1));
        ply_ofst = current_Polyhedron.H(:,end);
V_cnt = sum(current_Polyhedron.V)./size(current_Polyhedron.V,1);
%%
 cheby_c = chebyCenter(current_Polyhedron);
%%
% Analytic center cvx
cvx_begin
variable x(n)
minimize -sum(log(ply_ofst-ply_nrml*x))
%     F*x == g
cvx_end

%%
hold on;
plot(current_Polyhedron,'color','blue','alpha',0.2)
plot(x(1),x(2),'.g','markersize',15);
plot(V_cnt(1),V_cnt(2),'.r','markersize',15);
plot(cheby_c.x(1),cheby_c.x(2),'.y','markersize',15);
hold off;
disp(x)

