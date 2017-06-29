function [ xhatPV, xsharpPV, normxEstPV, xhatAlt, xsharpAlt, normxEstAlt, normxEstEDF ] = KarinKnudson(x_org, n, s, m, tau, tau2)

%%
%generate a measurement matrix A, with entries iid standard Gaussians
%use A for recovery using empirical distribution function (EDF)
A = normrnd(0,1,m,n); 
%append another column to A (still with entries iid standard Gaussians) for
    %recovery using the augmented Plan and Vershynin method (PVAug)
Aaug = [A, normrnd(0,1,m,1)]; 

% Measurements
%for EDF, threshold set deterministically at tau.  y(i) = 1 if  
%<a_i,x> >= tau, y(i) = 0 otherwise
y = ((A*x_org - tau* ones(m,1)) > 0);
yaug = (Aaug*[x_org;tau2] ) > 0;

%estimate the norm of x

%estimates the norm via the EDF)
normxEstEDF = normEstEDF( y, tau );

%estimates the norm using the PVAug method
   %( also returns an estimate xsharp of x itself)
[xhatPV, xsharpPV, normxEstPV] = normEstPV(Aaug, yaug, tau2);


%Alternatively, partition [m] into two parts (m1+m2=m), use the first m1
%measurments for estimating only the norm using the EDF method, and the remaining m2
%for estimating only the direction using the PV algorithm (Plan and Vershynin 2013)
m1 = m/2;
m2 = m-m1;
y = y(1:m1);
normxEstAlt = normEstEDF(y,tau);%norm estimate
ym2 = (A(m1+1:m,:)*x_org >0);
[xhatm2,xsharpAlt,~] = normEstPV(A(m1+1:m,:), ym2, 0); %direction estimate
xhatAlt = normxEstAlt*xhatm2; %x estimate

end
