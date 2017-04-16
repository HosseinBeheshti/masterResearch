%% Set parameters

N = 200; % the dimensionality of the signal x
s = 5; %the sparsity of x
Rmax = 1; %upper bound for ||x||
Rmin = .1; %lower bound for ||x||

tau =Rmin% Threshold parameter: an alternative is 
tau2 = Rmin/2+Rmax/2 %(works better with convex minimizaiton);
m = 1000;

%%Create a sample signal x

%create the sparsity pattern to use;
p = randperm(N);
indices = p(1:s);
S = zeros(N,1);
for i = 1:s
    S(indices(i)) = 1;
end
%generate x with standard gaussian entries, then scale to have norm R,
%where R is drawn uniformly at random on (Rmin, Rmax)
x = S.*randn(N,1);
R = rand*(Rmax-Rmin)+Rmin;
x = (x/norm(x,2))*R;

%l2 norm of x
trueNorm = norm(x,2)
%%
%generate a measurement matrix A, with entries iid standard Gaussians
%use A for recovery using empirical distribution function (EDF)
A = normrnd(0,1,m,N); 
%append another column to A (still with entries iid standard Gaussians) for
    %recovery using the augmented Plan and Vershynin method (PVAug)
Aaug = [A, normrnd(0,1,m,1)]; 
 
% Measurements
%for EDF, threshold set deterministically at tau.  y(i) = 1 if  
%<a_i,x> >= tau, y(i) = 0 otherwise
y = ((A*x - tau* ones(m,1)) > 0);
yaug = (Aaug*[x;tau2] ) > 0;

%estimate the norm of x

%estimates the norm via the EDF)
estNormEDF = normEstEDF( y, tau )

%estimates the norm using the PVAug method
   %( also returns an estimate xsharp of x itself)
[~,xsharp,estNormPV] = normEstPV(Aaug,yaug,tau2);
estNormPV

%Alternatively, partition [m] into two parts (m1+m2=m), use the first m1
%measurments for estimating only the norm using the EDF method, and the remaining m2
%for estimating only the direction using the PV algorithm (Plan and Vershynin 2013)
m1 = m/2;
m2 = m-m1;
y = y(1:m1);
estNormEDFm1 = normEstEDF(y,tau);%norm estimate
y = (A(m1+1:m,:)*x >0);
[xhatm2,~,~] = normEstPV(A(m1+1:m,:), y, 0); %direction estimate
xEstCombined = estNormEDFm1*xhatm2; %x estimate


scrsz = get(0,'ScreenSize');
figure(1);clf
h=figure(1);
set(h,'Position',[1 2*scrsz(4)/3 2*scrsz(3)/3 2*scrsz(4)/3])
stem(x,'linewidth',3);set(gca,'ylim',[-Rmax Rmax])
hold on;
stem(xEstCombined,'g.','markersize',20);
stem(xsharp,'r.','markersize',20);
% legend('original','recovered by EDF estimation','recovered by convex optimization',4)
set(gca,'fontsize',18)
display(['True norm, EDF-estimated norm, and convex optimization estimated norm'] )
display([R estNormEDFm1 estNormPV])