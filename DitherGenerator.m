function tau = DitherGenerator(m,th_var,type)

% Linear programming
if (isequal(type ,'LP'))
    tau = th_var^2.*randn(m,1);
end

% Second-order cone programming 
if (isequal(type ,'CP'))
    tau = th_var^2.*randn(m,1);
end

% Hard thresholding 
if (isequal(type ,'HT'))
    tau = th_var^2.*randn(m,1);
end

end