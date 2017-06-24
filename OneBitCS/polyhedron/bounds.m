function [ xmn,xmx,ymn,ymx,zmn,zmx ] = bounds(x,y,z)
% [ xmn,xmx,ymn,ymx,zmn,zmx ] = bounds(x,y,z)
% determines the range of coordinates in arrays x,y,z
xmn=min(x(:)); xmx=max(x(:)); ymn=min(y(:)); ymx=max(y(:));
zmn=min(z(:)); zmx=max(z(:)); 