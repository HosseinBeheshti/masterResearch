function [v,vr,vrr,irr,ve,vre,vrre,irre,x,y,z]=sphrprop(nlon,nlat)
% [v,vr,vrr,irr,ve,vre,vrre,irre,x,y,z]=sphrprop(nlon,nlat)
% This function computes inertial properties of a unit sphere using 
% quadrilateral elements which are subdivided into triangles. The
% sphere center is at [0,0,1].

%           HBW, 4/24/10
if nargin==0, nlon=20; nlat=10; end
tlat=linspace(0,pi,nlat+1)';
tlon=linspace(0,2*pi,nlon+1);
x=sin(tlat)*cos(tlon); y=sin(tlat)*sin(tlon);
z=1+cos(tlat)*ones(size(tlon)); 
[v,vr,vrr,irr]=srfvn(x,y,z); 
ve=4/3*pi; vre=ve*[0;0;1]; 
vrre=ve/5*eye(3,3); vrre(3,3)=vrre(3,3)+ve;
irre=eye(3,3)*trace(vrre)-vrre;