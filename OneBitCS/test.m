% polyhedron shape test and volume ratio
%% chebyCenter
X_cheby = chebyCenter(current_Polyhedron);
ply_volume = volume(current_Polyhedron);
inscribed_ball = (X_cheby.r^n)*(pi^(n/2))/gamma(n/2+1);
%% analytic center
Vply = current_Polyhedron.V;
A_center = sum(Vply)./(size(Vply,1));
dist    = zeros(size(Vply,1)+1,1);
for i = 1:size(Vply,1)
    dist(i) = norm(A_center-Vply(i,:));
end
A_radious = max(dist);
circumscribed_ball = (A_radious^n)*(pi^(n/2))/gamma(n/2+1);
%% disp volume
volume_ratio1 = inscribed_ball/ply_volume
volume_ratio2 = circumscribed_ball/ply_volume
disp(['ply_volume = ',num2str(ply_volume)])
disp(['b2_volume = ',num2str(inscribed_ball)])
%%
sub1    = randperm(n,3);
sub2    = randperm(n,3);
sub3    = randperm(n,3);
sub4    = randperm(n,3);



current_PolyhedronP1 = current_Polyhedron.projection(sub1);
current_PolyhedronP2 = current_Polyhedron.projection(sub2);
current_PolyhedronP3 = current_Polyhedron.projection(sub3);
current_PolyhedronP4 = current_Polyhedron.projection(sub4);
%%
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

