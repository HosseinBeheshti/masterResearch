function A=rotamat(n,theta)
% A=rotamat(n,theta) gives the matrix to rotate a vector
% through angle theta about the direction of vector n
n=n(:)/norm(n); theta=theta*pi/180;
A=cos(theta)*eye(3,3)+(1-cos(theta))*n*n'+...
  sin(theta)*[0,-n(3),n(2);n(3),0,-n(1);-n(2),n(1),0];