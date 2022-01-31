classdef reactionWheel < handle
    %REACTIONWHEEL Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        state0              % Initial State Vector
        stateC              % Current State Vector
        
        inertia             % Inertia Tensor
        
        h                   % Handle
    end
    
    methods
        function obj = reactionWheel(state0, inertia)
            %%% reactionWheel
            %       Constructor
            obj.state0 = state0;
            obj.stateC = state0;
            
            obj.inertia = inertia;
        end
        
        function [stateC] = updateState(obj, dState)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            stateC = obj.stateC + dState;
            obj.stateC = stateC;
        end
    end
end

