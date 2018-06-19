function fACP_main = ACP_main(D,A,f,r,T)
% Adaptive second-order cone programming
[m,n]= size(A);
fACP_main= zeros(n,T+1);
for t = 1:T
    ATemp = A((t-1)*m/T+1:t*m/T,:);
    tauTemp = DitherGenerator(m/T,(2)^(-t).*r);
    yTemp = sign(ATemp*(f-fACP_main(:,t))-tauTemp);
    fCPTemp = fACP_main(:,t)+ACP(yTemp,ATemp,D,tauTemp,(2)^(-t).*r);
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
    if n==3
        ply_nrml    = -yTemp.*ATemp;
        ply_ofst    = -yTemp.*tauTemp;
        
        current_Polyhedron = Polyhedron(ply_nrml,ply_ofst);
        
        ply_nrml = current_Polyhedron.H(:,(1:end-1));
        ply_ofst = current_Polyhedron.H(:,end);
        
        hold on;
        plot(current_Polyhedron,'color','blue','alpha',0.2);
        if t== T
            hold off;
        end
        
    end
end
end