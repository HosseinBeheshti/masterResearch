% polyhedron shape test and volume ratio
%%
close all;

Ply = Polyhedron(ply_nrml,ply_ofst);
disp(volume(Ply));
plot(Ply)
%%
Q = getFacet(Ply)
c_center =  chebyCenter(Ply)
VPly =  computeVRep(Ply)
