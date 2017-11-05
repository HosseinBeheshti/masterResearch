function fHT_main = HT_main(D,A,f,s,r,T,epq,eaq)

% x: the vector to be recovered
% A: the matrix whose rows give the measurements
% s: the sparsity of x
% R: an (over)estimation of the magnitude of the vector to be recovered
% T: the number of adaptive groups of measurements
% e: a vector prequantization measurement errors
% b: a vector of bit flips

% This is the implementation of the algorithm based on hard thresholding


DitherType = 'HT';

[m,n] = size(A);
if nargin < 7
    eaq=ones(m,1);
end
if nargin < 6
    epq=zeros(m,1);
end

fHT_main = zeros(n,T+1);
for t=1:T
    ATemp1 = A((t-1)*m/T+1:(2*t-1)*m/(2*T),:);
    epqTemp1 = epq((t-1)*m/T+1:(2*t-1)*m/(2*T));
    eaqTemp2 = eaq((t-1)*m/T+1:(2*t-1)*m/(2*T));
    ATemp2 = A((2*t-1)*m/(2*T)+1:t*m/T,:);
    epqTemp2 = epq((2*t-1)*m/(2*T)+1:t*m/T);
    eaqTemp2 = eaq((2*t-1)*m/(2*T)+1:t*m/T);
    yTemp1 = eaqTemp2.*sign(ATemp1*(fHT_main(:,t)-x)+epqTemp1);
    [u,v,w] = HT_Order1_round1(yTemp1,ATemp1,2*s,(r/2^(t-1)));
    yTemp2 = eaqTemp2.*sign(ATemp2*(w-(fHT_main(:,t)-x))+epqTemp2);
    z = HT_Order1_round2(yTemp2,ATemp2,2*s,(r/2^(t-1)),u,v,w);
    fHT_Temp = hard_threshold(fHT_main(:,t)-z,s);
    fHT_main(:,t+1) = fHT_Temp;
end

end