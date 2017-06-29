function [ xhat, xsharp, normxEst ] = normEstPV(A, y1, tau )
%NormEstPV Estimates the norm of an N-dimensional signal x given binary measurements y1 of the 
%form sign(a_i x - t_i) (a_i,j ~N(0,1) and t_i~N(0,tau) for nonzero tau) 
%by augmenting x and applying the algorithm from Plan and Vershynin. "One-bit
%compressed sensing by linear programming." 2013
%(See Theorem 4, http://arxiv.org/pdf/1404.6853v1.pdf)

%Input:
%A an m by n measurement matrix whose entries are assumed drawn i.i.d from
    %a standard Gaussian distribution.  Here, n = N+1
%y1 an m by 1 measurement vector. We assume y = sgn(A*[x;tau])
   %[x;tau] is the signal x with tau appended.
   
%Output
%xhat is a n by 1 vector that is the solution to the convex optimization problem argmin_z ||z||_1 subject
    %to sum_( |<a_i,z>| )=m and sign(<a_i,xhat>) = y1, projected onto the
    %unit l2 ball
%xsharp an N by 1 estimate of the signal x
%normxEst a scalar estimate of the l2 norm of x

[m,n] = size(A);
y = y1*2-ones(size(y1));

cvx_begin quiet;
variable z(n);
minimize( norm(z,1) )
subject to
    sum((A*z).*y) == m ;
    (A*z).*y >= 0
cvx_end;

z=z;
xhat = z/norm(z,2);
xsharp = tau*z(1:end-1)/z(n);
normxEst= norm(xsharp);

end

