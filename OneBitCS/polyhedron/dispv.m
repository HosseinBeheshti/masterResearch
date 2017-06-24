function s=dispv(v) 
%  s=dispv(v) writes a vector in more compact form than disp(v)
n=length(v); s='[';
for j=1:n-1, s=[s,num2str(v(j)),', ']; end
s=[s,num2str(v(n)),']'];