classdef commandSystem < handle
    %%% commandSystem
    %       Command System for a Satellite
    %
    %   Created by Manav Jadeja on 20220103
    
    properties
        time                    % Time
        
        socSafe                 % State of Charge (safe for access)
        socUnsafe               % State of Charge (unsafe for access)
        ssdSafe                 % SSD Capacity (safe for experiment)
        expDuration             % Experiment Duration
        
        sunBools                % Sun Bools
        accessBools             % Access Bools
        expBools                % Experiment Bools
        
        ssd                     % SSD (Object)
        
        state0                  % Initial State
                                    % 1     Commands
                                    % 2     Data storage use
    end
    
    methods
        function obj = commandSystem(socSafe, socUnsafe, ssdSafe, expDuration, dt, sunBools, accessBools, ssd)
            %%% commandSystem
            %       Create a Command System
                        
            obj.socSafe = socSafe;
            obj.socUnsafe = socUnsafe;
            obj.ssdSafe = ssdSafe;
            obj.expDuration = expDuration;
            
            obj.sunBools = sunBools;
            obj.accessBools = accessBools;
            experimentModeBools(obj, dt, expDuration, accessBools, sunBools);
            
            obj.ssd = ssd;
            
            obj.state0 = [1,obj.ssd.state0];
        end
        
        function [command] = command(obj, batterySOC, ssdSOC, a)
            %%% command
            %       Takes in some data and returns a command
            %   INPUTS:
            %       obj             % Command System (object)
            %       t               % Current Time Index
            %       batterySOC      % Battery SOC
            %       ssdSOC          % SSD SOC
            %       a               % Current Index
            %   OUTPUTS:
            %       command         % Command (integer)
            %                           % 1: Nothing Mode
            %                           % 2: Safety Mode
            %                           % 3: Experiment Mode
            %                           % 4: Charging Mode
            %                           % 5: Access Location 1
            %                           % 6: Access Location 2
            %                           % N+4: Access Location N
            
            %%% CURRENT BOOLEANS
            socSafeBool = logical(batterySOC >= obj.socSafe);
            socUnsafeBool = logical(batterySOC <= obj.socUnsafe);
            sunBoolT = obj.sunBools(a);
            accessBoolsT = obj.accessBools(a,:);
            expBoolT = obj.expBools(a);
            
            %%% COMMAND GENERATION
            % See flow diagram at the following link
            % https://gyazo.com/ef278bac0c2706910483c412da6b094a
            % And pray I didn't mess this up
            if socUnsafeBool
                if sunBoolT
                    command = 4;
                else
                    command = 2;
                end
            else
                if sum(accessBoolsT)
                    for a = 1:length(accessBoolsT)
                        if accessBoolsT(a) == 1
                            command = 4+a;
                            break
                        end
                    end
                else
                    if ~socSafeBool
                        if sunBoolT
                            command = 4;
                        else
                            command = 1;
                        end
                    else
                        if sunBoolT
                            command = 4;
                        else
                            if ssdSOC < obj.ssdSafe && expBoolT
                                command = 3;
                            else
                                command = 1;
                            end
                        end
                    end
                end
            end
        end
        
        function [] = experimentModeBools(obj, dt, expDuration, accessBools, sunBools)
            %%% experimentModeBool
            %       Find and make experiment bools
            
            % Need to parse through accessBools and sunBools to find
            % windows that are obj.expDuration long (in terms of dt)
            
            % Setup
            intervalNeeded = expDuration/dt;
            %openBools = false(1,length(sunBools));
            
            % Find empty times
            openBools = any([accessBools,sunBools]);
            %for a = 1:size(accessBools, 2)
            %    opensBools = openBools|accessBools(:,a);
            %end
            %openBools = openBools|sunBools;
            
            % Find All Free Intervals
            obj.expBools = false(1,length(sunBools));
            matchPattern = [1, zeros(1,intervalNeeded)];
            check = false;
            while ~check
                pos = strfind(openBools, matchPattern);
                for a = 1:length(pos)
                    obj.expBools(a:a+length(intervalNeeded)) = true;
                end
                check = isempty(pos);
            end
            
        end
        
        function [dataGen] = dataGenerated(obj, dt, state, command)
            %%% dataGenerated
            %       Get data generated from a command
            dataGen = dt*obj.ssd.dataGenerationRates(command*(command<=4) + 5*(command>4));
            nextState = state + dataGen;
            if nextState > obj.ssd.capacity || nextState < 0
                dataGen = 0;
            end
        end
    end
end
