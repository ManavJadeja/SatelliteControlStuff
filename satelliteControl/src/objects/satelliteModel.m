classdef satelliteModel < handle
    %%% satelliteModel
    %       Model of satellite and relevant properties
    %       
    %   Created by Manav Jadeja on 20220102
    
    properties
        time                % Time Span
        dt                  % Time Step
        
        stateI              % Initial State Vector
        stateS              % Simulated State
        
        powerSystem         % Power System (object)
        attitudeSystem      % Attitude Control System (object)
        commandSystem       % Flight Software System (object)
        
        h                   % Handle
    end
    
    methods
        function obj = satelliteModel(time, dt, powerSystem, attitudeSystem, commandSystem)
            %%% satelliteModel
            %       Create a satellite model
            
            obj.powerSystem = powerSystem;
            obj.attitudeSystem = attitudeSystem;
            obj.commandSystem = commandSystem;
            
            obj.time = time;
            obj.dt = dt;
            obj.stateI = [
                attitudeSystem.stateI,...
                powerSystem.stateI,...
            ];
            
            obj.stateS = zeros(length(time), length(obj.stateI));
        end
        
        function [dState] = satelliteSystemDynamics(obj, dt, state, a, command)
            %%% satelliteSystemDynamics
            %       Combines all subsystems dynamics into one function
            % attitudeSystemDynamics(dt, X, qd, obj)
            % command = obj.commandSystem.command(t, obj.commandSystem, obj.powerSystem);
            
            dState = zeros(1,length(obj.stateI));
            dState(1:7) = attitudeSystemDynamics(dt, state(1:7), obj.attitudeSystem.qd(a, :, command), obj.attitudeSystem);
            
            %%% NEED TO FEED IN FULL STATE VECTOR
            %%% GENERATE COMMAND FROM CURRENT STATE VECTOR
            %%% APPLY COMMAND TO ALL SUBSYSTEMS
            %%% RETREIVE OUTPUT STATE VECTOR
            %%% NEEDS TO BE IN A FORM THAT RK4 CAN USE
        end
        
        function [] = simulate(obj)
            %%% simulate
            %       Simulation for satellite model
            
            %%% FIRST STEP
            obj.stateS(1,:) = obj.stateI;
            
            
            %%% SIMULATION LOOP
            for a = 1:length(obj.time)-1
                command = obj.commandSystem.command(obj.powerSystem, a);
                obj.stateS(a+1,:) = RK4(@obj.satelliteSystemDynamics, obj.dt, obj.stateS(a,:), a, command);
            end
        end
        
    end
end
