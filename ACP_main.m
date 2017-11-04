function fCP_main = ACP_main(D,A,f,th_var,r,T)

[m,n]= size(A);
DitherType = 'CP';
fCP_main= zeros(n,T+1);
h = waitbar(0,'Initializing waitbar...');
for t = 1:T
    ATemp = A((t-1)*m/T+1:t*m/T,:);
    tauTemp = DitherGenerator(m/T,(2)^(1-t).*th_var,DitherType);
    yTemp = sign(ATemp*(f-fCP_main(:,t))-tauTemp);
    fCPTemp = ACP(yTemp,ATemp,D,fCP_main(:,t),tauTemp,th_var);
    fCP_main(:,t+1) = fCPTemp;
    % waitbar
    perc = (t/T)*100;
    waitbar(perc/100,h,sprintf('%d%% along...',perc))
end
close(h)
end