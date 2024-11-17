%% System parameters
m  = 2;     % Damped mass [kg]
M  = 10;    % Mass of the cart [kg]
L  = 1;     % Length of the beam [m]
Rr = 0.1;   % Radius of cart's wheels [m]
Ke = 2;     % Parameter of the DC motor
Kc = 2;     % Parameter of the DC motor
Ra = 10;    % Armature resistance of the DC motor [Ohm]
g  = 9.81;  % Gravity

z0 = 0;             % Initial position of the cart
theta0 = 0.2;       % Initial orientation of the beam
z_dot0 = 0;         % Initial linear speed of the cart
thetda_dot0 = 0;    % Initial angular speed of the beam

%% 1) Linearize the system with the Time-based Linearization Block
open('Pendulum_OpenLoop');

% A = ...
% B = ...
% C <- Only the cart position and the pendulum angle are measured
% D = ...

%% 2) Enlarge the system with integrators

% A_tilde = ...
% B_tilde = ...

%% 3) Design an LQ control law for the enlarged system

% K_lq = ...
% open('Pendulum_LQ');

%% 4) Design a Kalman Filter to estimate the state 

% L_kf = ...
% open('Pendulum_LQG');
