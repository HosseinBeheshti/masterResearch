function x_Gbiht = GBIHT(x_org,n,s,m)
%  Gnomonic BIHT
%% Gnomonic projection(GP)
    r     	= norm(x_org);
    xp  	= [x_org ; -1];
    z   	= xp./sqrt(r^2+1);
    %% Gaussian sensing matrix and associated 1-bit sensing
    N     	= randn(m,n+1);
    y     	= theta(N*z);
    %% BIHT
    max_itr	= 3000;
    htol 	= 0;

    z_temp 	= zeros(n+1,1);
    hd      = Inf;
    i       = 0;

    while(htol < hd)&&(i < max_itr)
        % Get gradient
        g   = N'*(theta(N*z_temp) - y);
	
        % Step
        a   = z_temp - g;
	
        % Best K-term (threshold)
        [trash, aidx]       = sort(abs(a), 'descend');
        a(aidx(s+1:end))    = 0;
	
        % Update x
        z_temp  = a;
    
        % Measure hammning distance to original 1bit measurements
        hd  = nnz(y - theta(N*z_temp));
        i   = i+1;
    end
    % project to sphere
    z_biht  = z_temp/norm(z_temp);
    %% IGP
    xp_Gbiht	= z_biht.*(sqrt(r^2+1));
    x_Gbiht  	= xp_Gbiht(1:end-1);
end