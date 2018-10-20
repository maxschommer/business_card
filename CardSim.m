function CardSim
%% Working Model
% Model is a rectangular card balancing on the short edge
% with a wheel removed and placed on the motor. The torque applied to the 
% wheel is the balancing action of the card. 
%      __
%      ||
%      ||
%      ||   <--- Card
% Y    ||
% ^    ||
% |    __     
% |  
% |-----> X  

%% Constants
rho = 1850;                               % FR-4 Density                             kg/m^3
T = 0.0016;                               % Thickness of Card                        meters
L = 0.0889;                               % Lengh of Card                            meters
W = 0.0508;                               % Width of Card                            meters
g = 9.8;                                  % Gravity                                  m/s^2
rand_offset = .1;                          % Offset Setpoint (for testing)            radians

%% Variables and Derived Values
% Maximum Wheel Diameter is Width of Card
wD = .04;                                 % Wheel Diameter                           meters
wM = pi*(wD/2)^2*T;                       % Wheel Mass                               kg
wI_cm_r = 1/12 * wM * (3*(wD/2)^2 + T^2); % Removal moment of Inertia of Wheel center 

w_ry = 0.0635;                            % Removal location y of center of wheel 
wI_r = wI_cm_r  + wM * w_ry^2;            % Removal moment of inertia
mC = T*L*W*rho;                           % Mass of Card unmodified                  kg

wI_cm_a = 1/2 * wM * (wD/2) ^2;           % Addition Moment of inertia of wheel around center
w_ay = 0.07;                              % Addition position of wheel
wI_a = wI_cm_a + wM * (w_ay)^2;           % Addition Moment of inertia around pivot

mM = .00063;                              % Mass of Motor                            kg
M_cmy = .07;                              % Position of Motor                        meters
I_m  = mM * M_cmy^2;                      % Moment of Inertia of Motor around pivot

I_cm = 1/12 * mC * (L^2 + W^2);           % Moment of Inertia of card around center
I = I_cm + mC * (L/2)^2;                  % Moment of Inertia of card over bottom of card (pivot point)
I = I - wI_r;                             % Remove moment of inertia of wheel
I = I + I_m;                              % Add moment of inertia of motor
I = I + wI_a;                             % Add moment of inertia of wheel back

M_v = [mC, -wM, mM, wM];                  % Mass vector
Y_v = [L/2, w_ry, M_cmy, w_ay];           % Position vector (y values)
CM = dot(M_v, Y_v)/sum(M_v);

Init = [0.1, 0, 0, 0];                    % Initial Conditions [theta, theta_dot, w, w_dot]

%% Controller

P_c = -90;                                % Proportional term for controller to setpoint
D_c = -10;                                % Derivative term for controller to setpoint

    function [V] = Ctrl(error, derror)
        V = P_c * error + D_c * derror;
    end

P_s = .01;                                % Proportional term for controller of setpoint
D_s = .04;                                % Derivative term for controller of setpoint

    function [S] = SetpointCtrl(w, wdot)
        S = P_s * w + D_s * wdot;
    end

%% Sensors
sens_y = .04;                             % Y position of sensor
linear_noise = .01;                       % Noise of accelerometer values (uniform distribution)
%%%% Accelerometer
    

    function [x_dot_dot, y_dot_dot, z_dot_dot] = Accelerometer(theta, theta_dot_dot)
        x_dot_dot = cos(theta)*theta_dot_dot*sens_y + sin(theta)*g + (rand-.5)*linear_noise;
        y_dot_dot = sin(theta)*theta_dot_dot*sens_y + cos(theta)*g + (rand-.5)*linear_noise;
        z_dot_dot = 0 + (rand-.5)*linear_noise;
    end
    
    function [theta_estimate] = AccelAngleEstimate(theta, theta_dot_dot)
        [x_dot_dot, y_dot_dot, ~] = Accelerometer(theta, theta_dot_dot);
        theta_estimate = atan(x_dot_dot/y_dot_dot);
    end
    
%%%% Gyroscope
    
% Alpha, beta, and gamma are rotations around x, y and z axes respectively
    function [alpha_dot_dot, beta_dot_dot, gamma_dot_dot] = Gyrocope(theta_dot_dot)
        alpha_dot_dot = 0;
        beta_dot_dot = 0;
        gamma_dot_dot = theta_dot_dot;
    end

%%%% IMU

% TODO: Implement Sensor Fusion algorithm/kalman filter

%% Simulation

    function [T_m] = massTorque(theta)
    T_m = sin(theta) * CM * sum(M_v); 
    end

    function [theta_dot_dot] = cardAngAccM(theta)
    theta_dot_dot = massTorque(theta)/I;
    end

    function [res] = odefunc(t, M)
        theta = M(1);
        theta_dot = M(2);
        w = M(3);
        w_dot = M(4);
        
        % Sensor AccelAngleEstimate is used in place of theta
        error = AccelAngleEstimate(theta, cardAngAccM(theta)) - SetpointCtrl(w , w_dot); 
        w_dot_dot = Ctrl(error, theta_dot);
        theta_dot_dot = cardAngAccM(theta) + w_dot_dot;
        
        res=[theta_dot; theta_dot_dot; w_dot; w_dot_dot];
    end

tspan = [0 16];
[t,y] = ode45(@odefunc, tspan, Init);

%% Plotting
subplot(2, 2, 1)
plot(t,y(:, 1))
xlabel("Time (s)")
ylabel("Inverted Position (theta)")

subplot(2, 2, 2)
plot(t,y(:, 2))
xlabel("Time (s)")
ylabel("Inverted Velocity (dtheta)")

subplot(2, 2, 3)
plot(t, y(:, 3))
xlabel("Time (s)")
ylabel("Wheel Position (theta)")

subplot(2, 2, 4)
plot(t, y(:, 4))
xlabel("Time (s)")
ylabel("Wheel Velocity (dtheta)")


figure
posx = L*sin(y(:,1));
posy = L*cos(y(:,1));

axisLength =L*1.25;

axis([-axisLength, axisLength, -axisLength, axisLength])
pbaspect([1,1,1])

h = animatedline('Marker', 'o');
b = animatedline;

for k = 1:1:length(posx)
    addpoints(h,posx(k),posy(k));
    addpoints(b, 0,0);
    addpoints(b, posx(k),posy(k));
    drawnow
    clearpoints(h);
    clearpoints(b);
end


end