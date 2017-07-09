function out = theta(in)
for i=1:length(in)
    if in(i)<0
        out(i) = -1;
    else
        out(i) = 1;
    end
end
out = out';
end