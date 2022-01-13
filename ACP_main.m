function fACP_main = ACP_main(D, A, f, r, T)
    % Adaptive second-order cone programming
    [m, n] = size(A);
    fACP_main = zeros(n, T + 1)+eps;

    for t = 1:T
        ATemp = A(1:t * m / T, :);
        tauTemp = DitherGenerator(size(ATemp,1), (2)^(-t) .* r / t);
        yTemp = sign(ATemp * (f - fACP_main(:, t)) - tauTemp);

        try
            fCPTemp = fACP_main(:, t) + ACP(yTemp, ATemp, D, tauTemp, (2)^(-t) .* r / t);
        catch
            fCPTemp = fACP_main(:, t);
            warning('########################### ACP exception occurred ###########################');
        end

        fACP_main(:, t + 1) = fCPTemp;
        %% visiual adaptivity
        if n == 2

            if t == 1
                hold on;
                plot(f(1), f(2), '.r', 'markersize', 10);
            end

            pause(1);
            plot(fACP_main(1, t), fACP_main(2, t), '.b', 'markersize', 10);

            if t == T
                hold off;
            end

        end

    end

end
