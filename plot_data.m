clear;
close all;
clc;
%% load data
Error_CP_Tt = zeros(5,200);
Error_ACP_Tt = zeros(5,200);
load('SimResult_N=1000_n=50_s=10');
Error_CP_Tt(1,:) = Error_CP_T;
Error_ACP_Tt(1,:) = Error_ACP_T;
load('SimResult_N=1000_n=50_s=20');
Error_CP_Tt(2,:) = Error_CP_T;
Error_ACP_Tt(2,:) = Error_ACP_T;
load('SimResult_N=1000_n=50_s=30');
Error_CP_Tt(3,:) = Error_CP_T;
Error_ACP_Tt(3,:) = Error_ACP_T;
load('SimResult_N=1000_n=50_s=40');
Error_CP_Tt(4,:) = Error_CP_T;
Error_ACP_Tt(4,:) = Error_ACP_T;
load('SimResult_N=1000_n=50_s=50');
Error_CP_Tt(5,:) = Error_CP_T;
Error_ACP_Tt(5,:) = Error_ACP_T;
%% plot result
close all;
hold all;
plot(100:1000:20000,10*log10(Error_ACP_Tt(1,1:10:end)),'DisplayName','s=10','Marker','o','LineStyle','-.',...
    'Color',[0 0.5 0],'LineWidth',1.5);
plot(100:1000:20000,10*log10(Error_ACP_Tt(2,1:10:end)),'DisplayName','s=20','Marker','*','LineStyle','--',...
    'Color',[1 0 0],'LineWidth',1.5);
plot(100:1000:20000,10*log10(Error_ACP_Tt(3,1:10:end)),'DisplayName','s=30','Marker','^','LineStyle',':',...
    'Color',[0 1 0],'LineWidth',1.5);
plot(100:1000:20000,10*log10(Error_ACP_Tt(4,1:10:end)),'DisplayName','s=40','Marker','diamond','LineStyle','-',...
    'Color',[0 0 1],'LineWidth',1.5);
plot(100:1000:20000,10*log10(Error_ACP_Tt(5,1:10:end)),'DisplayName','s=50','Marker','square','LineStyle','-.',...
    'Color',[1 0 1],'LineWidth',1.5);

ylabel('Nomalized reconstruction error (dB)')
xlabel('Number of measurments')

hold off;
matlab2tikz('TikzFig.tex')
