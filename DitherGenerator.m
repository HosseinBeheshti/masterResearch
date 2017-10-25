function tau = DitherGenerator(m,th_var,type)

% Linear programming
if (isequal(type ,'LP'))
    tau = th_var^2.*randn(m,1);
end

end