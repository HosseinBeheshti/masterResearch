% polyhedron volume distribution
%%
close all;
clc;
load log;
%%
g = normrnd(0,1,1,n);
g = g./norm(g);
L = 1;
%% compute distance of center hyperplane

xd          = sdpvar(n,1);
x_c_hypln   = [g*(xd-x_ac) == 0];
o           = zeros(n,1);
S           = YSet(xd,x_c_hypln);
dst         = distance(S,o);
% disp(dst)


%%
ply_volume = zeros(1,10);
figure(2)
hold on;
s = current_Polyhedron.chebyCenter;
plot(x_ac(1),x_ac(2),'.g','markersize',20);
plot(s.x(1),s.x(2),'.b','markersize',20);

plot(current_Polyhedron,'color','red','alpha',0.2)

for i = 1:1

    hyp1 = dst.dist+L;
    hyp2 = dst.dist-L;

    
    ply_nrml_1 = [ply_nrml ;-g;g];
    ply_ofst_1 = [ply_ofst ;hyp1;hyp2];
    Polyhedron_v = Polyhedron(ply_nrml_1,ply_ofst_1);
    ply_volume(i) = volume(Polyhedron_v);
    plot(a(1),a(2),'.g','markersize',20);
    plot(b(1),b(2),'.b','markersize',20);
    plot(Polyhedron_v,'color','blue','alpha',0.2)
    
    pause(0.5)
    
    L = L+1;
end
hold off;
%%
% figure(2)
% plot(ply_volume)
