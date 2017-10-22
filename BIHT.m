function [xBIHT]=BIHT(y,A,s,NbIter)

% y: the vector of quantized measurements 
% A: the matrix whose rows give the measurements
% s: the sparsity of the vector to be recovered
% NbIter: the number of iterations

% This is the iterative algorithm proposed in 
% ROBUST 1-BIT COMPRESSIVE SENSING BY BINARY STABLE EMBEDDINGS OF SPARSE VECTORS
% by Jacques, Laska, Boufounos, and Baraniuk
% see also http://perso.uclouvain.be/laurent.jacques/index.php/Main/BIHTDemo

[m,n] = size(A);
xBIHT = zeros(n,1);
for k = 1:NbIter
    x_aux = xBIHT + (1/m)*A'*(y-sign(A*xBIHT));
    xBIHT = hard_threshold(x_aux,s);
end

end