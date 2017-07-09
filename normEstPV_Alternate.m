function [ xhat, xsharp, normxEst ] = normEstPV_Alternate(A, y, s, tau )
%NormEstPV_Alternate Estimates the norm of an N-dimensional signal x given binary measurements y1 of the 
%form sign(a_i x - t_i) (a_i,j ~N(0,1) and t_i~N(0,tau) for nonzero tau) 
%by augmenting x and applying the algorithm from 
%Plan and Vershynin. "Robust 1-bit compressive sensing and sparse logistic
%regression" 2012
%(See Remark 7, http://arxiv.org/pdf/1404.6853v1.pdf)

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

[~,n] = size(A);

cvx_begin;

variable xhat(n);
minimize( y'*(A*xhat) );
subject to
    norm(xhat,2) <= 1;
    norm(xhat,1) <= sqrt(s+1);
cvx_end;

xhat =xhat;
xsharp = tau*xhat(1:end-1)/xhat(n);
normxEst= norm(xsharp);

end

