clear;
clc;
close all;
%% load data and prepare result packet
% s = 10
load('simulation_result_N=1000_n=50_s=10_T=10_montecarlo_itr=200');
simulaiton_result_s10 = simulaiton_result.temp;
% s = 20
load('simulation_result_N=1000_n=50_s=20_T=10_montecarlo_itr=200');
simulaiton_result_s20 = simulaiton_result.temp;
% s = 30
load('simulation_result_N=1000_n=50_s=30_T=10_montecarlo_itr=200');
simulaiton_result_s30 = simulaiton_result.temp;
%% save final data
simulaiton_result.total_itr_number = simulaiton_result.temp.total_itr_number;
simulaiton_result.min_m = simulaiton_result.temp.min_m;
simulaiton_result.step_m = simulaiton_result.temp.step_m;
simulaiton_result.plot_pause_time = 5;
simulaiton_result.simulaiton_result_s10 = simulaiton_result_s10;
simulaiton_result.simulaiton_result_s20 = simulaiton_result_s20;
simulaiton_result.simulaiton_result_s30 = simulaiton_result_s30;
simulaiton_result = rmfield(simulaiton_result, 'temp');
save('final_result', 'simulaiton_result');
%% cleanup repository
file_name = 'compare_*.tex';
delete(file_name);
clear;
load('final_result');
%% get git hash
[~, git_hash_char] = system('git rev-parse --short HEAD');
git_hash_string = convertCharsToStrings(git_hash_char);
git_hash_string = strtrim(git_hash_string);
%% compare recunstruction error
close all;
hold on;
plot(((0:(simulaiton_result.total_itr_number - 1)) * simulaiton_result.step_m + simulaiton_result.min_m), 10 * log10(simulaiton_result.simulaiton_result_s10.error_lp), ...
    'DisplayName', 'LP', 'Marker', '*', 'LineStyle', '-.', 'Color', [0 0.5 0], 'LineWidth', 1.5);
plot(((0:(simulaiton_result.total_itr_number - 1)) * simulaiton_result.step_m + simulaiton_result.min_m), 10 * log10(simulaiton_result.simulaiton_result_s10.error_cp), ...
    'DisplayName', 'CP', 'Marker', 'diamond', 'LineStyle', '--', 'Color', [1 0 0], 'LineWidth', 1.5);
plot(((0:(simulaiton_result.total_itr_number - 1)) * simulaiton_result.step_m + simulaiton_result.min_m), 10 * log10(simulaiton_result.simulaiton_result_s10.error_acp), ...
    'DisplayName', 'Our algorithm', 'Marker', 'square', 'Color', [0 0 1], 'LineWidth', 1.5);
legend('LP', 'CP', 'Our algorithm');
ylabel('Nomalized reconstruction error (dB)');
xlabel('Number of measurments');
hold off;
pause(simulaiton_result.plot_pause_time);
TikzName = convertStringsToChars(strcat('compare_recunstruction_error_', git_hash_string, '.tex'));
matlab2tikz(TikzName);
%% compare runtime
close all;
hold on;
plot(((0:(simulaiton_result.total_itr_number - 1)) * simulaiton_result.step_m + simulaiton_result.min_m), simulaiton_result.simulaiton_result_s20.time_lp, ...
    'DisplayName', 'LP', 'Marker', '*', 'LineStyle', '-.', 'Color', [0 0.5 0], 'LineWidth', 1.5);
plot(((0:(simulaiton_result.total_itr_number - 1)) * simulaiton_result.step_m + simulaiton_result.min_m), simulaiton_result.simulaiton_result_s20.time_cp, ...
    'DisplayName', 'CP', 'Marker', 'diamond', 'LineStyle', '--', 'Color', [1 0 0], 'LineWidth', 1.5);
plot(((0:(simulaiton_result.total_itr_number - 1)) * simulaiton_result.step_m + simulaiton_result.min_m), simulaiton_result.simulaiton_result_s20.time_acp, ...
    'DisplayName', 'Our algorithm', 'Marker', 'square', 'Color', [0 0 1], 'LineWidth', 1.5);
legend('LP', 'CP', 'Our algorithm');
ylabel('Nomalized runtime (ms)');
xlabel('Number of measurments');
hold off;
pause(simulaiton_result.plot_pause_time);
TikzName = convertStringsToChars(strcat('compare_runtime_', git_hash_string, '.tex'));
matlab2tikz(TikzName);
%% compare sparsity effects
close all;
hold on;
plot(((0:(simulaiton_result.total_itr_number - 1)) * simulaiton_result.step_m + simulaiton_result.min_m), 10 * log10(simulaiton_result.simulaiton_result_s10.error_acp), ...
    'DisplayName', 's = 10', 'Marker', '*', 'LineStyle', '-.', 'Color', [0 0.5 0], 'LineWidth', 1.5);
plot(((0:(simulaiton_result.total_itr_number - 1)) * simulaiton_result.step_m + simulaiton_result.min_m), 10 * log10(simulaiton_result.simulaiton_result_s20.error_acp), ...
    'DisplayName', 's = 20', 'Marker', 'diamond', 'LineStyle', '--', 'Color', [1 0 0], 'LineWidth', 1.5);
plot(((0:(simulaiton_result.total_itr_number - 1)) * simulaiton_result.step_m + simulaiton_result.min_m), 10 * log10(simulaiton_result.simulaiton_result_s30.error_acp), ...
    'DisplayName', 's = 30', 'Marker', 'square', 'Color', [0 0 1], 'LineWidth', 1.5);
legend('s = 10', 's = 20', 's = 30');
ylabel('Nomalized reconstruction error (dB)');
xlabel('Number of measurments');
hold off;
pause(simulaiton_result.plot_pause_time);
TikzName = convertStringsToChars(strcat('compare_sparsity_effects_', git_hash_string, '.tex'));
matlab2tikz(TikzName);
