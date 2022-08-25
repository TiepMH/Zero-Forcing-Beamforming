clear all; clc;

%% Code is based on the mathematical expressions in Jianqi Wang's paper
% Here, alpha = 1/mu = water level.

%%
N = 3;
SNR_dB = 10; % SNR in dB
P = 10^(SNR_dB / 10);

gamma_list=[1;2;3];

% Bisection search for alpha. Again, alpha is the water level
alpha_low = min(1 ./ gamma_list);
%mu_high = 1/alpha_low;

alpha_high = (P + sum(1 ./ gamma_list)) / N;
%mu_low = 1/alpha_high;

stop_threshold = 1e-5; % Stop threshold

% Iterate while low/high bounds are futher than stop_threshold
while(abs(alpha_high - alpha_low) > stop_threshold)
    alpha = (alpha_high + alpha_low)/2; % Test value in the middle of low/high
    mu = 1/alpha;
    %
    power_list = zeros(N,1);
    for k=1:N
        gamma_k = gamma_list(k);
        power_k = max(1/mu - 1/gamma_k, 0);
        power_list(k) = power_k;
    end
    
    sum_pk = sum(power_list);
    if (sum_pk > P)
        alpha_high = alpha;
    else
        alpha_low = alpha;
    end
end

%%
R_sum = 0;
for k=1:N
    gamma_k = gamma_list(k);
    power_k = power_list(k);
    R_sum = R_sum + log2(1 + gamma_k*power_k);
end

% Print the achievable rate in bits/s
disp(['Sum rate = ', num2str(R_sum), ' bits/s'])

disp(['Power Limit - Sum of Powers = ', num2str( P - sum_pk )])
