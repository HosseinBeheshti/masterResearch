% polyhedron shape test and volume ratio
clear;
clc;
close all;
%%
n       = 20;
cube    = 0;

if cube == 1
    % l_{\inf} polyhedron
    ATemp       = kron(eye(n),ones(2,1));
    PhiTemp     = kron(eye(n),[1; -1])';
    tauTemp     = sum(ATemp'.*PhiTemp)';
    yTemp       = tauTemp;
    A           = ATemp;
    Phi         = PhiTemp;
    tau         = tauTemp;
    y           = -yTemp;
else
    
    a=2;
end


ply_nrml    = -y.*A;
ply_ofst    = -y.*tau;

cd('./polytopes');
[V,nr,nre]=lcon2vert(ply_nrml,ply_ofst);
cd('../');

%%
% Maximum volume inscribed ellipsoid in a polyhedron
cvx_begin;
variable B_mve(n,n) symmetric
variable d_mve(n)
maximize( det_rootn( B_mve ) )
subject to
for k = 1:length(ply_ofst)
    norm( B_mve*ply_nrml(k,:)', 2 ) + ply_nrml(k,:)*d_mve <= ply_ofst(k);
end
cvx_end

lambda_B = svds(B_mve);