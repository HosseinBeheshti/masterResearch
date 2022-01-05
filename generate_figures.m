clear;
clc;
close all;
%% get git hash
[~,git_hash_char] = system('git rev-parse --short HEAD');
git_hash_string = convertCharsToStrings(git_hash_char);
git_hash_string = strtrim(git_hash_string);
%% plot result
load('SimResult_N=1000_n=50_s=5_T=10_montecarlo_itr=200');
%% compare recunstruction error
hold on;
plot(((0:(T_it_number-1))*Step_m+Min_m),10*log10(Error_LP_T),'DisplayName','LP','Marker','*','LineStyle','-.',...
    'Color',[0 0.5 0],'LineWidth',1.5);
plot(((0:(T_it_number-1))*Step_m+Min_m),10*log10(Error_CP_T),'DisplayName','CP','Marker','diamond','LineStyle','--',...
    'Color',[1 0 0],'LineWidth',1.5);
plot(((0:(T_it_number-1))*Step_m+Min_m),10*log10(Error_ACP_T),'DisplayName','Our algorithm','Marker','square',...
    'Color',[0 0 1],'LineWidth',1.5);
legend('LP','CP','Our algorithm')
ylabel('Nomalized reconstruction error (dB)')
xlabel('Number of measurments')
hold off;
TikzName=['compare_recunstruction_error_',git_hash_string,'.tex'];
matlab2tikz(TikzName)
%% compare runtime
hold on;
plot(((0:(T_it_number-1))*Step_m+Min_m),10*log10(time_LP_T),'DisplayName','LP','Marker','*','LineStyle','-.',...
    'Color',[0 0.5 0],'LineWidth',1.5);
plot(((0:(T_it_number-1))*Step_m+Min_m),10*log10(time_CP_T),'DisplayName','CP','Marker','diamond','LineStyle','--',...
    'Color',[1 0 0],'LineWidth',1.5);
plot(((0:(T_it_number-1))*Step_m+Min_m),10*log10(time_ACP_T),'DisplayName','Our algorithm','Marker','square',...
    'Color',[0 0 1],'LineWidth',1.5);
legend('LP','CP','Our algorithm')
ylabel('Nomalized runtime (ms)')
xlabel('Number of measurments')
hold off;
TikzName = strcat('compare_runtime_',git_hash_string,'.tex');
matlab2tikz(TikzName)
%% generate
