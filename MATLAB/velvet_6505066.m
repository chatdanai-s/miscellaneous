% velvet_6505066 - Program to graph period T as function of
%                  initial angle using the Velvet method.
%                  Analytic approximations are also compared.
clc; clear; help velvet_6505066;  % Clear memory and print header

% Input length of massless string
fprintf(['* Very small (~0.0001) string length ' ...
         'recommended for accuracy and speed!\n'])
L = input('Input length of string (m): ');
g = 9.81;  % Local gravitational acceleration

% Initial angles (rad) and result periods (s)
angles = 0:0.02:3;
T_velvet = [];
T_O2 = [];
T_O4 = [];

tau = 0.00001;

% Initiate for loop
timesteps = 1e7;
for theta0 = angles
    % Initialize per loop
    theta = theta0;  % Initial position
    omega = 0;  % Initial velocity
    time = 0;   % Initial time
    irev = 0;   % Initial reversal count
    
    % Initialize period reports
    AvgPeriod = NaN;  % Default value in case no reversal happens
    ErrPeriod = NaN;

    % Velvet method determination modified from pendul.m
    % Take one backward step to start Verlet
    accel = -g/L * sin(theta0);
    theta_old = theta - omega*tau + 0.5*tau^2*accel;

    % Start loop to determine period via Velvet method
    for istep=1:timesteps
        % Update accel and time
        accel = -g/L * sin(theta);
        time = time + tau;
        % New position via Velvet method
        theta_new = 2*theta - theta_old + tau^2*accel;
        theta_old = theta;
        theta = theta_new;

        %* Test if the pendulum has passed through theta = 0;
        %    if yes, use time to estimate period
        if(theta * theta_old < 0) % Test position for sign change
            if( irev == 0 )       % If this is the first change,
                time_old = time;  % just record the time
            elseif (irev > 5)
                period(irev) = 2*(time - time_old);
                time_old = time;

                % Evaluate if error of oscillation below 1%,
                % break out of loop at theta0
                AvgPeriod = mean(period);
                ErrPeriod = std(period)/sqrt(irev);
                if ErrPeriod/AvgPeriod < 0.01
                    break;
                end
            else
            end
        irev = irev + 1;       % Increment the number of reversals
        end
    end

    % Report T_velvet
    T_velvet = [T_velvet, AvgPeriod];

    % T estimation from analytical approximations
    T_s = 2*pi*sqrt(L/g);
    T_O2 = [T_O2, T_s];
    T_O4 = [T_O4, T_s * (1 + theta0^2 / 16)];
end

% Graph angle (deg) vs period (s)
clf;  figure(gcf);   % Clear figure window and bring it forward
angles = angles * 180/pi;

plot(angles, T_O2, '-', ...
     angles, T_O4, '-', ...
     angles, T_velvet, '.');

legend('Small angle (0th order) approximation', ...
       'Second order approximation', ...
       'Numerical approximation (Velvet method)', ...
       'Location', 'northwest');

xlabel('Initial angle (deg)');  ylabel('Period (s)');
title('Angle vs Period of Simple Pendulum');

% Find indices which errors exceed 10% for each approximation
idx_O2 = find(T_velvet ./ T_O2 > 1.1, 1, 'first');
idx_O4 = find(T_velvet ./ T_O4 > 1.1, 1, 'first');

% Angles which errors exceed 10% and report
errAngle_O2 = angles(idx_O2);
errAngle_O4 = angles(idx_O4);

% Report theta where errors exceed 10%
fprintf('===== REPORT =====\n')
fprintf('Small angle approx. has 0.1 error at: %g deg\n', errAngle_O2);
fprintf('2nd order approx. has 0.1 error at: %g deg\n', errAngle_O4);
