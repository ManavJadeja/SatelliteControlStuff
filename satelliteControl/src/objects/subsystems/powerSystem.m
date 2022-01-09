classdef powerSystem < handle
    %%% powerSystem
    %       Power System for a Satellite
    %       
    %   Created by Manav Jadeja on 20220102
    
    properties
        time                % Time Vector
        stateI              % Initial State Vector
        
        battery             % Battery (object)
        solarArray          % Solar Array (object)
                
        h                   % Handle
    end
    
    methods
        function obj = powerSystem(time, battery, solarArray)
            %%% powerSystem
            %       Create a power system
            
            obj.time = time;
            obj.battery = battery;
            obj.solarArray = solarArray;
            obj.stateI = obj.battery.soc;
        end
        
        function [dX] = powerSystemDynamics(obj, dt, X)
            %%% powerSystemDynamics
            %       Power System Dynamics
            
            dX = zeros(1,X);
        end
        
    end
end

