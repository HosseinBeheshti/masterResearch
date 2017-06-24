function [v,vr,vrr,irr,ve,vre,vrre,irre,x,y,z]=frustum(...
                                                rbot,rtop,zbot,ztop,ncirc)
% [v,vr,vrr,irr,ve,vre,vrre,irre,x,y,z]=frustum(rbot,rtop,zbot,ztop,ncirc)
% This function computes the inertial properties of a conical frustum which
% is symmetrical about the z-axis.
% rbot,rtop   - bottom and top radii of the frustum
% zbot,ztop   - bottom and top base coordinates of the frustum
% ncirc       - number of planar strips used to model the sides of the
%               the polyhedron model
% v,vr,vrr    - volume, first order moment of volume, and second order
%               moment of volume computed for the polyhedral approximation
%             - inertia tensor
% ve,vre,vrre - exact properties of the frustum
% irre        - exact inertia tensor
% x,y,z       - surface coordinates for the approximate polyhedral model

%                       HBW, 4/28/10
if nargin==0
  rbot=1; rtop=.5; zbot=0.; ztop=1.; ncirc=100;
end
u=exp(1i*linspace(0,2*pi,ncirc+1)')*[0,rbot,rtop,0];
x=real(u); y=imag(u); z=ones(ncirc+1,1)*[zbot,zbot,ztop,ztop]; 
[v,vr,vrr]=srfvn(x,y,z); 
irr=eye(3,3)*trace(vrr)-vrr;
if rtop~=rbot 
  [ve,vre,vrre,irre]=frusprope(rbot,rtop,zbot,ztop);
else
  r=rtop; h=ztop-zbot; ve=pi*r^2*h; vze=ve*(ztop+zbot)/2;
  vxxe=v*r^2/4; vzze=v*(h^2/12+(ztop+zbot)^2/4); 
  vre=[0;0;vze]; vrre=diag([vxxe,vxxe,vzze]);
  irre=eye(3,3)*trace(vrre)-vrre;
end