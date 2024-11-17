% LAB 03 - Gripen Aircraft

%% Load the data
% State: x = [ vy, p, r, phi, psi, delta_a, delta_r ]
% Input: u = [ delta_a_cmd, delta_r_cmd ]
% Output: y = [ phi, psi ]

load('Gripendata.mat');
x0=[5; 0.1*pi/180; 0.1*pi/180; 5*pi/180; 5*pi/180; 0; 0];
n = size(A, 1);
m = size(B, 2);
p = size(C, 1);


%% Task 1 - Analyze the system & design pole placement

% Find the poles and zeros of the system

% Plot the open-loop singular values
% sigma(...)

% Design a pole placement control law (assuming the states to be measurable)

% Kpp = ...


% Compare the closed-loop singular values to the open-loop singular values
% sigma(...)

%% Task 2 - State observer design

% Design the state observer
% L = ...

% Test the closed-loop in Simulink

%% Task 3 - System enlargement

% Enlarge the system with two integrators

% Design the pole placement for the enlarged system
% Kpp_en = ...

% Test the closed-loop in Simulink

%% Task 4 - Reduced order observer design
% Design a Reduced Order Observer (ROO)
% L_rod = ...

% Test the closed-loop given by the ROD and the PP designed for the enlarged system

%% Task 5 - LQ design
% Assuming that the state is measurable (y = x), design the LQ control law which 
% guarantees the desidered dynamic performances
% K_lq = lqr(...)

% Compute the closed-loop eigenvalues (Enlarged System + LQ)

% Test the closed-loop in Simulink

%% Task 6 (optional) - KF design
% Design a Kalman Filter to estimate the state from the measurements
% L_kf = ...

% Test the closed-loop in Simulink
