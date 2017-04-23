function x_Gpv = Gpv(x_org,n,s,m)
%   mam \sum^{m}_{i=1}  y_{i}<n_{i},z^{\prime}> s.t. ||z^{\prime}||_1 \leq \sqrt{s} \quad  ||z^{\prime}||_2 \leq 1   (1)
    %% Gnomonic projection(GP)
    r     	= norm(x_org);
    xp  	= [x_org ; -1];
    z   	= xp./sqrt(r^2+1);
    %% Gaussian sensing matrix and associated 1-bit sensing
    N     	= randn(m,n+1);
    y     	= theta(N*z);
    %% cvx
    cvx_begin 
        variable z_temp(n+1);
        minimize(-y'*N*z_temp);
        subject to
            norm(z_temp,1)   <= sqrt(s);
            norm(z_temp)     <= 1;
    cvx_end
    % project to sphere
    z_Gpv = z_temp/norm(z_temp);
    %% IGP
    xp_Gpv	= z_Gpv.*(sqrt(r^2+1));
    x_Gpv  	= xp_Gpv(1:end-1);
end