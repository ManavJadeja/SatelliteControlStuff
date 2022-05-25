classdef satelliteModel < handle
    %%% satelliteModel
    %       Model of satellite and relevant properties
    %       
    %   Created by Manav Jadeja on 20220102
    
    properties
        time                % Time Span
        dt                  % Time Step
        
        state0              % State Vector (Initial)
        stateS              % State Vector (Simulated)
        
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
            
            obj.state0 = [
                attitudeSystem.state0,...
                powerSystem.state0,...
                1,...
                0,...
            ];
            % state vector format (update as needed)
                % 1:4       SC Attitude Quaternion (Actual)
                % 5:7       SC Attitude Angular Velocity (Actual)
                % 8:10      Reaction Wheel Angular Velocity (Actual)
                % 11:14     SC Attitude Quaternion (Estimate)
                % 15:17     SC Attitude Angular Velocity (Estimate)
                % 18:20     Reaction Wheel Angular Velocity (Estimate)
                
                % 21        Battery State of Charge (SOC)
                % 22        Command
                % 23        Data Storage Use
                
            obj.stateS = zeros(length(time), length(obj.state0));
            obj.stateS(1,:) = obj.state0;
        end
        
        function [] = simulate(obj)
            %%% simulate
            %       Simulation for satellite model
            
            %%% PRELIMINARY STUFF
            % WAITING BAR
            f = waitbar(0,'Simulating...', 'Name', 'Simulation Progress');
            
            % VARIABLES
            ssdCapacity = obj.commandSystem.ssd.capacity;
            scIA = obj.attitudeSystem.inertiaA;
            scIE = obj.attitudeSystem.inertiaE;
            rwIA = obj.attitudeSystem.reactionWheel.inertiaA;
            rwIE = obj.attitudeSystem.reactionWheel.inertiaE;
            
            
            %%% SIMULATION LOOP
                % state vector format (update as needed)
                    % 1:4       SC Attitude Quaternion (Actual)
                    % 5:7       SC Attitude Angular Velocity (Actual)
                    % 8:10      Reaction Wheel Angular Velocity (Actual)
                    
                    % 11:14     SC Attitude Quaternion (Estimate)
                    % 15:17     SC Attitude Angular Velocity (Estimate)
                    % 18:20     Reaction Wheel Angular Velocity (Estimate)
                    
                    % 21        Battery State of Charge (SOC)
                    % 22        Command
                    % 23        Data Storage Use
            
            for a = 1:length(obj.time)-1
                % Command System
                command = obj.commandSystem.command(obj.stateS(a,21),...
                    obj.stateS(a,22)/ssdCapacity, a);
                obj.stateS(a+1,22) = command;
                obj.stateS(a+1,23) = obj.stateS(a,23) + ...
                    obj.commandSystem.dataGenerated(obj.dt, obj.stateS(a,23), command);
                    
                % Simulate Power System
                obj.stateS(a+1,21) = obj.powerSystem.step(obj.dt, command);
                
                % Control Torque
                Mc = obj.attitudeSystem.reactionWheel.controlTorque(...
                    obj.stateS(a, 11:14), obj.stateS(a, 15:17),...
                    obj.attitudeSystem.K,...
                    obj.attitudeSystem.qd(a, :, command));
                
                % MAGNETIC DISTURBANCE TORQUE
                %{
                Mm = obj.magnetorquer.magneticMoment(obj.magnetorquer.magneticDipole,...
                    1e-9*obj.magnetorquer.magneticField(a,:), q);
                %}
                
                % Actual Attitude Dynamics
                % [dX] = attitudeSystemDynamics(obj, t, dt, X, a, scI, rwI, M)
                obj.stateS(a+1, 1:10) = RK4(@attitudeSystemDynamics, obj.attitudeSystem,...
                    obj.time(a), obj.dt, obj.stateS(a, 1:10), a, scIA, rwIA, Mc);
                
                % Estimated Attitude Dynamics
                obj.stateS(a+1,11:20) = RK4(@attitudeSystemDynamics, obj.attitudeSystem,...
                    obj.time(a), obj.dt, obj.stateS(a,11:20), a, scIE, rwIE, Mc);
                
                % Update Loading Bar
                if rem(a,1000) == 0
                    percentDone = a/(length(obj.time));
                    waitbar(percentDone, f, sprintf('%.2f', 100*percentDone))
                end

            end
            delete(f)

        end
        
    end
end
