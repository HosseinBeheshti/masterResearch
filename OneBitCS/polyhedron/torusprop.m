function [v,vr,vrr,irr,ve,vre,vrre,irre,x,y,z]=torusprop(a,b,nlat,nlon)
% [v,vr,vrr,irr,ve,vre,vrre,irre,x,y,z]=torusprop(a,b,nlat,nlon)
% Properties of a torus centered at [0,0,1]
if nargin==0, a=2; b=1; nlat=80; nlon=160; end
tlat=linspace(0,2*pi,nlat+1)'; tlon=linspace(0,2*pi,nlon+1);
x=(a+b*cos(tlat))*cos(tlon); y=(a+b*cos(tlat))*sin(tlon);
z=1+sin(tlat)*ones(size(tlon));
[v,vr,vrr,irr]=srfvn(x,y,z); 
ve=2*pi^2*a*b^2; vre=ve*[0,0,1]'; 
vxxe=pi^2*a^3*b^2+3/4*pi^2*a*b^4;
vzze=1/2*pi^2*a*b^4+ve; 
vrre=diag([vxxe,vxxe,vzze]);
irre=eye(3,3)*trace(vrre)-vrre;