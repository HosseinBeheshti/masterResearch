clear;
clc;
close all;
rng default;
%% single stage simulation;
f_sim = [-3 -1.8];
number_of_lines = 8;
slope_cp = [0.37, 0.22, -0.86, -0.49, -0.80, 0.76, -0.21, 0.53];
offset_cp = [1.37, -2.22, -1.86, -4.49, 5.80, -5.76, -7.21, 7.53];
x = linspace(-9, 9);
l_cp = zeros(length(slope_cp), length(x));
Polyhedron_cp = zeros(4, 2);
figure_cp = figure;
hold on;
plot(f_sim(1), f_sim(2), '.b', 'markersize', 10);

for i = 1:number_of_lines
    l_cp(i, :) = slope_cp(i) * x + offset_cp(i);

    if i < 5
        plot(x, l_cp(i, :), ':', 'LineWidth', 2);
    else
        plot(x, l_cp(i, :), 'LineWidth', 2);
    end

end

Polyhedron_cp(1, :) = InterX([x; l_cp(1, :)], [x; l_cp(3, :)]);
Polyhedron_cp(2, :) = InterX([x; l_cp(1, :)], [x; l_cp(4, :)]);
Polyhedron_cp(3, :) = InterX([x; l_cp(2, :)], [x; l_cp(4, :)]);
Polyhedron_cp(4, :) = InterX([x; l_cp(2, :)], [x; l_cp(3, :)]);
pgon_cp = polyshape(Polyhedron_cp(:, 1), Polyhedron_cp(:, 2));
plot(pgon_cp, 'FaceColor', 'red', 'FaceAlpha', 0.1);
legend('$f$', 'L1', 'L2', 'L3', 'L4', 'L5', 'L6', 'L7', 'L8', 'Poly1', 'Interpreter', 'latex');
hold off;
saveas(gcf, 'CP.png')
%% ACP
pause(1);
close all;
slope_acp = [-0.80, 0.76, -1.81, 0.53, 0.53, -0.83, -2.25, 0.86];
offset_acp = [5.80, -5.76, -12.21, 7.53, 0.31, -3.30, -9.43, 0.34];
Polyhedron_acp1 = zeros(4, 2);
Polyhedron_acp2 = zeros(4, 2);
figure2_acp = figure;
hold on;
plot(f_sim(1), f_sim(2), '.b', 'markersize', 10);
l_acp = zeros(length(slope_acp), length(x));

for i = 1:number_of_lines
    l_acp(i, :) = slope_acp(i) * x + offset_acp(i);

    if i < 5
        plot(x, l_acp(i, :), ':', 'LineWidth', 2);
    else
        plot(x, l_acp(i, :), 'LineWidth', 2);
    end

end

Polyhedron_acp1(1, :) = InterX([x; l_acp(1, :)], [x; l_acp(2, :)]);
Polyhedron_acp1(2, :) = InterX([x; l_acp(2, :)], [x; l_acp(3, :)]);
Polyhedron_acp1(3, :) = InterX([x; l_acp(3, :)], [x; l_acp(4, :)]);
Polyhedron_acp1(4, :) = InterX([x; l_acp(4, :)], [x; l_acp(1, :)]);
pgon_acp1 = polyshape(Polyhedron_acp1(:, 1), Polyhedron_acp1(:, 2));
plot(pgon_acp1, 'FaceColor', 'blue', 'FaceAlpha', 0.1);
Polyhedron_acp2(1, :) = InterX([x; l_acp(5, :)], [x; l_acp(6, :)]);
Polyhedron_acp2(2, :) = InterX([x; l_acp(5, :)], [x; l_acp(7, :)]);
Polyhedron_acp2(4, :) = InterX([x; l_acp(6, :)], [x; l_acp(8, :)]);
Polyhedron_acp2(3, :) = InterX([x; l_acp(7, :)], [x; l_acp(8, :)]);
pgon_acp2 = polyshape(Polyhedron_acp2(:, 1), Polyhedron_acp2(:, 2));
plot(pgon_acp2, 'FaceColor', 'green', 'FaceAlpha', 0.5);
legend('$f$', 'L1', 'L2', 'L3', 'L4', 'L5', 'L6', 'L7', 'L8', 'Poly1', 'Poly2', 'Interpreter', 'latex');
hold off;
saveas(gcf, 'ACP.png')
