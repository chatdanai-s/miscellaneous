% jacobi - Plots numerical solution of Laplace's equation
%        - with an upside down T-shaped boundary condition
% -- Chatdanai Sawangwong / 6505066
clear; help jacobi;  % Clear memory and print header

% Create 2D matrix (100x150) according to initial condition
phi = zeros(100, 150);
phi(100,:) = 1;

% Jacobi relaxation method on two zones: The "Bottom" and "Top"
% Sweep on the bottom up, iterate until fractional change < 1e-5
iterMax = 1e6;          % Set max to avoid excessively long runs
changeDesired = 1e-6;   % Stop when the change is given fraction
tStart = cputime;

% Main loop
for iter=1:iterMax
    newphi = phi;       % Copy of solution
    changeSum = 0;
    
    % Top section
    for i=2:51
        for j=51:99
            newphi(i,j) = .25*(phi(i+1,j)+phi(i-1,j)+ ...
                               phi(i,j-1)+phi(i,j+1));
            changeSum = changeSum + abs(1-phi(i,j)/newphi(i,j));
        end
    end

    % Bottom section
    for i=52:99
        for j=2:149
            newphi(i,j) = .25*(phi(i+1,j)+phi(i-1,j)+ ...
                               phi(i,j-1)+phi(i,j+1));
            changeSum = changeSum + abs(1-phi(i,j)/newphi(i,j));
        end
    end
    phi = newphi;

    % Check if fractional change is small enough
    if (changeSum < changeDesired)
        break;
    end
end

tStop = cputime;
fprintf('Elapsed CPU time = %g seconds\n', tStop-tStart);

% Plot final potential
x = 0:0.02:2.99;
y = 0:0.02:1.99;

mesh(x, y, phi)
axis equal

xlabel('x'); ylabel('y'); zlabel('\Phi(x,y)')
title('Potential \Phi(x,y) from T-shaped boundary condition');