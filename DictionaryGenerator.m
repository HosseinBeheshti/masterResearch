function D = DictionaryGenerator(n,N)
% Generate dictionary matrix
% n: the number of rows
% N: the number of column

% Dictionary: Real
for i=1:N
    w=randn(n,1);
    normw=norm(w);
    Dtemp(i,:)=w/normw;
end
Dtemp = orth(Dtemp);
D=Dtemp';

end