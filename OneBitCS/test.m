clear;
close all;
clc;
%%
load log;
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
ply_nrml    = [ply_nrml;1,0.9;-1,-1;-1,1];
ply_ofst    = [ply_ofst; 0.1;0.2;3];
end
current_Polyhedron = Polyhedron(ply_nrml,ply_ofst);
ply_nrml = current_Polyhedron.H(:,(1:end-1));
ply_ofst = current_Polyhedron.H(:,end);
% Analytic center
cvx_begin
variable x(n)
minimize -sum(log(ply_ofst-ply_nrml*x))
%     F*x == g
cvx_end
%%
hold on;
plot(current_Polyhedron,'color','blue','alpha',0.2)
plot(x(1),x(2),'.g','markersize',15);
hold off;
disp(x)

