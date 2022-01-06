clear;
clc;
close all;
%% load data and prepare result packet
Max_m = 40000;
Step_m = 1000;
Min_m = 500;
T_it_number = floor((Max_m - Min_m) / Step_m) + 1;
simulaiton_result.iteration_number = T_it_number;
simulaiton_result.simulaiton_result.step_m = Step_m;
simulaiton_result.min_m = Min_m;
% s = 5
simulaiton_result.s5.error_lp = zeros(1, simulaiton_result.iteration_number);
simulaiton_result.s5.error_cp = zeros(1, simulaiton_result.iteration_number);
simulaiton_result.s5.error_acp = zeros(1, simulaiton_result.iteration_number);
simulaiton_result.s5.time_lp = zeros(1, simulaiton_result.iteration_number);
simulaiton_result.s5.time_cp = zeros(1, simulaiton_result.iteration_number);
simulaiton_result.s5.time_acp = zeros(1, simulaiton_result.iteration_number);
% s = 10
simulaiton_result.s10.error_lp = zeros(1, simulaiton_result.iteration_number);
simulaiton_result.s10.error_cp = zeros(1, simulaiton_result.iteration_number);
simulaiton_result.s10.error_acp = zeros(1, simulaiton_result.iteration_number);
simulaiton_result.s10.time_lp = zeros(1, simulaiton_result.iteration_number);
simulaiton_result.s10.time_cp = zeros(1, simulaiton_result.iteration_number);
simulaiton_result.s10.time_acp = zeros(1, simulaiton_result.iteration_number);
% s = 20
simulaiton_result.s20.error_lp = zeros(1, simulaiton_result.iteration_number);
simulaiton_result.s20.error_cp = zeros(1, simulaiton_result.iteration_number);
simulaiton_result.s20.error_acp = zeros(1, simulaiton_result.iteration_number);
simulaiton_result.s20.time_lp = zeros(1, simulaiton_result.iteration_number);
simulaiton_result.s20.time_cp = zeros(1, simulaiton_result.iteration_number);
simulaiton_result.s20.time_acp = zeros(1, simulaiton_result.iteration_number);
% fill result arguments
load('SimResult_N=1000_n=50_s=5_T=10_montecarlo_itr=200');
simulaiton_result.s5.error_lp = Error_LP_T;
simulaiton_result.s5.error_cp = Error_CP_T;
simulaiton_result.s5.error_acp = Error_ACP_T;
simulaiton_result.s5.time_lp = time_LP_T;
simulaiton_result.s5.time_cp = time_CP_T;
simulaiton_result.s5.time_acp = time_ACP_T;
load('SimResult_N=1000_n=50_s=10_T=10_montecarlo_itr=200');
simulaiton_result.s10.error_lp = Error_LP_T;
simulaiton_result.s10.error_cp = Error_CP_T;
simulaiton_result.s10.error_acp = Error_ACP_T;
simulaiton_result.s10.time_lp = time_LP_T;
simulaiton_result.s10.time_cp = time_CP_T;
simulaiton_result.s10.time_acp = time_ACP_T;
load('SimResult_N=1000_n=50_s=20_T=10_montecarlo_itr=200');
simulaiton_result.s20.error_lp = Error_LP_T;
simulaiton_result.s20.error_cp = Error_CP_T;
simulaiton_result.s20.error_acp = Error_ACP_T;
simulaiton_result.s20.time_lp = time_LP_T;
simulaiton_result.s20.time_cp = time_CP_T;
simulaiton_result.s20.time_acp = time_ACP_T;
save('final_result', 'simulaiton_result');
% temporary commented delete SimResult_ *;
clear;
load('final_result');
%% get git hash
[~, git_hash_char] = system('git rev-parse --short HEAD');
git_hash_string = convertCharsToStrings(git_hash_char);
git_hash_string = strtrim(git_hash_string);
%% compare recunstruction error
hold on;
plot(((0:(simulaiton_result.iteration_number - 1)) * simulaiton_result.step_m + simulaiton_result.min_m), 10 * log10(simulaiton_result.s20.error_lp), ...
    'DisplayName', 'LP', 'Marker', '*', 'LineStyle', '-.', 'Color', [0 0.5 0], 'LineWidth', 1.5);
plot(((0:(simulaiton_result.iteration_number - 1)) * simulaiton_result.step_m + simulaiton_result.min_m), 10 * log10(simulaiton_result.s20.error_cp), ...
    'DisplayName', 'CP', 'Marker', 'diamond', 'LineStyle', '--', 'Color', [1 0 0], 'LineWidth', 1.5);
plot(((0:(simulaiton_result.iteration_number - 1)) * simulaiton_result.step_m + simulaiton_result.min_m), 10 * log10(simulaiton_result.s20.error_acp), ...
    'DisplayName', 'Our algorithm', 'Marker', 'square', 'Color', [0 0 1], 'LineWidth', 1.5);
legend('LP', 'CP', 'Our algorithm');
ylabel('Nomalized reconstruction error (dB)');
xlabel('Number of measurments');
hold off;
TikzName = strcat('compare_recunstruction_error_', git_hash_string, '.tex');
matlab2tikz(TikzName);
%% compare runtime
hold on;
plot(((0:(simulaiton_result.iteration_number - 1)) * simulaiton_result.step_m + simulaiton_result.min_m), simulaiton_result.s20.time_lp, ...
    'DisplayName', 'LP', 'Marker', '*', 'LineStyle', '-.', 'Color', [0 0.5 0], 'LineWidth', 1.5);
plot(((0:(simulaiton_result.iteration_number - 1)) * simulaiton_result.step_m + simulaiton_result.min_m), simulaiton_result.s20.time_cp, ...
    'DisplayName', 'CP', 'Marker', 'diamond', 'LineStyle', '--', 'Color', [1 0 0], 'LineWidth', 1.5);
plot(((0:(simulaiton_result.iteration_number - 1)) * simulaiton_result.step_m + simulaiton_result.min_m), simulaiton_result.s20.time_acp, ...
    'DisplayName', 'Our algorithm', 'Marker', 'square', 'Color', [0 0 1], 'LineWidth', 1.5);
legend('LP', 'CP', 'Our algorithm');
ylabel('Nomalized runtime (ms)');
xlabel('Number of measurments');
hold off;
TikzName = strcat('compare_runtime_', git_hash_string, '.tex');
matlab2tikz(TikzName);
%% compare sparsity effects
hold on;

plot(((0:(simulaiton_result.iteration_number - 1)) * simulaiton_result.step_m + simulaiton_result.min_m), 10 * log10(simulaiton_result.s5.error_acp), ...
    'DisplayName', 's = 5', 'Marker', '*', 'LineStyle', '-.', 'Color', [0 0.5 0], 'LineWidth', 1.5);
plot(((0:(simulaiton_result.iteration_number - 1)) * simulaiton_result.step_m + simulaiton_result.min_m), 10 * log10(simulaiton_result.s10.error_acp), ...
    'DisplayName', 's = 10', 'Marker', 'diamond', 'LineStyle', '--', 'Color', [1 0 0], 'LineWidth', 1.5);
plot(((0:(simulaiton_result.iteration_number - 1)) * simulaiton_result.step_m + simulaiton_result.min_m), 10 * log10(simulaiton_result.s20.error_acp), ...
    'DisplayName', 's = 20', 'Marker', 'square', 'Color', [0 0 1], 'LineWidth', 1.5);
legend('s = 5', 's = 10', 's = 20');
ylabel('Nomalized reconstruction error (dB)');
xlabel('Number of measurments');
hold off;
TikzName = strcat('compare_sparsity_effects_', git_hash_string, '.tex');
matlab2tikz(TikzName)
