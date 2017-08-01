function xT = Recovery1(A,y,s,m,tau,q)
T = ceil(m,q);
for t= 1:T
    cvx begin
    variable zTemp(n)
    minimize norm(zTemp,1)
    subject to
    norm(zTemp,2) <= 2^(2-t);
    y((t-1)*T+1:t*T).*(A((t-1)*T+1:t*T,:)*zTemp-2^(2-t)*tau((t-1)*T+1:t*T)) >= 0;
    cvx end
    xT = H_s(x_{t-1}+z_{t});
end
end