% polyhedron volume distribution
%%
close all;
clc;
load log
%%
g = x_ac'./norm(x_ac);

L = 0.01;

ply_volume = zeros(1,10);
hold on;

plot(x_ac(1),x_ac(2),'.y','markersize',40);
plot(current_Polyhedron,'color','red','alpha',0.2)

for i = 1:10
    a = x_ac-L.*g';
    b = x_ac+L.*g';
    hyp1 = norm(a);
    hyp2 = norm(b);
    n1 = a./hyp1;
    n2 = b./hyp2;
    
    ply_nrml_1 = [ply_nrml ; n1'];
    ply_ofst_1 = [ply_ofst ; hyp1];
    Polyhedron_v = Polyhedron(ply_nrml_1,ply_ofst_1);
    ply_volume(i) = volume(Polyhedron_v);
    plot(a(1),a(2),'.g','markersize',20);
    plot(b(1),b(2),'.b','markersize',20);
    plot(Polyhedron_v,'color','blue','alpha',0.2)

    pause(0.5)
    
    L = L+0.01;
end
hold off;
%%
% figure(2)
% plot(ply_volume)
