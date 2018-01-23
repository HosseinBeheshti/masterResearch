clear;
close all;
clc;
%% load data
Error_CP_Tt = zeros(3,200);
Error_ACP_Tt = zeros(3,200);
load('SimResult_N=1000_n=50_s=10');
Error_CP_Tt(1,:) = Error_CP_T;
Error_ACP_Tt(1,:) = Error_ACP_T;
load('SimResult_N=1000_n=50_s=20');
Error_CP_Tt(2,:) = Error_CP_T;
Error_ACP_Tt(2,:) = Error_ACP_T;
load('SimResult_N=1000_n=50_s=30');
Error_CP_Tt(3,:) = Error_CP_T;
Error_ACP_Tt(3,:) = Error_ACP_T;
%% plot result
close all;
hold all;
legendInfo = cell(1,6);
for s_it=1:3
    plot(((0:(T_it_number-1))*Step_m+Min_m),10*log10(Error_CP_Tt(s_it,:)));
    legendInfo{s_it} = ['CP s = ' num2str((s_it)*10)];
end

for s_it=1:3
    plot(((0:(T_it_number-1))*Step_m+Min_m),10*log10(Error_ACP_Tt(s_it,:)));
    legendInfo{3+s_it} = ['ACP s = ' num2str((s_it)*10)];
end

legend(legendInfo)
ylabel('Reconstruction Error (dB)')
xlabel('measurments')

hold off;
