function [u]=boxrota(A,r0,nrot,x,y,z)
% [u]=boxrota(A,r0,nrot,x,y,z) determines the
% coordinate range a set of points traverses
% during rotation
[xmn,xmx,ymn,ymx,zmn,zmx]=bounds(x,y,z);
for k=1:nrot
  [x,y,z]=rotashft(A,r0,x,y,z);
  [umn,umx,vmn,vmx,wmn,wmx]=bounds(x,y,z);
  xmn=min(xmn,umn); xmx=max(xmx,umx);
  ymn=min(ymn,vmn); ymx=max(ymx,vmx);
  zmn=min(zmn,wmn); zmx=max(zmx,wmx);
end
u=[xmn,xmx,ymn,ymx,zmn,zmx];
p=@(x,f)[x(1)-f*(x(2)-x(1)),x(2)+f*(x(2)-x(1))];
u=[p(u(1:2),.05),p(u(3:4),.03),p(u(5:6),.05)]; 