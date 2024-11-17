function u_opt = FHCOP(xk, Q, R, N, x_bar, u_bar, tau_s)
    % FHCOP
    % Solve the Finite Horizon Control Optimization Problem (FHOCP)
    %
    % Arguments
    % - xk: The current state
    % - Q: The state weight
    % - R: The input weight
    % - Np: The prediction horizon
    % - x_bar: The target state equilibrium
    % - u_bar: The target input equilibrium
    % - Ts: Discretization time-step
    %
    % Returns
    % - u_opt: The optimal control move at the current time step (u^*(k))
       
    % Import the CasADi toolkit and instantiate the optimization problem (opti)
    import casadi.*;
    opti = casadi.Opti();
    
    
    %%%%%% Declare the optimization variables %%%%%%
    % u = ...
    % x = ...
    
    
    %%%%%% Impose the constraints %%%%%%
    
    % Initial state constraint: x(k) == xk
    
    % Input constraints:  u_min <= u(k+i) <= u_max 
    
    % State constraints:  x_min <= x(k+i) <= x_max   $foral
     
    % Terminal constraint: x(k+N+1) = x_bar
    
    
    %%%%%% System dynamics and cost function %%%%%%
    
    % Cost function initialization
    J = 0;
    
    for jj=1:N      % Note that the MATLAB index jj = 1 corresponds to i = 0
        % Set the system dynamics as a constraint:  x(k+i+1) == f(x(k), u(k))
        
        % Add the i-th term to the cost function: (u(k+i)-u_bar)' * R * (u(k+i)-u_bar) + (x(k+i)-x_bar)' * Q * (x(k+i)-x_bar)
        % J = J + ...
    end
    
    
    %%%%%% Set the initial guess of the optimization variables %%%%%%
    
    % Possible initial guess for x:    x(k+i) = xk  ∀i = 0, ..., N
    % opti.set_initial(x, ...);   
    
    % Possible initial guess for u:    u(k+i) = u_min  ∀i = 0, ..., N-1
    % opti.set_initial(u, ...); 
    
    
    
    %%%%%% CasADi Settings (do not change) %%%%%%
    % Declare the cost function
    opti.minimize(J);
    
    % Options of the optimization problem
    prob_opts = struct;
    prob_opts.expand = true;
    prob_opts.ipopt.print_level = 0;    % Disable printing
    prob_opts.print_time = false;       % Do not print the timestamp
    
    % Options of the solver
    ip_opts = struct;
    ip_opts.print_level = 0;            % Disable printing
    ip_opts.max_iter = 1e5;             % Maximum iterations
    ip_opts.compl_inf_tol = 1e-6;
    
    % Set the solver
    opti.solver('ipopt', prob_opts, ip_opts);
    
    
    %%%%%% Solve the optimization problem %%%%%%
    try
        sol = opti.solve();
        
        % Extract the optimal control action
        % u_opt = ....
        
    catch EX
        keyboard; % Enter the debug mode
    end
end