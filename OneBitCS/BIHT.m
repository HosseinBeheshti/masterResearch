function z_biht = BIHT(y,n,s,m,N)
max_itr = 3000;
htol = 0;

z_biht = zeros(n+1,1);
hd = Inf;
i = 0;

while(htol < hd)&&(i < max_itr)
	% Get gradient
	g = N'*(theta(N*z_biht) - y);
	
	% Step
	a = z_biht - g;
	
	% Best K-term (threshold)
	[trash, aidx] = sort(abs(a), 'descend');
	a(aidx(s+1:end)) = 0;
	
    % Update x
	z_biht = a;
    
	% Measure hammning distance to original 1bit measurements
	hd = nnz(y - theta(N*z_biht));
	i = i+1;
end

% Now project to sphere
z_biht = z_biht/norm(z_biht);
end