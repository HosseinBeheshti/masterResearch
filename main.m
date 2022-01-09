clear;
clc;
close all;
%% monte carlo
max_mcr = 100;
%% number of measurements
max_m = 30000;
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
%% temp file name
temp_name = 'temp_file_';
%% signal properties
N = 1000; % size of x
n = 50; % number of dictionary rows
T = 10; % number of batch
s = [10 20 30]'; % sparsity level
full_simulation_sparsity = 10;
%%
simulaiton_result.temp.total_itr_number = total_itr_number;
simulaiton_result.temp.step_m = step_m;
simulaiton_result.temp.min_m = min_m;
simulaiton_result.temp.error_lp = zeros(1, total_itr_number);
simulaiton_result.temp.error_cp = zeros(1, total_itr_number);
simulaiton_result.temp.error_acp = zeros(1, total_itr_number);
simulaiton_result.temp.time_lp = zeros(1, total_itr_number);
simulaiton_result.temp.time_cp = zeros(1, total_itr_number);
simulaiton_result.temp.time_acp = zeros(1, total_itr_number);
%% main loop
for sparsity_irt = 1:length(s)
    disp('########################### H128B717 ###########################');
    notif = ['start simulation with sparsity: ', num2str(s(sparsity_irt))];
    disp(notif);
    disp('monte_carlo:');

    for mcr = 1:max_mcr
        itr_time = tic;

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
            temp_lp_time = tic;

            if (s(sparsity_irt) == full_simulation_sparsity)
                fLP_main = LP_main(D, A, f, r);
            else
                fLP_main = zeros(size(f));
            end

            time_lp(itr_i) = toc(temp_lp_time);

            %% CP
            temp_cp_time = tic;

            if (s(sparsity_irt) == full_simulation_sparsity)
                fCP_main = CP_main(D, A, f, r, r);
            else
                fCP_main = zeros(size(f));
            end

            time_cp(itr_i) = toc(temp_cp_time);

            %% Adaptive CP
            temp_acp_time = tic;
            fACP_main = ACP_main(D, A, f, r, T);
            time_acp(itr_i) = toc(temp_acp_time);
            %% Compute error
            err_lp = norm(fLP_main - f) / norm(f);
            err_cp = norm(fCP_main - f) / norm(f);
            err_acp = norm(fACP_main(:, end) - f) / norm(f);
            error_lp(itr_i) = err_lp;
            error_cp(itr_i) = err_cp;
            error_acp(itr_i) = err_acp;
        end

        file_name = [temp_name, num2str(mcr)];
        save(file_name);
        notif = [num2str(100 * mcr / max_mcr), '%', '  (iteration time: ', num2str(toc(itr_time)), ')'];
        disp(notif);
    end

    %% Compute data average
    for mcr = 1:max_mcr
        file_name = [temp_name, num2str(mcr)];
        load(file_name)
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
    file_name = [temp_name, '*.mat'];
    delete(file_name);
    SimName = ['simulation_result', '_N=', num2str(N), '_n=', num2str(n), '_s=', num2str(s(sparsity_irt)), '_T=', num2str(T), '_montecarlo_itr=', num2str(max_mcr)];
    save(SimName, 'simulaiton_result');
end

%%
disp('########################### H128B717 ###########################');
disp("simulation finished");
