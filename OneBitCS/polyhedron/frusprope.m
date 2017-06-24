function [v,vr,vrr,irr]=frusprope(rb,rt,zb,zt)
% [v,vr,vrr,irr]=frusprope(rb,rt,zb,zt) computes exact
% inertial properties of a frustum when rb~=rt.
if nargin==0
  rb=1; rt=.5; zb=-.5; zt=.5; 
end
s=(rt-rb)/(zt-zb); e=rb-s*zb;
v=pi/3/s*(rt^3-rb^e);
vz=pi*((zt*rt^3-zb*rb^3)/3/s-(rt^4-rb^4)/12/s^2);
vxx=pi*(rt^5-rb^5)/20/s;
vzz=pi*((zt^2*rt^3-zb^2*rb^3)/3/s-...
        (zt*rt^4-zb*rb^4)/6/s^2+(rt^5-rb^5)/30/s^3);
vr=[0;0;vz]; vrr=diag([vxx,vxx,vzz]);
irr=eye(3,3)*trace(vrr)-vrr;