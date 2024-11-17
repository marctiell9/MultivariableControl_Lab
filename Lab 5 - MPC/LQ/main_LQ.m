S = [0.06, 0.06];           % Tank section
At = [ 1.31e-4, 9.27e-5 ];  % Tank discharge constant
g = 9.81;

xk = [ 0.4; 0.4 ];
Q = eye(2);
R = 1e6;

Np = 75;
tau = 20;
gm = 0.4;

%% Equilibrium and linearization

[x_bar, u_bar ] = compute_equilibrium(0.8);
h1_bar = x_bar(1);
h2_bar = x_bar(2);
q_bar = u_bar;

sim('TwoTank_Linearization');

A_lin = TwoTank_Linearization_Timed_Based_Linearization.a;
B_lin = TwoTank_Linearization_Timed_Based_Linearization.b;

%% LQ design
Q = diag([1, 0.01]);
R = (1e3)^2;

K_lq = lqr(A_lin, B_lin, Q, R);

% LQ non facile fare il tuning, perchè i pesi vanno selezionati con
% attenzione in quanto, non tutti gli stati hanno la stessa rilevanza. Se
% vogliamo fare il tracking del primo stato che è quello che più ci
% interessa allora q1>>q2, e scegliamo comunque un q2>0 per avere una Q
% definita positiva. Problema relativo agli input: lo scale degli input è
% molto diverso da quello degli stati, allora il peso da selezionare per
% gli input deve essere scelto in modo rende simile la penalizzazione dello
% stato e degli input dal punto di vista numerico. In questo caso x è
% compreso tra 0 e 1, e se vogliamo rendere R*u^2 grande quanto Q*x^2
% allora R=(1e3)^2