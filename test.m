% compute brunn 
%%
clear;
tic;
load log;
%%
% % test_poly = slice
%%
if 0
close all;
sweep_d = -L_inf:2:L_inf;
Volume_clt = zeros(n,length(sweep_d));
dim_vec     = 1:n;
if n==2 || n==3
    figure(1)
    plot(current_Polyhedron,'color','blue','alpha',0.1)
end
for i = 1:n
    for k =1:length(sweep_d)
        slice_poly = slice(current_Polyhedron,i,sweep_d(k),'keepDim',true);
        dim_proj = [dim_vec(1:i-1) dim_vec(i+1:n)];
        F = projection(slice_poly,dim_proj);
        Volume_clt(i,k) = volume(F);
    end
    disp(i/n)
end
volume(current_Polyhedron)
toc
save log;
end
%%
figure(2)
hold on;
for i = 1:n
    plot(Volume_clt(i,:))
end
hold off;