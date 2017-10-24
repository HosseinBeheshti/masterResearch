function [tau] = DitherGenerator(y,A,s,r,type)
% f: the vector to be recovered
% A: the matrix whose rows give the measurements
% s: the sparsity of x
% r: an (over)estimation of the magnitude of the vector to be recovered
% type: dither generator type

q = size(A,1); % size of batch
y =
% Linear programming
if (isequal(type ,'LP'))
    tau = r^2.*randn(q,1);
end

% Second-order cone programming
if (isequal(type ,'CP'))
    tau = r^2.*randn(q,1);
end

% Hard thresholding
if (isequal(type ,'HT'))
    [u,supp] = hard_threshold(A'*y,s);
    u = u/norm(u);
    v = zeros(size(u));
    v(supp(1)) = u(supp(2));
    v(supp(2)) = -u(supp(1));
    v = v/norm(v);
    w = 2*r*(u+v);
end

end