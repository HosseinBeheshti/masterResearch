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