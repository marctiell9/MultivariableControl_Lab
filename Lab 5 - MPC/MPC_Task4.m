classdef MPC_Task4 < matlab.System
    % MPC_Task4 Model Predictive Control Block
   
    % Define the properties of the block, that can be changed 
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
    
     % Define here the states of the block, if any. 
     % States are only necessary if the block needs to keep memory of past data.
    properties(DiscreteState)
        u_prev
    end
    
    
    methods(Access = protected)
        function u_opt = stepImpl(obj, xk, h1_ref)
            % Main body of the block. Put the instructions that must be executed at each time step here.
            
            % Given h1_ref, compute (x_bar, u_bar)
            
            % Solve the FHCOP
           
            % Update u_prev
        end


        function n_in = getNumInputsImpl(~)
            % Define total number of input signals of the block
            
            % n_in = ...;
        end

        function n_out = getNumOutputsImpl(~)
            % Define total number of output signal of the block
            
            % n_out = ...;
        end

        function out_size = getOutputSizeImpl(~)
            % Return the size of the output signal
            
            % out_size = ...;
        end

        function out_type = getOutputDataTypeImpl(~)
            % Return data type of the output port. 
            % Choose between MATLAB Data types (e.g. "double", "int32", "uint64", etc.)
            
            % out_type = ...;     
        end

        function out_complex = isOutputComplexImpl(~)
            % Return true if the output signal is complex, false otherwise
            
            % out_complex = ...;
        end

        function out_fixed = isOutputFixedSizeImpl(~)
            % Return true if the output signal has a fixed size, false otherwise
            
             % out_fixed = ...;
        end


        function sts = getSampleTimeImpl(obj)
            % Define the sampling time of the block.
            
            % This is a discrete-time block with sampling time specified by the user via the tau_s parameter
            sts = obj.createSampleTime("Type", "Discrete", "SampleTime", obj.tau_s);
        end
        
        
        %%%%%% States methods %%%%%%
        % Leave commented if there is no state
        
        function [sz,dt,cp] = getDiscreteStateSpecificationImpl(obj, name)
            % Return size, data type, and complexity of discrete-state specified in name
            if strcmp(name, 'State1')
%                 sz = ....;          % Size of State1
%                 dt = ...;           % Type of State 1
%                 cp = ...;           % Complexity of State1
            end
        end
        
        
        function resetImpl(obj)
            % Initialize the states at the beginning of the simulation
            % obj.State1 = ...
        end
    end
end
