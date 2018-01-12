function tau = DitherGenerator(m,th_var)
tau = th_var^2.*randn(m,1);
end