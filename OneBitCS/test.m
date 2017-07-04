% polyhedron volume distribution
%%
close all;
clc;
%%
g = x_ac'./norm(x_ac);
L = 0.1;
ply_volume = zeros(1,10);
hold on;
plot(0,0)
plot(x_ac(1),x_ac(2),'.g','markersize',40);
plot(current_Polyhedron,'color','red','alpha',0.2)
for i = 1:10
    
    hyp1 = norm(x_ac)+L;
    hyp2 = norm(x_ac)-L;
    
    ply_nrml_1 = [ply_nrml ; g ;-g];
    ply_ofst_1 = [ply_ofst ; hyp1 ;hyp2];
    Polyhedron_v = Polyhedron(ply_nrml_1,ply_ofst_1);
    ply_volume(i) = volume(Polyhedron_v);
    
    plot(Polyhedron_v,'color','blue','alpha',0.2)
    pause(0.5)
    
    L = L+0.1;
end
hold off;
%%
% figure(2)
% plot(ply_volume)
