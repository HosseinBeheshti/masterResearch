clear;
clc;
close all;
tic;
%% monte carlo
max_mcr = 200;
%% number of measurements
max_m = 40000;
step_m = 1000;
min_m = 500;
total_itr_number = floor((max_m - min_m) / step_m) + 1;
%% allocate vectors
error_lp = zeros(1, total_itr_number);
error_cp = zeros(1, total_itr_number);
error_acp = zeros(1, total_itr_number);
time_lp = zeros(1, total_itr_number);
time_cp = zeros(1, total_itr_number);
time_acp = zeros(1, total_itr_number);
%% file name
TempName = 'TempFile_';
SimFileName = 'SimResult';
%% signal properties
N = 1000; % size of x
n = 50; % number of dictionary rows
T = 10; % number of batch
s = [5 10 20]';
%%
simulaiton_result.total_itr_number = total_itr_number;
simulaiton_result.step_m = step_m;
simulaiton_result.min_m = min_m;
simulaiton_result.temp.error_lp = zeros(1, total_itr_number);
simulaiton_result.temp.error_cp = zeros(1, total_itr_number);
simulaiton_result.temp.error_acp = zeros(1, total_itr_number);
simulaiton_result.temp.time_lp = zeros(1, total_itr_number);
simulaiton_result.temp.time_cp = zeros(1, total_itr_number);
simulaiton_result.temp.time_acp = zeros(1, total_itr_number);
%% main loop
for sparsity_irt = 1:length(s)
    notif = ['start simulation with sparsity: ', num2str(s(sparsity_irt)), ' monte_carlo progress:'];
    textprogressbar(notif);

    for mcr = 1:max_mcr

        parfor itr_i = 1:total_itr_number
            %% Generate signal
            % define the sparse vector x
            supp = sort(randsample(N, s(sparsity_irt)));
            x = zeros(N, 1);
            x(supp) = randn(s(sparsity_irt), 1);
            % Generate dictionary
            D = DictionaryGenerator(n, N);
            f = D * x;
            r = 2 * norm(f);
            % specify the random measurements to be used
            m = (itr_i - 1) * step_m + min_m;
            A = randn(m, n);
            %% LP
            tic;
            fLP_main = LP_main(D, A, f, r);
            time_lp(itr_i) = toc;
            %% CP
            tic;
            fCP_main = CP_main(D, A, f, r, r);
            time_lp(itr_i) = toc;
            %% Adaptive CP
            tic;
            fACP_main = ACP_main(D, A, f, r, T);
            time_lp(itr_i) = toc;
            %% Compute error
            err_lp = norm(fLP_main - f) / norm(f);
            err_cp = norm(fCP_main - f) / norm(f);
            err_acp = norm(fACP_main(:, end) - f) / norm(f);
            error_lp(itr_i) = err_lp;
            error_cp(itr_i) = err_cp;
            error_acp(itr_i) = err_acp;
        end

        FileName = [TempName, num2str(mcr)];
        save(FileName);
        textprogressbar(mcr);
    end

    %% Compute data average
    for mcr = 1:max_mcr
        FileName = [TempName, num2str(mcr)];
        load(FileName)
        simulaiton_result.temp.error_lp = simulaiton_result.temp.error_lp + error_lp;
        simulaiton_result.temp.error_cp = simulaiton_result.temp.error_cp + error_cp;
        simulaiton_result.temp.error_acp = simulaiton_result.temp.error_acp + error_acp;
        simulaiton_result.temp.time_lp = simulaiton_result.temp.time_lp + time_lp;
        simulaiton_result.temp.time_cp = simulaiton_result.temp.time_cp + time_cp;
        simulaiton_result.temp.time_acp = simulaiton_result.temp.time_acp + time_acp;
    end

    simulaiton_result.temp.error_lp = simulaiton_result.temp.error_lp ./ max_mcr;
    simulaiton_result.temp.error_cp = simulaiton_result.temp.error_cp ./ max_mcr;
    simulaiton_result.temp.error_acp = simulaiton_result.temp.error_acp ./ max_mcr;
    simulaiton_result.temp.time_lp = simulaiton_result.temp.time_lp ./ max_mcr;
    simulaiton_result.temp.time_cp = simulaiton_result.temp.time_cp ./ max_mcr;
    simulaiton_result.temp.time_acp = simulaiton_result.temp.time_acp ./ max_mcr;
    %% remove temporary file and save
    for mcr = 1:max_mcr
        FileName = [TempName, num2str(mcr)];
        delete TempFile_ *;
    end

    SimName = [SimFileName, '_N=', num2str(N), '_n=', num2str(n), '_s=', num2str(s(sparsity_irt)), '_T=', num2str(T), '_montecarlo_itr=', num2str(max_mcr)];
    save(SimName, 'simulaiton_result');
end

%%
disp("simulation finished");
toc
