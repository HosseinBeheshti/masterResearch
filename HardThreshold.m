function [x_thresholded, supp] = HardThreshold(x, s)

    % x: the vector to be hard-thresholded
    % s: the number of nonzero entries to be kept

    % This is an implemenation to the hard thresholding operator

    [~, I] = sort(abs(x), 'descend');
    supp = I(1:s);
    x_thresholded = zeros(size(x));
    x_thresholded(supp) = x(supp);

end
