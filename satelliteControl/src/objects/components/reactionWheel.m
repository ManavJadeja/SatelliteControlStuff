classdef reactionWheel < handle
    %%% reactionWheel
    %       3 Axis Reaction Wheels (Object)
    %
    %   Created by Manav Jadeja on 20220515
    
    properties
        state0A             % State Vector (Initial Actual)
        state0E             % State Vector (Initial Estimate)
        
        inertiaA            % Inertia Matrix (Actual)
        inertiaE            % Inertia Matrix (Estimate)
        maxMoment           % Maximum Moment/Torque
                
        h                   % Handle
    end
    
    methods
        function obj = reactionWheel(state0, state0Error, inertiaA, inertiaError, maxMoment)
            %%% reactionWheel
            %       Create a 3 axis reaction wheel
            obj.state0A = state0;
            obj.state0E = state0 + state0Error;
            
            obj.inertiaA = inertiaA;
            obj.inertiaE = inertiaA + inertiaError;
            obj.maxMoment = maxMoment;
        end
    end
end

