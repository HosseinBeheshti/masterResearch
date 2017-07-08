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
       disp(current_Polyhedron.H(:,(1:end-1)));
        disp(current_Polyhedron.H(:,end));
%%
% Analytic center cvx
cvx_begin
variable x(n)
minimize -sum(log(ply_ofst-ply_nrml*x))
%     F*x == g
cvx_end
%%
% Analytic center OPTI
% Objective
fun = @(x) -sum(log(ply_ofst-ply_nrml*x));

% Linear Constraints
A = ply_nrml;
b = ply_ofst;

%Initial Guess
x0 = [0;0];  

% Create OPTI Object
Opt = opti('fun',fun,'ineq',ply_nrml,ply_ofst);

% Solve the MINLP problem
[x,fval,exitflag,info] = solve(Opt,x0)
%%
hold on;
plot(current_Polyhedron,'color','blue','alpha',0.2)
plot(x(1),x(2),'.g','markersize',15);
hold off;
disp(x)

