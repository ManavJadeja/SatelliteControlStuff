classdef satelliteModel < handle
    %%% satelliteModel
    %       Model of satellite and relevant properties
    %       
    %   Created by Manav Jadeja on 20220102
    
    properties
        time                % Time Span
        stateI              % Initial State Vector
        stateS              % Simulated State
        
        powerSystem         % Power System (object)
        attitudeSystem      % Attitude Control System (object)
        commandSystem       % Flight Software System (obj)
        
        h                   % Handle
    end
    
    methods
        function obj = satelliteModel(time, powerSystem, attitudeSystem, commandSystem)
            %%% satelliteModel
            %       Create a satellite model
            
            obj.powerSystem = powerSystem;
            obj.attitudeSystem = attitudeSystem;
            obj.commandSystem = commandSystem;
            
            obj.time = time;
            obj.stateI = [
                attitudeSystem.stateI;
                powerSystem.stateI;
            ];
            
            obj.stateS = zeros(length(time), length(stateI));
        end
        
        function [] = flightSoftware(obj)
            %%% flightSoftware
            %       A very primitive version of flight software
            %       Exclusively for decision making, no management
            
            if obj.powerSystem.battery
        end
        
        function [] = simulate(obj)
            for a = 1:length(obj.time)-1
                dt = obj.time(a+1) - obj.time(a);
                
            end
        end
        
    end
end
