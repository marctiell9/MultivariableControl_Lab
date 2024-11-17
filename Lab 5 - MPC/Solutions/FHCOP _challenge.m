function u_opt = FHCOP(xk, Q, R, N, x_bar, u_bar, tau_s)
    % FHCOP
    % Solve the Finite Horizon Control Optimization Problem
    
    % Parameters
    % - xk: The current state
    % - Q: The state weight
    % - R: The input weight
    % - N: The prediction horizon
    % - x_bar: The target state equilibrium
    % - u_bar: The target input equilibrium
    % - tau_s: the sampling time
       
    % Import the CasADi toolkit
    import casadi.*;
    opti = casadi.Opti();
    
    % Declare the optimization variables
    delta_u = opti.variable(1, N);  %vettore di una 1 riga e N colonne 
    delta_x = opti.variable(2, N+1); %nello shema del libro non ci sono gli stati in J
    
    % Initial state
    opti.subject_to(delta_x(:, 1) == xk); 
    % x(:,1) la prima colonna sarebbe x all' istante 1 (istante di tempo attuale)
    % la quale non è  una variabile di ottimizzazione e che conosciamo perchè misurata
    % xk è lo stato misurato da simulink e dato alla matlab function

    % Input constraints
    opti.subject_to(1e-4 <= u <= 1e-3); % vincoliamo tutti gli elementi del vettore
    % il vincolo viene applicato a tutte le colonne.
    
    % State constraints
    opti.subject_to(0.1 <= x(1, :) <= 1.3);
    opti.subject_to(0.1 <= x(2, :) <= 1.2);
    
    % Terminal constraint
    opti.subject_to(x(:, end) == x_bar);
    % stato finale viene vincolato a ad essere uguale al punto di equilibrio
    % che viene determinato con simulink.
    
    % Cost function initialization
    J = 0;
    
    for ii=1:N
        % Compute x(k+1) = x(k) + f(x(k), u(k)) * Ts 
        [ xp, ~ ] = model_step(x(:, ii), u(:, ii), tau_s);
        
        % System dynamics constraint
        opti.subject_to(x(:, ii+1) == xp);
        % cioè calcoliamo il prossimo stato tramite il modello discretizzato 
        % e poi vincoliamo lo stato futuro ad essere uguale ad xp appena calcolato
        
        % Cost function function
        J = J ...
            + (u(:, ii) - u_bar).' * R * (u(:, ii) - u_bar) ...
            + (x(:, ii) - x_bar).' * Q * (x(:, ii) - x_bar);
    end
    
    % Set the initial guess
    % x(k+i|k) = x(k) ∀i = 1, ..., N
    opti.set_initial(x, repmat(xk, 1, N+1));  %possiamo settare x constantemente uguale allo stato misurato
    % x ripetuto N+1 volte, e cioè ripetuto lungo il prediction horizon
    % u(k+i|k) = wn
    opti.set_initial(u, repmat(1e-4, 1, N)); % potremmo prendere il minimo, massimo o media degli input lungo N
    
    % Declare the cost function
    opti.minimize(J);                   % We shall minimize J
    
    % CASADI settings (parte che non va modificata)
    prob_opts = struct;
    prob_opts.expand = true;
    prob_opts.ipopt.print_level = 0;    % Disable printing
    prob_opts.print_time = false;       % Do not print the timestamp
    
    % IPOPT settings
    ip_opts = struct;
    ip_opts.print_level = 0;            % Disable printing
    ip_opts.max_iter = 1e5;             % Maximum iterations
    ip_opts.compl_inf_tol = 1e-6;
    
    % Set the solver
    opti.solver('ipopt', prob_opts, ip_opts);
    
    try
        % SOLVE THE FHOCP
        sol = opti.solve();
        % le soluzioni saranno l'evoluzione di u e x, lungo l' intero prediction horizon
        
        % Extract the optimal control action
        u_opt = sol.value(u(:, 1)); % ci importa solo del primo input da applicare al sistema
        
        % u_pred = sol.value(u);
        % x_pred = sol.value(x); 
    catch EX
        keyboard;
    end
end

% Andremo poi a costruire un sitema in Simulink che chiama questa funzione
% e il riferimento, e testa il closed-loop