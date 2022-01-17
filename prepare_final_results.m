clear;
clc;
close all;
%% load data and prepare result packet
% s = 20
load('simulation_result_N=1000_n=50_s=20_T=10_montecarlo_itr=10');
final_result_s20.error_lp = 10 * log10(mean(simulaiton_result.error_lp));
final_result_s20.error_cp = 10 * log10(mean(simulaiton_result.error_cp));
final_result_s20.error_acp = 10 * log10(mean(simulaiton_result.error_acp));
final_result_s20.time_lp = mean(simulaiton_result.time_lp);
final_result_s20.time_cp = mean(simulaiton_result.time_cp);
final_result_s20.time_acp = mean(simulaiton_result.time_acp);
% s = 30
load('simulation_result_N=1000_n=50_s=30_T=10_montecarlo_itr=10');
final_result_s30.error_lp = 10 * log10(mean(simulaiton_result.error_lp));
final_result_s30.error_cp = 10 * log10(mean(simulaiton_result.error_cp));
final_result_s30.error_acp = 10 * log10(mean(simulaiton_result.error_acp));
final_result_s30.time_lp = mean(simulaiton_result.time_lp);
final_result_s30.time_cp = mean(simulaiton_result.time_cp);
final_result_s30.time_acp = mean(simulaiton_result.time_acp);
% s = 40
load('simulation_result_N=1000_n=50_s=40_T=10_montecarlo_itr=10');
final_result_s40.error_lp = 10 * log10(mean(simulaiton_result.error_lp));
final_result_s40.error_cp = 10 * log10(mean(simulaiton_result.error_cp));
final_result_s40.error_acp = 10 * log10(mean(simulaiton_result.error_acp));
final_result_s40.time_lp = mean(simulaiton_result.time_lp);
final_result_s40.time_cp = mean(simulaiton_result.time_cp);
final_result_s40.time_acp = mean(simulaiton_result.time_acp);
%% save final data
final_result.total_itr_number = simulaiton_result.total_itr_number;
final_result.min_m = simulaiton_result.min_m;
final_result.step_m = simulaiton_result.step_m;
final_result.final_result_s20 = final_result_s20;
final_result.final_result_s30 = final_result_s30;
final_result.final_result_s40 = final_result_s40;
save('final_result', 'final_result');
%% cleanup repository
file_name = 'compare_*.tex';
delete(file_name);
clear;
