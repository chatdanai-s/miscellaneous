%% TaCompare - Program to compare analytical and numerical solution
%           - of the diffusion equation (modified from dftcs)
% -- Chatdanai Sawangwong / 6505066
clear; help TaCompare;  % Clear memory and print header

%% * Initialize parameters (time step, grid spacing, etc.).
tau = input('Enter time step: ');
N = input('Enter the number of grid points: ');
L = 1.;       % The system extends from x=-L/2 to x=L/2
h = L/(N-1);  % Grid size
kappa = 1.;   % Diffusion coefficient

% Determine stability of solution
coeff = kappa*tau/h^2;
if( coeff < 0.5 )
  disp('Solution is expected to be stable');
else
  disp('WARNING: Solution is expected to be unstable');
end

%% * Set initial and boundary conditions.
tt = zeros(N,1);          % Initialize temperature to zero at all points
tt(round(N/2)) = 1/h;     % Initial cond. is delta function in center
%- The boundary conditions are tt(1) = tt(N) = 0

%% * Set up loop and plot variables.
xplot = (0:N-1)*h - L/2;   % Record the x scale for plots
iplot = 1;                 % Counter used to count plots
nstep = 300;               % Maximum number of iterations
nplots = 50;               % Number of snapshots (plots) to take
plot_step = nstep/nplots;  % Number of time steps between plots

%% * Loop over the desired number of time steps.
for istep=1:nstep  %% MAIN LOOP %%

  %* Compute new temperature using FTCS scheme.
  tt(2:(N-1)) = tt(2:(N-1)) + ...
      coeff * (tt(3:N) + tt(1:(N-2)) - 2*tt(2:(N-1)));
  
  %* Periodically record temperature for plotting.
  if( rem(istep, plot_step) < 1 )   % Every plot_step steps
    ttplot(:, iplot) = tt(:);       % record tt(i) for plotting
    tplot(iplot) = istep*tau;       % Record time for plots
    iplot = iplot+1;
  end
end

%% * From TaPlotter, acquire analytical solutions of t, x, and tt.
% Function to evaluate analytical solution
function result = T(t, x)
    result = 0; % Initialize
    L = 1;      % Length of boundary
    kappa = 1;  % Diffusion coefficient
    sigma = sqrt(2 * kappa * t);
    
    % Account only for n=-4 to n=+4
    for n = -4:4
        x_n = x + n*L;
        T_G = 1./(sigma .* sqrt(2*pi)) .* exp(-x_n.^2 ./ (2*sigma.^2));
        T_n = (-1)^n .* T_G;
        result = result + T_n;
    end
end

% Analytic solution
[tplot_mesh, xplot_mesh] = meshgrid(tplot, xplot);
Ta_plot = T(tplot_mesh, xplot_mesh);

% Absolute difference between analytic and numerical solution
T_diff = abs(Ta_plot - ttplot);

%% * Plot temperature versus x and t as wire-mesh and contour plots.
figure(1); clf;
mesh(tplot, xplot, T_diff);  % Wire-mesh surface plot
xlabel('Time');  ylabel('x');  zlabel('|T_a (x,t) - T_c(x,t)|');
title('Difference between analytic and numerical solution of delta spike diffusion');
pause(1);

figure(2); clf;       
contourLevels = 0:0.1:10;  contourLabels = 0:5;     
cs = contour(tplot, xplot, T_diff, contourLevels);  % Contour plot
clabel(cs, contourLabels);  % Add labels to selected contour levels
xlabel('Time'); ylabel('x');
title('Temperature difference Contour plot');