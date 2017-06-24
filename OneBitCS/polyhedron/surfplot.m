function surfplot(x,y,z,titl,colr)
% surfplot(x,y,z,titl,colr)    
if nargin<5, colr=[1 1 0]; end    
hold off, surf(x,y,z), axis equal, title(titl)  
xlabel('x-axis'),ylabel('y-axis'), zlabel('z-axis')
colormap(colr), winposn; shg