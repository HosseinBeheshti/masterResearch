function [x,y,z]=rotashft(A,r0,x,y,z)
% [x,y,z]=rotashft(A,r0,x,y,z) determines the
% new position of a set of points assumes by
% rotation about an axis centered at r0
s=size(x); u=[x(:),y(:),z(:)]';
u0=r0(:)*ones(1,size(u,2)); 
u=u0+A*(u-u0); x=reshape(u(1,:),s);
y=reshape(u(2,:),s); z=reshape(u(3,:),s); 