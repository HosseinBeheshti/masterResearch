function [ normxEst ] = normEstEDF( y, tau )
%NORMESTEDF Estimates the l2 norm of x given binary measurements of the 
%form sign(<a_i, x> - tau),for random Gaussian a, using the empirical 
%distribution function (see Theorems 10,11 http://arxiv.org/pdf/1404.6853v1.pdf)

%Input
%y a m by 1 vector of measurements sign(<a_i, x> - tau)
%tau a fixed, nonzero scalar

%Output
%normxEst a scalar estimate of the l2 norm of x

m = length(y);
z = (m-sum(y))/m;  %proportion of entries of y that are 0 (in a 0/1 quantization scheme-- change this for a -1/1 quantizer)
normxEst = tau /(sqrt(2) * erfinv(2*z -1));


end

