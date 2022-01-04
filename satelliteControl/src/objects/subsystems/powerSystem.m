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
        
        sunVector           % Sun Vector
        lightingTimes       % Lighting Times
        
        h                   % Handle
    end
    
    methods
        function obj = powerSystem(time, battery, solarArray, sunVector)
            %%% powerSystem
            %       Create a power system
            
            obj.time = time;
            obj.battery = battery;
            obj.solarArray = solarArray;
            obj.sunVector = sunVector;
        end
        
        function [dX] = powerSystemDynamics(dt, X, obj)
            %%% powerSystemDynamics
            %       Power System Dynamics
            
            % NEED TO SIT DOWN WITH SUNNY AND FIGURE THIS OUT >:0
        end
        
    end
end

