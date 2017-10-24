function D = DictionaryGenerator(n,N,type)
% Generate dictionary matrix
% n: the number of rows
% N: the number of column

% Dictionary: Real
if (isequal(type ,'Rl'))
    for i=1:n
        w=randn(N,1);
        normw=norm(w);
        Dtemp(i,:)=w/normw;
    end
    D=Dtemp;
end



% Dictionary: Overcomplete DFT
if (isequal(type ,'ODFT'))
    D = ifft(eye(N))*N/sqrt(N);
    D = D(1:n,:);
end

end