function fHT_main = HT_main(D,A,f,t,th_var,r)

[m,n]= size(A);
DitherType = 'HT';
tau = 0.*DitherGenerator(m,th_var,DitherType);
y = sign(A*f-tau);


%% BIHT
max_itr	= 3000;
htol 	= 0;

z_temp 	= zeros(n,1);
hd      = Inf;
i       = 0;

while(htol < hd)&&(i < max_itr)
    % Get gradient
    g   = (D'*A)'*(sign(D'*A'*z_temp) - y);
    
    % Step
    a   = z_temp - g;
    
    % Best K-term (threshold)
    z_temp = HardThreshold(D'*A'*y,t-1);
    
    % Measure hammning distance to original 1bit measurements
    hd  = nnz(y - sign(N*z_temp));
    i   = i+1;
end





fHT_main = ((-th_var^2)/(tau'*y)).*D*z;
end