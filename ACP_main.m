function fACP_main = ACP_main(D,A,f,th_var,r,T)

[m,n]= size(A);
DitherType = 'CP';
fACP_main= zeros(n,T+1);

for t = 1:T
    ATemp = A((t-1)*m/T+1:t*m/T,:);
    tauTemp = DitherGenerator(m/T,(2)^(1-t).*th_var,DitherType);
    yTemp = sign(ATemp*(f-fACP_main(:,t))-tauTemp);
    fCPTemp = ACP(yTemp,ATemp,D,fACP_main(:,t),tauTemp,th_var);
    fACP_main(:,t+1) = fCPTemp;
    % waitbar
    perc = (t/T)*100;
    fprintf('fACP_main pass percent: %f\n',perc)
    %% visiual adaptivity
    if n==2
        if t== 1
            hold on;
            plot(f(1),f(2),'.g','markersize',10);
        end
        pause(1);
        plot(fACP_main(1,t),fACP_main(2,t),'.b','markersize',10);
        if t== T
            hold off;
        end
    end
end
end