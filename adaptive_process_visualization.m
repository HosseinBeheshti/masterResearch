clear;
clc;
close all;
rng default;
%% single stage simulation;
f_sim = [-3 -1.8];
number_of_lines = 9;
slope = [0.37,0.22,-0.86,-0.49,-0.80,0.11,-0.21,0.53,0.76];
offset = [1.37,-2.22,-1.86,-4.49,5.80,1.11,-7.21,7.53,-5.76];
x = linspace(-10,10);
l_cp = zeros(length(slope),length(x));
Polyhedron_cp = zeros(4,2);
cp_fig = figure;
hold on;
plot(f_sim(1), f_sim(2), '.r', 'markersize', 10);
for i = 1:number_of_lines
    l_cp(i,:) = slope(i)*x + offset(i);
    if i<5
        plot(x,l_cp(i,:),':', 'LineWidth', 1.2);
    else
        plot(x,l_cp(i,:));
    end
    pause(1);
end
Polyhedron_cp(1,:) = InterX([x;l_cp(1,:)],[x;l_cp(3,:)]);
Polyhedron_cp(2,:) = InterX([x;l_cp(1,:)],[x;l_cp(4,:)]);
Polyhedron_cp(3,:) = InterX([x;l_cp(2,:)],[x;l_cp(4,:)]);
Polyhedron_cp(4,:) = InterX([x;l_cp(2,:)],[x;l_cp(3,:)]);
pgon = polyshape(Polyhedron_cp(:,1),Polyhedron_cp(:,2));
plot(pgon,'FaceColor','red','FaceAlpha',0.1);
%% ACP

