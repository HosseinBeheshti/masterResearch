function z_l1 = cvx1(y,n,s,m,N)
%   mam \sum^{m}_{i=1}  y_{i}<n_{i},z^{\prime}> s.t. ||z^{\prime}||_1 \leq \sqrt{s} \quad  ||z^{\prime}||_2 \leq 1   (1)
cvx_begin 
    variable z_l1(n+1);
    minimize(-y'*N*z_l1);
    subject to
        norm(z_l1,1) <= sqrt(s);
        norm(z_l1) <= 1;
cvx_end
% Now project to sphere
z_l1 = z_l1/norm(z_l1);
end