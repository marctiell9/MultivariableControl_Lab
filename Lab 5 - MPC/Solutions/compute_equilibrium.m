function [x_bar, u_bar] = compute_equilibrium(h1_ref)
    % compute_equilibrium
    % Compute the equilibrium (x_bar, u_bar) such that h1_bar = h1_ref
    %Potremmo anche usare la libreria simbolica di Matlab e la funzione
    %solve
    
    S1 = 0.06;           % Tank 1 section
    S2 = 0.06;           % Tank 2 section
    a1 = 1.31e-4;        % Tank 1 opening
    a2 = 9.27e-5;        % Tank 2 opening
    g = 9.81;
    gamma = 0.4;                % Valve split coefficient
    
    k = a2 * (1 / S2 + gamma / (S1 * (1 - gamma)));
    
    h2_bar = (a1 / (S1 * k))^2 * h1_ref;
    
    u_bar = a2 / (1 - gamma) * sqrt(2 * g * h2_bar);
    x_bar = [ h1_ref;
              h2_bar ];
    
end

