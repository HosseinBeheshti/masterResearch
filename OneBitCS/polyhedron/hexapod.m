function [x,y,z,idface]=hexapod
% [x,y,z,idface]=hexapod defines polyhedron
% data for a solid with six legs
a=1; b=3; c=a+b;
p=[ -a,a,-a; -a,-a,-a; -a,a,a; -a,-a,a;
     a,a,-a;  a,-a,-a;  a,a,a;  a,-a,a;
    -c,a,-a; -c,-a,-a; -c,a,a; -c,-a,a;
   -a,-c,-a;  a,-c,-a; a,-c,a; -a,-c,a;
    -a,c,-a;   a,c,-a;  a,c,a;  -a,c,a;
   -a,-a,-c;  a,-a,-c; a,a,-c; -a,a,-c;
     -a,a,c;  -a,-a,c; a,-a,c;   a,a,c;
    c,-a,-a;   c,a,-a;  c,a,a;  c,-a,a]; 
x=p(:,1); y=p(:,2); z=p(:,3);
idface=[ 9 10 12 11;   2 4 12 10; 12 4 3 11;  11 3 1 9;  2 10 9 1;
        22 21 24 23;   2 1 24 21; 21 22 6 2; 5 6 22 23; 1 5 23 24;
        25 26 27 28;   27 26 4 8; 3 4 26 25; 28 27 8 7; 25 28 7 3;
          2 13 16 4; 16 13 14 15; 2 6 14 13; 8 15 14 6; 4 16 15 8;
        20 19 18 17;   1 3 20 17; 7 19 20 3; 19 7 5 18; 5 1 17 18;
        30 31 32 29;   7 31 30 5; 7 8 32 31; 6 29 32 8; 5 30 29 6];