% balle_6505066 - Modified program to evaluate angle of
%                 maximum range of a baseball using the
%                 Euler method. -- Chatdanai Sawangwong
clear; help balle_6505066;  % Clear memory and print header


%* Set initial position and velocity of the baseball
y1 = input('Enter initial height (meters): ');   
r1 = [0, y1];   % Initial vector position
speed = input('Enter initial speed (m/s): '); 

%* Set physical parameters for air resistance (mass, Cd, etc.)
Cd = 0.35;      % Drag coefficient (dimensionless)
area = 4.3e-3;  % Cross-sectional area of projectile (m^2)
grav = 9.81;    % Gravitational acceleration (m/s^2)
mass = 0.145;   % Mass of projectile (kg)

airFlag = input('Air resistance? (Yes:1, No:0): ');
if( airFlag == 0 )
    rho = 0;      % No air resistance
else
    rho = 1.2;    % Density of air (kg/m^3)
end
air_const = -0.5*Cd*rho*area/mass;  % Air resistance constant


%* Loop for angles 10-50 deg, then inside that loop
%* Loop until ball hits ground or max steps completed
tau = input('Enter timestep, tau (sec): ');  % (sec)
maxstep = 10000;   % Maximum number of steps

range = [];        % Range per angle (Numerical)
range_noair = [];  % Range per angle (Theoretical; No drag)

%* Loop starts
for theta=10:0.2:50
    v1 = [speed*cos(theta*pi/180), ...
          speed*sin(theta*pi/180)];     % Initial velocity
    r = r1;  v = v1;  % Set initial position and velocity
    
    for istep=1:maxstep
      %* Calculate the acceleration of the ball 
      accel = air_const*norm(v)*v;   % Air resistance
      accel(2) = accel(2)-grav;      % Gravity
    
      %* Calculate the new position and velocity using Euler method
      r = r + tau*v;                 % Euler step
      v = v + tau*accel;     
    
      %* If ball reaches ground (y < 0), break out of the loop
      if( r(2) < 0 )  
        %* Record range at theta (both theoretical and numerical)
        t = (istep-1)*tau;     % Current time
        range_noair = [range_noair, r1(1) + v1(1)*t];
        range = [range, r(1)];
        break;
      end
    end
end

%* Print maximum angle and maximum range associated
theta = 10:0.2:50;
[~, idx] = max(range);

fprintf('Maximum angle is %g degrees\n', theta(idx));
fprintf('Maximum range is %g meters\n', range(1));

%* Graph angle vs range
clf;  figure(gcf);   % Clear figure window and bring it forward

plot(theta, range, '+', ...
     theta, range_noair, '-');
legend('Euler method', 'Theory (No air resistance, Theoretical)', ...
       'Location', 'southeast');
xlabel('Angle (deg)');  ylabel('Range (m)');
title('Angle vs Range of Projectile Motion');