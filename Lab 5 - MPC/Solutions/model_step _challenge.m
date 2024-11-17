function [ xkp1, yk ] = model_step(xk, uk, tau)
    % model_step
    % Function implementing the discrete-time evolution of the system state x(k+1) and output y(k).
    % Obtained discretizing the system dynamics via Forward Euler.
    %
    % x(k+1) = f(x(k), u(k))
    % y(k) = x(k)
    
    S1 = 0.06;           % Tank 1 section
    S2 = 0.06;           % Tank 2 section
    a1 = 1.31e-4;        % Tank 1 opening
    a2 = 9.27e-5;        % Tank 2 opening
    g = 9.81;
    gamma = 0.4;                % Valve split coefficient
    
    x1dot = -a1 / S1 * sqrt(2*g*xk(1)) + a2 / S1 * sqrt(2*g*xk(2)) + gamma / S1 * uk;
    x2dot = -a2 / S2 * sqrt(2*g*xk(2)) + (1-gamma) / S2 * uk;
    
    % Discretization via Forward Euler
    xkp1 = [ xk(1) + tau * x1dot;
             xk(2) + tau * x2dot; ];
    yk = xk;

end