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
                0,...
            ];
            % state vector format (update as needed)
                % 1:4   Satellite Attitude Quaternions
                % 5:7   Satellite Attitude Angular Velocities
                % 8:10  Reaction Wheel Angular Velocities
                % 11    Battery State of Charge (SOC)
            obj.stateS = zeros(length(time), length(obj.stateI));
        end
        
        function [dState] = satelliteSystemDynamics(obj, t, dt, state, a, command)
            %%% satelliteSystemDynamics
            %       Combines all subsystems dynamics into one function
            % attitudeSystemDynamics(dt, X, qd, obj)
            % command = commandSystem.command(t, obj.commandSystem, obj.powerSystem);
            
            %{
            disp('IN SAT MODEL')
            disp('OBJ')
            disp(obj)
            disp('TIME')
            disp(t)
            disp('DT')
            disp(dt)
            disp('STATE')
            disp(state)
            disp('INDEX')
            disp(a)
            disp('COMMAND')
            disp(command)
            %}

            dState = zeros(1,length(state));

            % [dX] = attitudeSystemDynamics(obj, t, dt, X, a, qd)
            dState(1:10) = attitudeSystemDynamics(obj.attitudeSystem, t, dt, state(1:10), a, obj.attitudeSystem.qd(a, :, command));

            %%% NEEDS TO BE IN A FORM THAT RK4 CAN USE
        end
        
        function [] = simulate(obj)
            %%% simulate
            %       Simulation for satellite model
            
            %%% FIRST STEP
            obj.stateS(1,:) = obj.stateI;
            
            
            %%% SIMULATION LOOP
            % [X] = RK4(dynamics, t, dt, X, varargin)

            for a = 1:length(obj.time)-1
                command = obj.commandSystem.command(obj.powerSystem, a);
                obj.stateS(a+1,1:10) = RK4(@obj.satelliteSystemDynamics, obj.time(a), obj.dt, obj.stateS(a,1:10), a, command);
                obj.stateS(a+1,11) = obj.powerSystem.step(obj.dt, command);
                obj.stateS(a+1,12) = command;
            end
        end
        
    end
end
