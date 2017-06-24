function [v,vr,vrr,irr]=srfvn(x,y,z)
%
% [v,vr,vrr,irr]=srfvn(x,y,z)
% ~~~~~~~~~~~~~~~~~~~~~~
%
% This function computes the volume, centroidal
% coordinates, and inertial tensor for a volume
% covered by surface coordinates contained in
% arrays x,y,z
%
% x,y,z   - matrices containing the coordinates
%           of a grid of points covering the
%           surface of the solid
% v       - volume of the solid
% vr      - integral(r(:)*dVolume)
% vrr     - integral(r(:)*r(:)'*dVolume)
% irr     - inertial tensor for the solid with the
%           mass density taken as unity
%      
%
% User functions called: scatripl proptet
%-----------------------------------------------

[n,m]=size(x); i=1:n-1; I=i+1; j=1:m-1; J=j+1;
xij=x(i,j); yij=y(i,j); zij=z(i,j);
xIj=x(I,j); yIj=y(I,j); zIj=z(I,j);
xIJ=x(I,J); yIJ=y(I,J); zIJ=z(I,J);
xiJ=x(i,J); yiJ=y(i,J); ziJ=z(i,J);

% Tetrahedron volumes
v1=scatripl(xij,yij,zij,xIj,yIj,zIj,xIJ,yIJ,zIJ);
v2=scatripl(xij,yij,zij,xIJ,yIJ,zIJ,xiJ,yiJ,ziJ);
v=sum(sum(v1+v2));

% First moments of volume
X1=xij+xIj+xIJ; X2=xij+xIJ+xiJ;
Y1=yij+yIj+yIJ; Y2=yij+yIJ+yiJ;
Z1=zij+zIj+zIJ; Z2=zij+zIJ+ziJ;
vx=sum(sum(v1.*X1+v2.*X2));
vy=sum(sum(v1.*Y1+v2.*Y2));
vz=sum(sum(v1.*Z1+v2.*Z2));

% Second moments of volume
vrr=proptet(v1,xij,yij,zij,xIj,yIj,zIj,...
    xIJ,yIJ,zIJ,X1,Y1,Z1)+...
    proptet(v2,xij,yij,zij,xIJ,yIJ,zIJ,...
    xiJ,yiJ,ziJ,X2,Y2,Z2);
% vr=[vx;vy;vz]/4; vs=sign(v); MODIFIED 4/29/10
% v=abs(v)/6; vrr=vs*vrr/120;
sv=sign(v); v=sv/6*v; vr=sv/24*[vx;vy;vz];
vrr=sv/120*[vrr([1 4 5]), vrr([4 2 6]), vrr([5 6 3])]';
irr=eye(3,3)*sum(diag(vrr))-vrr; 