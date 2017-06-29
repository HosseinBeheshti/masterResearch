% polyhedron shape test and volume ratio
%%
sub1    = randperm(n,3);
sub2    = randperm(n,3);
sub3    = randperm(n,3);
sub4    = randperm(n,3);

volume(current_Polyhedron)

current_PolyhedronP1 = current_Polyhedron.projection(sub1);
current_PolyhedronP2 = current_Polyhedron.projection(sub2);
current_PolyhedronP3 = current_Polyhedron.projection(sub3);
current_PolyhedronP4 = current_Polyhedron.projection(sub4);

disp(['v1 = ',num2str(volume(current_PolyhedronP1))])
disp(['v2 = ',num2str(volume(current_PolyhedronP2))])
disp(['v3 = ',num2str(volume(current_PolyhedronP3))])
disp(['v4 = ',num2str(volume(current_PolyhedronP4))])

%%
close all;
figure(1)
plot(current_PolyhedronP1,'color','blue','alpha',0.2,'linestyle','--')
figure(2)
plot(current_PolyhedronP2,'color','blue','alpha',0.2,'linestyle','--')
figure(3)
plot(current_PolyhedronP3,'color','blue','alpha',0.2,'linestyle','--')
figure(4)
plot(current_PolyhedronP4,'color','blue','alpha',0.2,'linestyle','--')

