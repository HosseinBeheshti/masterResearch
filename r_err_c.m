function r_err = r_err_c(x,x_org)
r_err   = zeros(1,size(x_org,2));
for i=1:size(x_org,2)
    r_err(i) = norm(x(:,i)-x_org(:,i))/norm(x_org(:,i));
end
end
