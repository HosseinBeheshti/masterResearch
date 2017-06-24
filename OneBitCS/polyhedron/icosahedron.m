function [x,y,z,idface]=icosahedron
% [x,y,z,idface]=icosahedron defines data for an icosahedron
%                having unit volume
c=(1+sqrt(5))/2; 
p=[0,1,c; 0,-1,c; 0,1,-c; 0,-1,-c;
   1,c,0; -1,c,0; 1,-c,0; -1,-c,0;
   c,0,1; -c,0,1; c,0,-1; -c,0,-1];
volume=10*(1+sqrt(5)/3);

% adjust dimensions to give unit volume
p=p/volume^(1/3);

[dum,k]=sort(p(:,3)); p=p(k,:); 
x=p(:,1)'; y=p(:,2)'; z=p(:,3)'; 
idface=[   1 3 2;   2 3 7;   7 8 2;  8 4 2;   1 2 4;
          10 6 4;  10 4 8; 8 12 10; 8 7 12;  12 7 9;
           9 7 3;   3 5 9;   3 1 5;  1 6 5;   1 4 6;
        12 11 10; 12 9 11;  9 5 11; 5 6 11; 6 10 11]; 
volume=10*(1+sqrt(5)/3);