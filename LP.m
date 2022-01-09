function fLP = LP(y, A, D, sigma, tau)
    % This is the implementation of the algorithm based on linear programming
    [m, n] = size(A);
    cvx_begin quiet;
    variable h(n);
    variable u;
    minimize(norm(D' * h, 1) + abs(u));
    subject to
    y .* (A * h - (u / sigma) .* tau) >= 0;
    norm(A * h - (u / sigma) .* tau, 1) <= 1;
    cvx_end

    fLP = (sigma / u) .* h;

end
