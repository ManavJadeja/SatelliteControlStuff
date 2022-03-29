classdef reactionWheel < handle
    %REACTIONWHEEL Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        state0              % Initial State Vector
        
        inertia             % Inertia Tensor
        maxMoment           % Maximum Moment
        
        h                   % Handle
    end
    
    methods
        function obj = reactionWheel(state0, inertia, maxMoment)
            %%% reactionWheel
            %       Constructor
            obj.state0 = state0;
            
            obj.inertia = inertia;
            obj.maxMoment = maxMoment;
        end
    end
end

