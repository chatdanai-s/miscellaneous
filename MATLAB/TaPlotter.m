% TaPlotter - Plots analytical solution of T
%           - as provided by the problem
% -- Chatdanai Sawangwong / 6505066
clear; help TaPlotter;  % Clear memory and print header

% Evaluating diffusion function analytically
function result = T(x, t)
    result = 0; % Initialize
    L = 1;      % Length of boundary
    kappa = 1;  % Diffusion coefficient
    sigma = sqrt(2 * kappa * t);
    
    % Account only for n=-4 to n=+4
    for n = -4:4
        x_n = x + n*L;
        T_G = 1/(sigma * sqrt(2*pi)) * exp(-x_n^2/(2*sigma^2));
        T_n = (-1)^n * T_G;
        result = result + T_n;
    end
end

% Create arrays for plot
x_plot = -1.5:0.05:1.5;
time = 0.03;

T_plot = zeros(size(x_plot));
for i = 1:length(x_plot)
    T_plot(i) = T(x_plot(i), time);
end

% Plotting part
plot(x_plot, T_plot)
xlabel('x')
ylabel('T(x, t=0.03)')
title(['Plot of T(x, t=0.03) vs x, ' ...
    'reproduced according to part (a) of exercise.'])
grid on