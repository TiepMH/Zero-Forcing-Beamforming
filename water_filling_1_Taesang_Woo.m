clear all; clc;

%% Code is based on the mathematical expressions in Taesang Woo's paper

%%
N = 3;
SNR_dB = 10; % SNR in dB
P = 10^(SNR_dB / 10);

gamma_list=[1;2;3];

% Bisection search for alpha. Here, alpha is the water level
mu_low = min(1 ./ gamma_list);
mu_high = (P + sum(1 ./ gamma_list)) / N;

stop_threshold = 1e-5; % Stop threshold

% Iterate while low/high bounds are futher than stop_threshold
while(abs(mu_high - mu_low) > stop_threshold)
    mu = (mu_high + mu_low)/2; % Test value in the middle of low/high
    %
    power_list = zeros(N,1);
    LHS_cond = 0;
    for k=1:N
        gamma_k = gamma_list(k);
        power_k = max(mu*gamma_k-1, 0);
        power_list(k) = power_k;
        LHS_cond = LHS_cond + max(mu-1/gamma_k, 0);
    end
    
    if (LHS_cond > P)
        mu_high = mu;
    else
        mu_low = mu;
    end
end

%%
R_sum = 0;
for k=1:N
    power_k = power_list(k);
    R_sum = R_sum + log2(1 + power_k);
end

% Print the achievable rate in bits/s
disp(['Sum rate = ', num2str(R_sum), ' bits/s'])

disp(['Power Limit - Sum of Powers = ', num2str( P - LHS_cond )])
