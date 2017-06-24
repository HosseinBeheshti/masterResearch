function runpolyhed
% function runpolyhed is the main driver program for runpolyhedron

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