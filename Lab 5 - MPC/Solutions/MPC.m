classdef MPC < matlab.System
    % MPC Model Predictive Control Block
   
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

    methods(Access = protected)
        function u_opt = stepImpl(obj, xk, h1_ref)
            % Given y_ref, compute (x_bar, u_bar)
            [ x_bar, u_bar ] = compute_equilibrium(h1_ref); 
            
            % Solve the FHCOP
            u_opt = FHCOP(xk, obj.Q, obj.R, obj.N, x_bar, u_bar, obj.tau_s);
        end


        function num = getNumInputsImpl(~)
            % Define total number of inputs for system with optional inputs
            num = 2; %perche abbiamo x_k , h1_ref
        end

        function num = getNumOutputsImpl(~)
            % Define total number of outputs for system with optional
            % outputs
            num = 1;
        end

        function out = getOutputSizeImpl(~)
            % Return size for each output port (colonne e righe dell'output)
            out = [1 1]; %scalar
        end

        function out = getOutputDataTypeImpl(~)
            % Return data type for each output port
            out = "double"; %real number
        end

        function out = isOutputComplexImpl(~)
            % Return true for each output port with complex data
            out = false;
        end

        function out = isOutputFixedSizeImpl(~)
            % Return true for each output port with fixed size
            out = true;
        end

        function sts = getSampleTimeImpl(obj)
            % Define sample time type and parameters
            sts = obj.createSampleTime("Type", "Discrete", "SampleTime", obj.tau_s);

        end
    end
end
