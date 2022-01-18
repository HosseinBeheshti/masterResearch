clear;
clc;
close all;
%% load data
load('final_result');
%% get git hash
[~, git_hash_char] = system('git rev-parse --short HEAD');
git_hash_string = convertCharsToStrings(git_hash_char);
git_hash_string = strtrim(git_hash_string);
plot_pause_time = 1;
%% compare recunstruction error
close all;
hold on;
plot(((0:(final_result.total_itr_number - 1)) * final_result.step_m + final_result.min_m), final_result.final_result_s20.error_lp, ...
    'DisplayName', 'LP', 'Marker', '*', 'LineStyle', '-.', 'Color', [0 0.5 0], 'LineWidth', 1.5);
plot(((0:(final_result.total_itr_number - 1)) * final_result.step_m + final_result.min_m), final_result.final_result_s20.error_cp, ...
    'DisplayName', 'CP', 'Marker', 'diamond', 'LineStyle', '--', 'Color', [1 0 0], 'LineWidth', 1.5);
plot(((0:(final_result.total_itr_number - 1)) * final_result.step_m + final_result.min_m), final_result.final_result_s20.error_acp, ...
    'DisplayName', 'Our algorithm', 'Marker', 'square', 'Color', [0 0 1], 'LineWidth', 1.5);
legend('LP', 'CP', 'Our algorithm');
ylabel('Nomalized reconstruction error (dB)');
xlabel('Number of measurments');
hold off;
pause(plot_pause_time);
TikzName = convertStringsToChars(strcat('compare_recunstruction_error_', git_hash_string, '.tex'));
matlab2tikz(TikzName);
%% compare runtime
close all;
hold on;
plot(((0:(final_result.total_itr_number - 1)) * final_result.step_m + final_result.min_m), final_result.final_result_s20.time_lp, ...
    'DisplayName', 'LP', 'Marker', '*', 'LineStyle', '-.', 'Color', [0 0.5 0], 'LineWidth', 1.5);
plot(((0:(final_result.total_itr_number - 1)) * final_result.step_m + final_result.min_m), final_result.final_result_s20.time_cp, ...
    'DisplayName', 'CP', 'Marker', 'diamond', 'LineStyle', '--', 'Color', [1 0 0], 'LineWidth', 1.5);
plot(((0:(final_result.total_itr_number - 1)) * final_result.step_m + final_result.min_m), final_result.final_result_s20.time_acp, ...
    'DisplayName', 'Our algorithm', 'Marker', 'square', 'Color', [0 0 1], 'LineWidth', 1.5);
legend('LP', 'CP', 'Our algorithm');
ylabel('Nomalized runtime (ms)');
xlabel('Number of measurments');
hold off;
pause(plot_pause_time);
TikzName = convertStringsToChars(strcat('compare_runtime_', git_hash_string, '.tex'));
matlab2tikz(TikzName);
%% compare sparsity effects
close all;
hold on;
plot(((0:(final_result.total_itr_number - 1)) * final_result.step_m + final_result.min_m), final_result.final_result_s20.error_acp, ...
    'DisplayName', 's = 20', 'Marker', 'diamond', 'LineStyle', '--', 'Color', [1 0 0], 'LineWidth', 1.5);
plot(((0:(final_result.total_itr_number - 1)) * final_result.step_m + final_result.min_m), final_result.final_result_s30.error_acp, ...
    'DisplayName', 's = 30', 'Marker', 'square', 'Color', [0 0 1], 'LineWidth', 1.5);
plot(((0:(final_result.total_itr_number - 1)) * final_result.step_m + final_result.min_m), final_result.final_result_s40.error_acp, ...
    'DisplayName', 's = 40', 'Marker', '*', 'LineStyle', '-.', 'Color', [0 0.5 0], 'LineWidth', 1.5);
legend('s = 20', 's = 30', 's = 40');
ylabel('Nomalized reconstruction error (dB)');
xlabel('Number of measurments');
hold off;
pause(plot_pause_time);
TikzName = convertStringsToChars(strcat('compare_sparsity_effects_', git_hash_string, '.tex'));
matlab2tikz(TikzName);
