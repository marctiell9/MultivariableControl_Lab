classdef MPC_Task4 < matlab.System
    % MPC_Task4 Model Predictive Control Block (with maximum control variation rate)
   
    % Public, tunable properties
    properties(Nontunable)
        % N Prediction Horizon
        N = 20;
        % Q Q Matrix
        Q = [];
        % R R Matrix
        R = [];
        % tau_s Sampling Time
        tau_s = 1;
    end

    properties(DiscreteState)
        u_prev; %lo introduciamo perchè lo dobbiamo passare a FHCOP
    end

    methods(Access = protected)
        function u_opt = stepImpl(obj, xk, y_ref)
            % Given y_ref, compute (x_bar, u_bar)
            [ x_bar, u_bar ] = compute_equilibrium(y_ref); 
            
            % Solve the FHCOP
            u_opt = FHCOP_Task4(xk, obj.u_prev, obj.Q, obj.R, obj.N, x_bar, u_bar, obj.tau_s);
            
            obj.u_prev = u_opt;
        end

        function resetImpl(obj)
            % Initialize / reset discrete-state properties
            
            % The initial input is the minimum one
            obj.u_prev = 1e-4;   
        end


        function num = getNumInputsImpl(~)
            % Define total number of inputs for system with optional inputs
            num = 2;
        end

        function num = getNumOutputsImpl(~)
            % Define total number of outputs for system with optional
            % outputs
            num = 1;
        end

        function out = getOutputSizeImpl(~)
            % Return size for each output port
            out = [1 1];
        end

        function out = getOutputDataTypeImpl(~)
            % Return data type for each output port
            out = "double";
        end

        function out = isOutputComplexImpl(~)
            % Return true for each output port with complex data
            out = false;
        end

        function out = isOutputFixedSizeImpl(~)
            % Return true for each output port with fixed size
            out = true;
        end

        function [sz,dt,cp] = getDiscreteStateSpecificationImpl(obj, name)
            % Return size, data type, and complexity of discrete-state
            % specified in name
            if strcmp(name, 'u_prev') % u_prev è la variabile da discretizzare?
                % necessario perchè il vincolo è imposto sulla derivata temporale?
                sz = [1 1];
                dt = "double";
                cp = false;
            end
        end

        function sts = getSampleTimeImpl(obj)
            % Define sample time type and parameters
            sts = obj.createSampleTime("Type", "Discrete", "SampleTime", obj.tau_s);

        end
    end
end
