% polyhedron shape test and volume ratio
%%
close all;
%%
r = randi([1 n],1,3);
volume(current_Polyhedron)
current_PolyhedronP1 = current_Polyhedron.projection(randperm(n,3));
current_PolyhedronP2 = current_Polyhedron.projection(randperm(n,3));
current_PolyhedronP3 = current_Polyhedron.projection(randperm(n,3));
current_PolyhedronP4 = current_Polyhedron.projection(randperm(n,3));
% hold on;
figure(1)
plot(current_PolyhedronP1)
disp(['v1 = ',num2str(volume(current_PolyhedronP1))])

figure(2)
plot(current_PolyhedronP2)
disp(['v2 = ',num2str(volume(current_PolyhedronP2))])

figure(3)
plot(current_PolyhedronP3)
disp(['v3 = ',num2str(volume(current_PolyhedronP3))])

figure(4)
plot(current_PolyhedronP4)
disp(['v4 = ',num2str(volume(current_PolyhedronP4))])
% hold off;

