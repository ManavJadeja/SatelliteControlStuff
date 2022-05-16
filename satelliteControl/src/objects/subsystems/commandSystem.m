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
        
        sunBools                % Sun Bools
        accessBools             % Access Bools

        ssd                     % SSD (Object)
        
        state0                  % Initial State
                                    % 1     Commands
                                    % 2     Data storage use
    end
    
    methods
        function obj = commandSystem(socSafe, socUnsafe, ssdSafe, sunBools, accessBools, ssd)
            %%% commandSystem
            %       Create a Command System
                        
            obj.socSafe = socSafe;
            obj.socUnsafe = socUnsafe;
            obj.ssdSafe = ssdSafe;
            
            obj.sunBools = sunBools;
            obj.accessBools = accessBools;
            
            obj.ssd = ssd;
            
            obj.state0 = [1,obj.ssd.state0];
        end
        
        function [command] = command(obj, batterySOC, ssdSOC, a)
            %%% command
            %       Takes in some data and returns a command
            %   INPUTS:
            %       t               % Current Time Index
            %       powerSystem     % Power System (object)
            %       obj             % Command System (object)
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
                            if ssdSOC < obj.ssdSafe
                                command = 3;
                            end
                        end
                    end
                end
            end
        end
        
        function [dataGen] = dataGenerated(obj, dt, state, command)
            dataGen = obj.ssd.dataGenerationRates(command*(command<=4) + 5*(command>4));
            if dataGen > 0
                if obj.ssd.capacity < state + dt*dataGen
                    dataGen = 0;
                end
            else
                if state + dt*dataGen < 0
                    dataGen = 0;
                end
            end
        end
    end
end
