function y = AdaptiveQuantization(x,A,n,m,s,tau,q)
T = ceil(m,q);
xTemp = zeors(1,n);
for t= 1:T
    Sigma((t-1)*T+1:t*T) = A((t-1)*T+1:t*T,:)*xTemp;
    y((t-1)*T+1:t*T) = theta(A((t-1)*T+1:t*T,:)*x-2^(2-t)*tau((t-1)*T+1:t*T)-Sigma((t-1)*T+1:t*T));
    begin cvx
    variable zTemp(n)
    minimize norm(zTemp,1)
    subject to 
    norm(zTemp,2) <= 2^(2-t);
    y((t-1)*T+1:t*T).*(A((t-1)*T+1:t*T,:)*zTemp-2^(2-t)*tau((t-1)*T+1:t*T)) >= 0;
    end cvx
    H
s
keeps
s
largest (in magnitude) 
end

end
