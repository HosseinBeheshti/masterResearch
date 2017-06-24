function [x,y,z,idface]=octahedron
% [x,y,z,idface]=octahedron defines polyhedron data for
% an octahedron
d=0.5; h=1/sqrt(2); x=d*[1,1,-1,-1,0,0];
y=d*[-1,1,1,-1,0,0]; z=h*[0,0,0,0,1,-1];
%x=x+1; y=y+1; z=z+1;
idface=[1 2 5;2 3 5;3 4 5; 4 1 5;
        2 1 6;3 2 6;4 3 6; 1 4 6];