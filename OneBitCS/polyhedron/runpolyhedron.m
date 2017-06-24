function runpolyhedron
% runpolyhedron
% This program computes the volume, first moment of volume, and
% inertia tensor of several polyhedra and bodies with curved
% surfaces which can be approximated well using triangular
% patches. Two utility functions employed are polyhedrn for any
% polyhedron indexed by corner coordinates and srfvn for bodies
% having surface coordinates compatible with the intrinsic MATLAB
% function surf(x,y,z). For more detail, see 'Advanced Mathematics
% and Mechanics Applications Using MATLAB', 3rd Ed.,2003, CRC Press,
% by H. Wilson, L. Turcotte, and D. Halpern.  

%        written by Howard Wilson, 10/24/10
clc; close, clear
disp('INERTIAL PROPERTIES OF ARBITRARY POLYHEDRA')
disp(' ')
while 1
  disp(' PROGRAM OPTIONS :')
  disp(' 1 - Triangular Block  2 - Hexapod          3 - Octahedron')
  disp(' 4 - Icosahedron       5 - Dodecahedron     6 - Conical Frustum')  
  disp(' 7 - Sphere            8 - Torus            9 - Instructions')
  disp('10 - Exit')
  disp(' ')
  opt=input('Input an option : '); 
  if opt>10, disp('Invalid option'), continue, end
  if opt==10, clc, disp('All Done'), return, end 
  runexamples(opt)
  disp(' '), disp('Press return to continue'), pause, close, clc
end

function runexamples(ncase)
% runexamples(ncase) runs eight different test examples for the
% polyhedron program 

ns=@(x,ndig)num2str(x,ndig); nd=8; Ns=@(x)num2str(x);
switch ncase
    case 1
titl='TRIANGULAR BLOCK WITH A HOLE'; disp(' ')
disp(['THE SOLID IS A ',titl])
[xtb,ytb,ztb,idftb]=triablock; 
[v,rc,vrr,irr]=polhedrn(xtb,ytb,ztb,idftb); r=rc';
disp(' '), disp(['Volume = ',ns(v,nd)]); 
disp(' '), disp(['Centroidal Radius = ',dispv(rc)]);
disp(' '), disp('Inertia Tensor ='), disp(ns(irr,nd)) 
rph(xtb,ytb,ztb,idftb,360,180,[0 0 1],[0,2,0],titl,[1 1 0])

    case 2 
titl='HEXAPOD'; disp(' ')
disp(['THE SOLID IS A ',titl])
[xhp,yhp,zhp,idfhp]=hexapod;
[v,rc,vrr,irr]=polhedrn(xhp,yhp,zhp,idfhp); r=rc';
disp(' '), disp(['Volume = ',ns(v,nd)]); 
disp(' '), disp(['Centroidal Radius = ',dispv(rc)]);
disp(' '), disp('Inertia Tensor ='), disp(ns(irr,nd)) 
rph(xhp,yhp,zhp,idfhp,180,90,[0 0 1],[0,0,0],titl,[1 1 0])

    case 3
titl='REGULAR OCTAHEDRON WITH EDGE LENGTH = 1'; disp(' ')
disp(['THE SOLID IS A ',titl])
[xoh,yoh,zoh,idfoh]=octahedron;
[v,rc,vrr,irr]=polhedrn(xoh,yoh,zoh,idfoh); r=rc';
disp(' '), disp(['Volume = ',ns(v,nd)]); 
disp(' '), disp(['Centroidal Radius = ',dispv(r)]);
disp(' '), disp('Inertia Tensor ='), disp(ns(irr,nd)) 
rph(xoh,yoh,zoh,idfoh,180,90,[0 0 1],[0 0 0],titl,[1 1 0])

    case 4
titl='REGULAR ICOSAHEDRON OF UNIT VOLUME'; disp(' ')
disp(['THE SOLID IS A ',titl])
[xih,yih,zih,idfih]=icosahedron;
[v,rc,vrr,irr]=polhedrn(xih,yih,zih,idfih); r=rc';
[dumy,k]=max(zih); eln=2*yih(k);
disp(' '), disp(['Volume = ',ns(v,nd),',   EDGE LENGTH = ',ns(eln,nd)]); 
disp(' '), disp(['Centroidal Radius = ',dispv(rc)]);
disp(' '), disp('Inertia Tensor ='), disp(ns(irr,nd)) 
rph(xih,yih,zih,idfih,180,90,[0 0 1],[0 0 0],titl,[1 1 0])

    case 5
titl='REGULAR DODECAHEDRON OF UNIT VOLUME'; disp(' ')
disp(['THE SOLID IS A ',titl])
[xdh,ydh,zdh,idfdh]=dodecahedron;
[dumy,k]=max(zdh); eln=2*ydh(k);
[v,rc,vrr,irr]=polhedrn(xdh,ydh,zdh,idfdh); r=rc'; 
disp(' '), disp(['Volume = ',ns(v,nd),',   EDGE LENGTH = ',ns(eln,nd)]); 
disp(' '), disp(['Centroidal Radius = ',dispv(rc)]);
disp(' '), disp('Inertia Tensor ='), disp(ns(irr,nd)) 
rph(xdh,ydh,zdh,idfdh,180,90,[0 0 1],[0 0 0],titl,[1 1 0])

    case 6
rbot=1; rtop=.5; zbot=-.5; ztop=.5; ncirc=50;         
titl=['FRUSTUM USING ',num2str(ncirc),' SIDE ELEMENTS']; disp(' ')
disp(['THE SOLID IS A ',titl]) 
[v,vr,vrr,irr,ve,vre,vrre,irre,xcf,ycf,zcf]=...
    frustum(rbot,rtop,zbot,ztop,ncirc); 
rc=vr(:)'/v; rce=vre'/ve; drc=rc-rce; dv=v-ve; dirr=irr-irre;
disp(' '), disp(['Volume = ',ns(v,nd)]); disp(' ')
disp(['Volume-VolumeExact = ',Ns(dv)]) 
disp(' '), disp(['Centroidal Radius = ',dispv(rc)]); disp(' ')
disp(['norm(CentroidalRadius-CentroidalRadiusExact) = ',...
Ns(norm(drc))])
disp(' '), disp('Inertia Tensor ='), disp(ns(irr,nd)),disp(' ')
disp(['norm(InertiaTensor-InertiaTensorExact) =',Ns(norm(dirr))])  
rph(xcf,ycf,zcf,0,360,180,[1 0 0],[0 0 0],titl,[1 1 0])

    case 7
nlon=50; nlat=25;        
titl=['SPHERE USING ',num2str(nlon*nlat),' SURFACE ELEMENTS'];
disp(' '), disp(['THE SOLID IS A ',titl])
[v,vr,vrr,irr,ve,vre,vrre,irre,xsp,ysp,zsp]=sphrprop(nlon,nlat); 
rc=vr'/v; rce=vre'/ve; drc=rc-rce; dv=v-ve;
disp(' '), disp(['Volume = ',ns(v,nd)]); disp(' ')
disp(['Volume-VolumeExact = ',Ns(dv)]) 
disp(' '), disp(['Centroidal Radius = ',dispv(rc)]); disp(' ')
disp(['norm(CentroidalRadius-CentroidalRadiusExact) = ',...
Ns(norm(drc))])
disp(' '), disp('Inertia Tensor ='), disp(Ns(irr))
dirr=irr-irre; disp(' ') 
disp(['norm(InertiaTensor-InertiaTensorExact) =',Ns(norm(dirr))]) 
rph(xsp,ysp,zsp,0,180,90,[1 0 0],[0 0 1],titl,[1 1 0])

    case 8
%a=2; b=1; nlat=80; nlon=160;        
a=2; b=1; nlat=40; nlon=nlat*ceil(1+a/b);        
titl=['TORUS USING ',Ns(nlat*nlon),' SURFACE ELEMENTS'];
disp(' '), disp(['THE SOLID IS A ',titl])
[v,vr,vrr,irr,ve,vre,vrre,irre,xto,yto,zto]=torusprop(a,b,nlat,nlon);
rc=vr'/v; rce=vre'/ve; drc=rc-rce; disp(' '), dv=v-ve;
disp(['Volume             = ',Ns(v)]), disp(' ')
disp(['Volume-VolumeExact = ',Ns(dv)]), disp(' ')
%disp(['Centroidal Radius = [',Ns(rc),']']); disp(' ')
disp(['Centroidal Radius = ',dispv(rc)]); disp(' ')
disp(['norm(CentroidalRadius-CentroidalRadiusExact) = ',...
Ns(norm(drc))])
disp(' '), disp('Inertia Tensor ='), disp(Ns(irr))
dirr=irr-irre; disp(' ') 
disp(['norm(InertiaTensor-InertiaTensorExact) =',Ns(norm(dirr))]) 
rph(xto,yto,zto,0,180,90,[1 0 0],[0 0 1],titl,[1 1 0])

    case 9
clc, explain  

    otherwise
disp('Invalid case number'), return
end %switch case

function surfplot(x,y,z,titl,colr)
% surfplot(x,y,z,titl,colr)    
if nargin<5, colr=[1 1 0]; end    
hold off, surf(x,y,z), axis equal, title(titl)  
xlabel('x-axis'),ylabel('y-axis'), zlabel('z-axis')
colormap(colr), winposn; shg

function winposn(xlft,ybot,width,height)
% winposn(xlft,ybot,width,height) positions the graphics
% window to prevent overwrite of text
if nargin==0, xlft=.45; ybot=.3; width=.4; height=.6; end
u=get(gcf,'units'); r=[xlft,ybot,width,height];
set(gcf,'units','normalized','outerposition',r);
set(gcf,'units',u); shg

function polhdplt(x,y,z,idface,titl,colr)
%
% polhdplt(x,y,z,idface,titl,colr)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~
%
% This function makes a surface plot of an 
% arbitrary polyhedron.
%
% x,y,z  - vectors containing the corner 
%          indices of the polyhedron
% idface - a matrix in which row j defines the 
%          corner indices of the j'th face. 
%          Each face is traversed in a 
%          counterclockwise sense relative to 
%          the outward normal. The column 
%          dimension equals the largest number 
%          of indices needed to define a face. 
%          Rows requiring fewer than the 
%          maximum number of corner indices are 
%          padded with zeros on the right.
% titl     character variable for the figure title.
%          Default is 'POLYHEDRON PLOT'.
% colr   - character string or a vector 
%          defining the surface color
%
% User m functions called: cubrange
%----------------------------------------------

if nargin<6, colr='y'; end
if nargin<5, titl='POLYHEDRON PLOT'; end
hold off, close; nf=size(idface,1);

for k=1:nf
  i=idface(k,:); i=i(find(i>0));
  xi=x(i); yi=y(i); zi=z(i);
  fill3(xi,yi,zi,colr); hold on;
end

xlabel('x axis'); ylabel('y axis');
zlabel('z axis'); title(titl)
axis equal, v=cubrange([x(:),y(:),z(:)],1.1); 
axis(v); grid on;
hold off, winposn; shg    

function [v,rc,vrr,irr]=polhedrn(x,y,z,idface)
%
% [v,rc,vrr,irr]=polhedrn(x,y,z,idface)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%
% This function determines the volume, 
% centroidal coordinates and inertial moments 
% for an arbitrary polyhedron.
%
% x,y,z  - vectors containing the corner 
%          indices of the polyhedron
% idface - a matrix in which row j defines the 
%          corner indices of the j'th face. 
%          Each face is traversed in a 
%          counterclockwise sense relative to 
%          the outward normal. The column 
%          dimension equals the largest number 
%          of indices needed to define a face. 
%          Rows requiring fewer than the 
%          maximum number of corner indices are 
%          padded with zeros on the right.
%
% v      - the volume of the polyhedron
% rc     - the centroidal radius
% vrr    - the integral of R*R'*d(vol)
% irr    - the inertia tensor for a rigid body
%          of unit mass obtained from vrr as 
%          eye(3,3)*sum(diag(vrr))-vrr
%
% User m functions called: pyramid
%----------------------------------------------

r=[x(:),y(:),z(:)]; nf=size(idface,1); 
v=0; vr=0; vrr=0;
for k=1:nf
  i=idface(k,:); i=i(find(i>0));
  [u,ur,urr]=pyramid(r(i,:)); 
  v=v+u; vr=vr+ur; vrr=vrr+urr;
end
rc=vr/v; irr=eye(3,3)*sum(diag(vrr))-vrr;

function [v,vr,vrr,h,area,n]=pyramid(r)
%
% [v,vr,vrr,h,area,n]=pyramid(r)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%
% This function determines geometrical 
% properties of a pyramid with the apex at the 
% origin and corner coordinates of the base 
% stored in the rows of r.
%
% r    - matrix containing the corner 
%        coordinates of a polygonal base stored 
%        in the rows of matrix r.
%
% v    - the volume of the pyramid
% vr   - the first moment of volume relative to
%        the origin
% vrr  - the second moment of volume relative
%        to the origin
% h    - the pyramid height
% area - the base area
% n    - the ourward directed unit normal to
%        the base
%
% User m functions called: crosmat, polyxy
%----------------------------------------------

ns=size(r,1); 
if ns==3 & abs(det(r))<1000*eps*max(abs(r(:)))
  v=0; vr=zeros(3,1); vrr=zeros(3,3);
  h=0; area=0; n=vr; return;
end
na=sum(crosmat(r,r([2:ns,1],:)))'/2;
%na=sum(cross(r,r([2:ns,1],:)))'/2;
area=norm(na); n=na/area; p=null(n'); 
i=p(:,1); j=p(:,2);
if det([p,n])<0, j=-j; end;
r1=r(1,:); rr=r-r1(ones(ns,1),:); 
x=rr*i; y=rr*j;
[areat,xc,yc,axx,axy,ayy]=polyxy(x,y);
rc=r1'+xc*i+yc*j; h=r1*n; 
v=h*area/3; vr=v*3/4*rc;
axx=axx-area*xc^2; ayy=ayy-area*yc^2; 
axy=axy-area*xc*yc;
vrr=h/5*(area*rc*rc'+axx*i*i'+ayy*j*j'+ ...
    axy*(i*j'+j*i'));

function [area,xbar,ybar,axx,axy,ayy]=polyxy(x,y)
%
% [area,xbar,ybar,axx,axy,ayy]=polyxy(x,y)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%
% This function computes the area, centroidal 
% coordinates, and inertial moments of an 
% arbitrary polygon.
% 
% x,y       - vectors containing the corner 
%             coordinates. The boundary is 
%             traversed in a counterclockwise 
%             direction
%
% area      - the polygon area
% xbar,ybar - the centroidal coordinates
% axx       - integral of x^2*dxdy
% axy       - integral of xy*dxdy
% ayy       - integral of y^2*dxdy 
%
% User m functions called: none
%----------------------------------------------

n=1:length(x); n1=n+1; 
x=[x(:);x(1)]; y=[y(:);y(1)];
a=(x(n).*y(n1)-y(n).*x(n1))'; 
area=sum(a)/2; a6=6*area;
xbar=a*(x(n)+x(n1))/a6; ybar=a*(y(n)+y(n1))/a6;
ayy=a*(y(n).^2+y(n).*y(n1)+y(n1).^2)/12;
axy=a*(x(n).*(2*y(n)+y(n1))+x(n1).* ...
    (2*y(n1)+y(n)))/24;
axx=a*(x(n).^2+x(n).*x(n1)+x(n1).^2)/12;

function rph(x,y,z,idface,angl,nstp,n,r0,titl,colr)
% rph(x,y,z,idface,angl,nstp,n,r0,titl,colr)
% This function plots the rotation of a polyhedron or a surface described
% by function surf(x,y,z). The rotation axis and the center of rotation
% are arbitrary.
%
% x,y,z  - arrays containing either corner coordinates of a polyhedron or 
%          point arrays for use by surf(x,y,z)
% idface - parameter giving face indices of a polyhedron, or a zero value 
%          to indicate data used by surf(x,y,z). For polyhedron data, 
%          idface(i,j) gives the j'th corner index for face i. Each face
%          is traversed counterclockwise relative to the outward normal.
%          The column dimension of idface equals the largest number of
%          of indices needed to define a face. Rows with fewer than the
%          maximum number of corner indices are padded on the right with 
%          zeros.
% angl   - total rotation angle in degrees. If this value is zero, then 
%          only the static initial position of the geometry is shown.
% nstp   - number of rotation increments (only used if angl is nonzero) 
% titl     character variable for the figure title. The default value for
%          titl is 'POLYHEDRON PLOT'.
% colr   - a vector defining the colormap for the surface.
% n      - direction vector for the rotation axis
% r0     - vector defining the origin of the rotation axes

% 
%----------------------------------------------

%          HBW, 5/25/10

if nargin<10, colr=[1 1 0]; end
if nargin<9, titl='ROTATING POLYHEDRON'; end
if nargin<7, angl=360; nstp=180; end
if nargin<6
  [x,y,z,idface]=triablock; n=[0 0 1]; r0=[0 2 0];
end 

% Obtain the rotation matrix
if angl~=0
  A=rotamat(n,angl/nstp);
% Transform to the starting position
  [x,y,z]=rotashft(A,r0,x,y,z);
  [xyz]=boxrota(A,r0,nstp,x,y,z);
else
  A=eye(3,3); nstp=1; [xyz]=boxrota(A,r0,nstp,x,y,z);
end

% Perform step by step rotation
hold off, close; nf=size(idface,1);
for j=1:nstp
  if idface(1)==0
    surf(x,y,z); colormap(colr);
  else
    for k=1:nf    
      i=idface(k,:); i=i(find(i>0));
      xi=x(i); yi=y(i); zi=z(i);
      fill3(xi,yi,zi,colr); hold on;
    end
  end
  [x,y,z]=rotashft(A,r0,x,y,z); 
  xlabel('x axis'); ylabel('y axis');
  zlabel('z axis'); title(titl) 
  axis equal, axis(xyz); grid on; 
  %hold off, winposn; shg    
  hold off, winposn; shg, pause(.01)
end

function A=rotamat(n,theta)
% A=rotamat(n,theta) gives the matrix to rotate a vector
% through angle theta about the direction of vector n
n=n(:)/norm(n); theta=theta*pi/180;
A=cos(theta)*eye(3,3)+(1-cos(theta))*n*n'+...
  sin(theta)*[0,-n(3),n(2);n(3),0,-n(1);-n(2),n(1),0];

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

function [x,y,z]=rotashft(A,r0,x,y,z)
% [x,y,z]=rotashft(A,r0,x,y,z) determines the
% new position of a set of points assumes by
% rotation about an axis centered at r0
s=size(x); u=[x(:),y(:),z(:)]';
u0=r0(:)*ones(1,size(u,2)); 
u=u0+A*(u-u0); x=reshape(u(1,:),s);
y=reshape(u(2,:),s); z=reshape(u(3,:),s); 

function [ xmn,xmx,ymn,ymx,zmn,zmx ] = bounds(x,y,z)
% [ xmn,xmx,ymn,ymx,zmn,zmx ] = bounds(x,y,z)
% determines the range of coordinates in arrays x,y,z
xmn=min(x(:)); xmx=max(x(:)); ymn=min(y(:)); ymx=max(y(:));
zmn=min(z(:)); zmx=max(z(:)); 

function [x,y,z,idface]=triablock
% [x,y,z,idface]=triablock returns corner coordinate and 
% face data for a triangular block with a triangular hole
x=[2 2 2 2 2 2 0 0 0 0 0 0]-1;
y=[0 4 4 2 3 3 0 4 4 2 3 3];
z=[0 0 4 1 1 2 0 0 4 1 1 2];
idface=[1  2  3  6  5  4  6  3;
        1  3  9  7  0  0  0  0;
        1  7  8  2  0  0  0  0;
        2  8  9  3  0  0  0  0;
        7  9 12 10 11 12  9  8;
        4 10 12  6  0  0  0  0;
        4  5 11 10  0  0  0  0;
        5  6 12 11  0  0  0  0];

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
    
function [x,y,z,idface]=octahedron
% [x,y,z,idface]=octahedron defines polyhedron data for
% an octahedron
d=0.5; h=1/sqrt(2); x=d*[1,1,-1,-1,0,0];
y=d*[-1,1,1,-1,0,0]; z=h*[0,0,0,0,1,-1];
%x=x+1; y=y+1; z=z+1;
idface=[1 2 5;2 3 5;3 4 5; 4 1 5;
        2 1 6;3 2 6;4 3 6; 1 4 6];
    
function [x,y,z,idface]=icosahedron
% [x,y,z,idface]=icosahedron defines data for an icosahedron
%                having unit volume
c=(1+sqrt(5))/2; 
p=[0,1,c; 0,-1,c; 0,1,-c; 0,-1,-c;
   1,c,0; -1,c,0; 1,-c,0; -1,-c,0;
   c,0,1; -c,0,1; c,0,-1; -c,0,-1];
volume=10*(1+sqrt(5)/3);

% adjust dimensions to give unit volume
p=p/volume^(1/3);

[dum,k]=sort(p(:,3)); p=p(k,:); 
x=p(:,1)'; y=p(:,2)'; z=p(:,3)'; 
idface=[   1 3 2;   2 3 7;   7 8 2;  8 4 2;   1 2 4;
          10 6 4;  10 4 8; 8 12 10; 8 7 12;  12 7 9;
           9 7 3;   3 5 9;   3 1 5;  1 6 5;   1 4 6;
        12 11 10; 12 9 11;  9 5 11; 5 6 11; 6 10 11]; 
    
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

function v=scatripl(ax,ay,az,bx,by,bz,cx,cy,cz)
%
% v=scatripl(ax,ay,az,bx,by,bz,cx,cy,cz)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% Scalar triple product dot(cross(a,b),c) where
% the cartesian components of vectors a,b,and c
% are given in arrays of the same size.
v=ax.*(by.*cz-bz.*cy)+ay.*(bz.*cx-bx.*cz)...
  +az.*(bx.*cy-by.*cx);

function vrr=proptet(v,x1,y1,z1,x2,y2,z2,...
                     x3,y3,z3,xc,yc,zc)
%                   
% vrr=proptet(v,x1,y1,z1,x2,y2,z2,x3,y3,z3,...
%                                    xc,yc,zc)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% This function computes tensor properties of a
% tetrahedron with its base being a triangular
% surface and its apex at the origin
vrr=tensprod(v,x1,y1,z1)+tensprod(v,x2,y2,z2)+...
    tensprod(v,x3,y3,z3)+tensprod(v,xc,yc,zc);

function vrr=tensprod(v,x,y,z)
%
% vrr=tensprod(v,x,y,z)
% ~~~~~~~~~~~~~~~~~~~~
% This function forms the various components
% of v*R*R'. The calculation is vectorized
% over arrays of points
vxx=sum(sum(v.*x.*x)); vyy=sum(sum(v.*y.*y));
vzz=sum(sum(v.*z.*z)); vxy=sum(sum(v.*x.*y));
vxz=sum(sum(v.*x.*z)); vyz=sum(sum(v.*y.*z));
vrr=[vxx; vyy; vzz; vxy; vxz; vyz];

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

function c=crosmat(a,b)
%
% c=crosmat(a,b)
% ~~~~~~~~~~~~~~
% This function computes the vector cross product for vectors stored in
% the rows of matrices a and b, and returns the results in the rows of c.
%
% User m functions called: none
%----------------------------------------------

c=[a(:,2).*b(:,3)-a(:,3).*b(:,2),...
   a(:,3).*b(:,1)-a(:,1).*b(:,3),...
   a(:,1).*b(:,2)-a(:,2).*b(:,1)];

function range=cubrange(xyz,ovrsiz)
%
% range=cubrange(xyz,ovrsiz)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~
% This function determines limits for a square 
% or cube shaped region for plotting data values 
% in the columns of array xyz to an undistorted 
% scale
%
% xyz    - a matrix of the form [x,y] or [x,y,z]
%          where x,y,z are vectors of coordinate
%          points
% ovrsiz - a scale factor for increasing the
%          window size. This parameter is set to
%          one if only one input is given.
%
% range  - a vector used by function axis to set
%          window limits to plot x,y,z points
%          undistorted. This vector has the form
%          [xmin,xmax,ymin,ymax] when xyz has
%          only two columns or the form 
%          [xmin,xmax,ymin,ymax,zmin,zmax]
%          when xyz has three columns.
%
% User m functions called:  none
%----------------------------------------------

if nargin==1, ovrsiz=1; end
pmin=min(xyz); pmax=max(xyz); pm=(pmin+pmax)/2;
pd=max(ovrsiz/2*(pmax-pmin));
if length(pmin)==2
  range=pm([1,1,2,2])+pd*[-1,1,-1,1];
else
  range=pm([1 1 2 2 3 3])+pd*[-1,1,-1,1,-1,1];
end

function s=dispv(v) 
%  s=dispv(v) writes a vector in more compact form than disp(v)
n=length(v); s='[';
for j=1:n-1, s=[s,num2str(v(j)),', ']; end
s=[s,num2str(v(n)),']'];

function explain
% explain the mathmatical formulation
disp(strvcat(...
'                INERTIAL PROPERTIES OF POLYHEDRA',...
' Dynamical analyses in engineering often require inertial properties of',...
' complex shapes such as polyhedra. The volume, the first moment of volume',...
' and the second moment of volume of a general solid can be computed by',...
' ',...
'   V = Integral( dVol ), VR = Integral( R*dVol ), VRR = Integral( R*R’*dVol ).',...
' ',...
' Also of interest are the centroidal radius RC = VR/V and the inertia tensor',...
' I = eye(3,3)*trace( VRR )-VRR. The Gauss divergence theorem for a tensor',...
' function F states that',...
' ',...
'  Integral( div(F)*dVol ) = SurfIntegral( Dot(N,F)*dSurf )',...
' ',...
' where R = [x;  y;  z] is the cartesian radius vector and N is the outward',...
' directed unit surface normal. This leads to',...
' ',...
'   [V,  VR, VRR] = SurfIntegral( [ 1/3,  R/4,  R*R’/5 ]*Dot(N,R)*dSurf ).',...
' ',...
' The surface parts of a polyhedron have constant surface normals and the',...
' integrals over planar parts can be converted to line integrals and evaluated',...
' exactly. A concise algorithm for the inertial properties of arbitrary',... 
' polyhedra results. General shapes can be approximated using polyhedral models.',...
' However, obtaining several digit accuracy for curved surfaces such as a sphere',...
' or a torus may require a large number of elements. Examples in the program',...
' show exact results for several polyhedra and approximate results for curved',...
' surfaces. Among the utility functions provided are polhedrn to compute',... 
' polyhedron properties using corner coordinates of the faces, srfvn employing',...
' x,y,z arrays similar to function surf, and polyxy which obtains inertial',...
' properties of arbitrary polygons. More detail on the methods used appear in',...
' ''Advanced Mathematics and Mechanics Applications Using MATLAB'', 3rd Ed.,2003,',...
' CRC Press, by H. Wilson, L. Turcotte, and D. Halpern.')) 

function functionlist
% The following functions are included in the workspace
% runpolyhedron.m    complete program with all routines combined together
% runpolyhed         seperate main driver for the polyhedron program
% runexamples.m      runs eight representative test examples
% polhedrn.m         general function for polyhedron inertial properties
% srfvn.m            function for solid properties using surface coordinates
% polhdplt.m         surface plot function for a general polyhedron
% explain.m          explanation of the mathematical formulation 
% polyxy.m           geometric properties for an arbitrary polygon
% hexapod.m          coordinate data for a hexapod
% dodecahedron       coordinate data for a dodecahedron
% icosahedron.m      coordinate data for an icosahedron
% octahedron.m       coordinate data for an octahedron
% triablock.m        coordinate data for a triangular block
% crosmat.m          vectorized matrix cross product function
% cubrange.m         determines plot range for surface plots
% dispv.m            displays a vector in compact form
% frusprope.m        exact inertial properties of a conical frustum
% frustum.m          frustum properties using a polyhedron approximation 
% proptet.m          tensor properties of a tetrahedron with apex at the origin
% pyramid.m          inertial properties of a pyramid with apex at the origin
% scatripl.m         vectorized scalar triple product
% sphrprop.m         inertial properties of a unit sphere
% surfplot.m         surface plot function including title and color arguments
% tensprod.m         vectorized tensor product function 
% rph                animates the rotation of a polyhedron about any axis
% rotamat            rotates a vector about an arbitrary axis
% boxrota            determines coordinate range traversed during rotation
% rotashft           determines new coordinates after arbitrary rotation
% bounds             determines coordinate bounds on a set of points
% torusprop.m        inertial properties of a torus
% winposn.m          positions the graphics window to avoid text overwrite
% polyerr            plots error in area and polar moment of inertia due to
%                    approximating a circle by an inscibed regular polygon
% functionlist       lists names of the various functions in the workspace
help functionlist

function [Earea,Emoment,nsides]=polyerr(nsides)
% [Earea,Emoment,nsides]=polyerr(nsides)
% This function computes the percent error in area and polar moment 
% of inertia resulting when a  circle is approximated by a regular
% polygon with corners touching the circle.
if nargin==0; nsides=3:100; end, nsides=nsides(find(nsides>=3));
Aexact=pi; Jexact=pi/2; n=nsides; Aaprox=n/2.*sin(2*pi./n);
Japrox=n/4.*sin(2*pi./n).*(1-2/3*sin(pi./n).^2);
Earea=100*(1-Aaprox/Aexact); Emoment=100*(1-Japrox/Jexact);
semilogy(nsides,Earea,'k',nsides,Emoment,'r')
xlabel('number of sides'), ylabel('Percent Error = 100*(1-approx/exact)')
title('PERCENT ERROR IN AREA AND POLAR MOMENT OF INERTIA')
legend('area error','polar moment of inertia error')
grid on, shg