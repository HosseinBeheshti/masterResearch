function fACP_main = ACP_main(D,A,f,r,T)
% Adaptive second-order cone programming 
[m,n]= size(A);
DitherType = 'CP';
fACP_main= zeros(n,T+1);
for t = 1:T
    ATemp = A((t-1)*m/T+1:t*m/T,:);
    tauTemp = DitherGenerator(m/T,(2)^(1-t).*r,DitherType);
    phiTemp = ATemp*(fACP_main(:,t))+tauTemp;
    yTemp = sign(ATemp*f-phiTemp);
    fCPTemp = ACP(yTemp,ATemp,D,phiTemp,r);
    fACP_main(:,t+1) = fCPTemp;
    %% visiual adaptivity
    if n==2
        if t== 1
            hold on;
            plot(f(1),f(2),'.r','markersize',10);
        end
        pause(1);
        plot(fACP_main(1,t),fACP_main(2,t),'.b','markersize',10);
        if t== T
            hold off;
        end
    end
end
end