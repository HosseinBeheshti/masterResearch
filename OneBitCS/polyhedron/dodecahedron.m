function [x,y,z,idface]=dodecahedron
% [x,y,z,idface]=dodecahedron defines polyhedron data
%                for a dodecahedron with unit volume
p=(1+sqrt(5))/2; q=1/p;
xyz=[ 1, 1 ,1;  1,-1,-1;  1, 1,-1;  1,-1, 1;
     -1, 1, 1; -1,-1,-1; -1, 1,-1; -1,-1, 1;
      0, q, p;  0, q,-p;  0,-q, p;  0,-q,-p;
      q, p, 0;  q,-p, 0; -q ,p, 0; -q,-p, 0;
      p, 0, q;  p, 0,-q; -p, 0, q; -p, 0,-q]; 
volume=(15+7*sqrt(5))/4*(sqrt(5)-1)^3;

% adjust dimensions to give unit volume
xyz=xyz/volume^(1/3);
  
[d,k]=sort(-xyz(:,3)); xyz=xyz(k,:);
x=xyz(:,1); y=xyz(:,2); z=xyz(:,3);
idface=[...
     5     8     6     2     1
    16    19    18    11     9
     8    14    17    12     6
    10    15    13     7     4
    12    17    20    15    10
     2     4     7     3     1
    18    19    20    17    14
     3     9    11     5     1
    11    18    14     8     5
     7    13    16     9     3
     6    12    10     4     2
    15    20    19    16    13];