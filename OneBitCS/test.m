% compute analytic center with acc polyhedron
clear;
load log;

% Computing Analytic center
cvx_begin quiet;
variable x_ac(n);
minimize -sum(log(ply_ofst-ply_nrml*x_ac));
cvx_end

if plot_adpt
    if n == 2
        close all;
        figure(1);
        hold on;
        % norm constraint
        sp  = -L_inf:(L_inf/100):L_inf;
        plot(L_inf*ones(length(sp)),sp,'.b','markersize',5);
        plot(-L_inf*ones(length(sp)),sp,'.b','markersize',5);
        plot(sp,L_inf*ones(length(sp)),'.b','markersize',5);
        plot(sp,-L_inf*ones(length(sp)),'.b','markersize',5);
        plot(x_org(1),x_org(2),'.r','markersize',40);
        t1 = -4*L_inf:(L_inf/100):4*L_inf;
        for k = 1:length(y)
            t2 = -((A(k,1)/A(k,2))*(t1-Phi(1,k)))+Phi(2,k);
            plot(t1,t2);
            xlim([-L_inf L_inf]);
            ylim([-L_inf L_inf]);
        end
        % x and xhat
        plot(x_ac(1),x_ac(2),'.g','markersize',40);
        plot(x_opt(1),x_opt(2),'.b','markersize',35);
        pause(1)
        hold off;
    end
end