clear;
clc;
close all;
%% load data and prepare result packet
% s = 10
simulaiton_result.s10.error_lp = zeros(1, simulaiton_result.total_itr_number);
simulaiton_result.s10.error_cp = zeros(1, simulaiton_result.total_itr_number);
simulaiton_result.s10.error_acp = zeros(1, simulaiton_result.total_itr_number);
simulaiton_result.s10.time_lp = zeros(1, simulaiton_result.total_itr_number);
simulaiton_result.s10.time_cp = zeros(1, simulaiton_result.total_itr_number);
simulaiton_result.s10.time_acp = zeros(1, simulaiton_result.total_itr_number);
% s = 20
simulaiton_result.s20.error_lp = zeros(1, simulaiton_result.total_itr_number);
simulaiton_result.s20.error_cp = zeros(1, simulaiton_result.total_itr_number);
simulaiton_result.s20.error_acp = zeros(1, simulaiton_result.total_itr_number);
simulaiton_result.s20.time_lp = zeros(1, simulaiton_result.total_itr_number);
simulaiton_result.s20.time_cp = zeros(1, simulaiton_result.total_itr_number);
simulaiton_result.s20.time_acp = zeros(1, simulaiton_result.total_itr_number);
% s = 20
simulaiton_result.s30.error_lp = zeros(1, simulaiton_result.total_itr_number);
simulaiton_result.s30.error_cp = zeros(1, simulaiton_result.total_itr_number);
simulaiton_result.s30.error_acp = zeros(1, simulaiton_result.total_itr_number);
simulaiton_result.s30.time_lp = zeros(1, simulaiton_result.total_itr_number);
simulaiton_result.s30.time_cp = zeros(1, simulaiton_result.total_itr_number);
simulaiton_result.s30.time_acp = zeros(1, simulaiton_result.total_itr_number);
% fill result arguments
load('SimResult_N=1000_n=50_s=10_T=10_montecarlo_itr=100');
simulaiton_result.s10.error_lp = Error_LP_T;
simulaiton_result.s10.error_cp = Error_CP_T;
simulaiton_result.s10.error_acp = Error_ACP_T;
simulaiton_result.s10.time_lp = time_LP_T;
simulaiton_result.s10.time_cp = time_CP_T;
simulaiton_result.s10.time_acp = time_ACP_T;
load('SimResult_N=1000_n=50_s=20_T=10_montecarlo_itr=100');
simulaiton_result.s20.error_lp = Error_LP_T;
simulaiton_result.s20.error_cp = Error_CP_T;
simulaiton_result.s20.error_acp = Error_ACP_T;
simulaiton_result.s20.time_lp = time_LP_T;
simulaiton_result.s20.time_cp = time_CP_T;
simulaiton_result.s20.time_acp = time_ACP_T;
load('SimResult_N=1000_n=50_s=30_T=10_montecarlo_itr=100');
simulaiton_result.s30.error_lp = Error_LP_T;
simulaiton_result.s30.error_cp = Error_CP_T;
simulaiton_result.s30.error_acp = Error_ACP_T;
simulaiton_result.s30.time_lp = time_LP_T;
simulaiton_result.s30.time_cp = time_CP_T;
simulaiton_result.s30.time_acp = time_ACP_T;
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
plot(((0:(simulaiton_result.total_itr_number - 1)) * simulaiton_result.step_m + simulaiton_result.min_m), 10 * log10(simulaiton_result.s20.error_lp), ...
    'DisplayName', 'LP', 'Marker', '*', 'LineStyle', '-.', 'Color', [0 0.5 0], 'LineWidth', 1.5);
plot(((0:(simulaiton_result.total_itr_number - 1)) * simulaiton_result.step_m + simulaiton_result.min_m), 10 * log10(simulaiton_result.s20.error_cp), ...
    'DisplayName', 'CP', 'Marker', 'diamond', 'LineStyle', '--', 'Color', [1 0 0], 'LineWidth', 1.5);
plot(((0:(simulaiton_result.total_itr_number - 1)) * simulaiton_result.step_m + simulaiton_result.min_m), 10 * log10(simulaiton_result.s20.error_acp), ...
    'DisplayName', 'Our algorithm', 'Marker', 'square', 'Color', [0 0 1], 'LineWidth', 1.5);
legend('LP', 'CP', 'Our algorithm');
ylabel('Nomalized reconstruction error (dB)');
xlabel('Number of measurments');
hold off;
TikzName = strcat('compare_recunstruction_error_', git_hash_string, '.tex');
matlab2tikz(TikzName);
%% compare runtime
hold on;
plot(((0:(simulaiton_result.total_itr_number - 1)) * simulaiton_result.step_m + simulaiton_result.min_m), simulaiton_result.s20.time_lp, ...
    'DisplayName', 'LP', 'Marker', '*', 'LineStyle', '-.', 'Color', [0 0.5 0], 'LineWidth', 1.5);
plot(((0:(simulaiton_result.total_itr_number - 1)) * simulaiton_result.step_m + simulaiton_result.min_m), simulaiton_result.s20.time_cp, ...
    'DisplayName', 'CP', 'Marker', 'diamond', 'LineStyle', '--', 'Color', [1 0 0], 'LineWidth', 1.5);
plot(((0:(simulaiton_result.total_itr_number - 1)) * simulaiton_result.step_m + simulaiton_result.min_m), simulaiton_result.s20.time_acp, ...
    'DisplayName', 'Our algorithm', 'Marker', 'square', 'Color', [0 0 1], 'LineWidth', 1.5);
legend('LP', 'CP', 'Our algorithm');
ylabel('Nomalized runtime (ms)');
xlabel('Number of measurments');
hold off;
TikzName = strcat('compare_runtime_', git_hash_string, '.tex');
matlab2tikz(TikzName);
%% compare sparsity effects
hold on;

plot(((0:(simulaiton_result.total_itr_number - 1)) * simulaiton_result.step_m + simulaiton_result.min_m), 10 * log10(simulaiton_result.s10.error_acp), ...
    'DisplayName', 's = 10', 'Marker', '*', 'LineStyle', '-.', 'Color', [0 0.5 0], 'LineWidth', 1.5);
plot(((0:(simulaiton_result.total_itr_number - 1)) * simulaiton_result.step_m + simulaiton_result.min_m), 10 * log10(simulaiton_result.s20.error_acp), ...
    'DisplayName', 's = 20', 'Marker', 'diamond', 'LineStyle', '--', 'Color', [1 0 0], 'LineWidth', 1.5);
plot(((0:(simulaiton_result.total_itr_number - 1)) * simulaiton_result.step_m + simulaiton_result.min_m), 10 * log10(simulaiton_result.s30.error_acp), ...
    'DisplayName', 's = 30', 'Marker', 'square', 'Color', [0 0 1], 'LineWidth', 1.5);
legend('s = 10', 's = 20', 's = 30');
ylabel('Nomalized reconstruction error (dB)');
xlabel('Number of measurments');
hold off;
TikzName = strcat('compare_sparsity_effects_', git_hash_string, '.tex');
matlab2tikz(TikzName)
