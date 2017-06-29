function [x_org, trueNorm] = signal_generator(n, s, dtr_x, Rmin, Rmax)
%% Generating a s-sparse signal in R^n
if dtr_x && (n == 2)
    x_org = [10;0];
else
    %create the sparsity pattern to use;
    p = randperm(n);
    indices = p(1:s);
    S = zeros(n,1);
    for i = 1:s
        S(indices(i)) = 1;
    end
    %generate x with standard gaussian entries, then scale to have norm R,
    %where R is drawn uniformly at random on (Rmin, Rmax)
    x_org = S.*randn(n,1);
    R = rand*(Rmax-Rmin)+Rmin;
    x_org = (x_org/norm(x_org,2))*R;
end

%l2 norm of x_org
trueNorm = norm(x_org,2);

end