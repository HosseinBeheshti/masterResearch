function tau = DitherGenerator(m,sigma,type)

% Linear programming
if (isequal(type ,'LP'))
    tau = sigma^2.*randn(m,1);
end

end