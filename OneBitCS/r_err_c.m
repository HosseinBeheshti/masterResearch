function r_err = r_err_c(x,x_org)
    r_err = abs(norm(x)-norm(x_org))/norm(x_org);
end
