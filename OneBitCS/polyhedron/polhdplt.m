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