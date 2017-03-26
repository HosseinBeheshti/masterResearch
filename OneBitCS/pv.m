function z_pv = pv(y,n,s,m,N)
%   mam \sum^{m}_{i=1}  y_{i}<n_{i},z^{\prime}> s.t. ||z^{\prime}||_1 \leq \sqrt{s} \quad  ||z^{\prime}||_2 \leq 1   (1)
cvx_begin 
    variable z_pv_temp(n+1);
    minimize(-y'*N*z_pv_temp);
    subject to
        norm(z_pv_temp,1) <= sqrt(s);
        norm(z_pv_temp) <= 1;
cvx_end
% Now project to sphere
z_pv = z_pv_temp/norm(z_pv_temp);
end