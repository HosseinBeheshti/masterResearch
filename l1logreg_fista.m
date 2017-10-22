function [xk] = l1logreg_fista(y,A,lambda,tol,NbIter)

% y: the vector of quantized measurements 
% A: the matrix whose rows give the measurements
% lambda: the regularization parameter
% tol: a tolerance on the relative error of successive iterates
% NbIter: the number of iterations

% xk: the output is the minimizer among all vectors x of
% sum_i log( 1 + exp(-y_i*<a_i,x>) ) + \lambda ||x||_1
% where the vectors a_i represent the rows of A

% This code is courtesy of Andrew Lan, Rice University
% It is a specific implementation of the general algorithm described in 
% A FAST ITERATIVE SHRINKAGE-THRESHOLDING ALGORITHM FOR LINEAR INVERSE PROBLEMS
% by Beck and Teboulle

[~,n] = size(A);
L = max(svd(A))^2/4;
xkp = zeros(n,1);
zk = xkp;
tk = 1;
ii = 0;

while ii < NbIter
    ii = ii+1;
    p = 1./(1+exp(-A*zk));        
    tempz = zk + 1/L*(A'*(y-p));        
    xk = max(abs(tempz)-lambda/L,0).*sign(tempz);
    tkn = (1+sqrt(1+4*tk^2))/2;
    zkn = xk + (tk-1)/tkn*(xk-xkp);      
    if (norm(xk-xkp,2)/norm(xkp,2)<tol) && (ii>1)        
        break;
    end
    xkp = xk;
    zk = zkn;
    tk = tkn;
end

end