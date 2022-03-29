classdef reactionWheel < handle
    %REACTIONWHEEL Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        stateI              % Initial State Vector
        
        inertia             % Inertia Tensor
        maxMoment           % Maximum Moment
        
        h                   % Handle
    end
    
    methods
        function obj = reactionWheel(stateI, inertia, maxMoment)
            %%% reactionWheel
            %       Constructor
            obj.stateI = stateI;
            
            obj.inertia = inertia;
            obj.maxMoment = maxMoment;
        end
    end
end

