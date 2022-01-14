classdef commandSystem < handle
    %%% commandSystem
    %       Command System for a Satellite
    %
    %   Created by Manav Jadeja on 20220103
    
    properties
        socSafe                 % State of Charge (safe for access)
        socUnsafe               % State of Charge (unsafe for access)
        
        accessBools             % Access Bools
        sunBools                % Sun Bools
    end
    
    methods
        function obj = commandSystem(socSafe, socUnsafe, accessBools, sunBools)
            %%% commandSystem
            %       Create a Command System
            
            obj.socSafe = socSafe;
            obj.socUnsafe = socUnsafe;
            
            obj.accessBools = accessBools;
            obj.sunBools = sunBools;
        end
        
        function [command] = command(obj, powerSystem, t)
            %%% command
            %       Takes in some data and returns a command
            %   INPUTS:
            %       t               % Current Time Index
            %       powerSystem     % Power System (object)
            %       obj             % Command System (object)
            %   OUTPUTS:
            %       command         % Command (integer)
            %                           0: Safety Mode
            %                           1: Nothing Mode
            %                           2: Charging Mode
            %                           3: Communication Mode
            %                           4: Experiment Mode
            
            %%% CURRENT BOOLEANS
            %disp(powerSystem)
            socSafeBool = logical(powerSystem.battery.soc >= obj.socSafe);
            socUnsafeBool = logical(powerSystem.battery.soc <= obj.socUnsafe);
            sunBool = logical(obj.sunBools(t));
            accessBool = logical(obj.accessBools(t));
            
            
            %%% COMMAND GENERATION
            % See flow diagram at the following link
            % https://gyazo.com/ef278bac0c2706910483c412da6b094a
            % And pray I didn't mess this up
            if socUnsafeBool
                if sunBool
                    command = 2;
                else
                    command = 0;
                end
            else
                if accessBool
                    command = 3;
                else
                    if ~socSafeBool
                        if sunBool
                            command = 2;
                        else
                            command = 1;
                        end
                    else
                        command = 4;
                    end
                end
            end
        end
    end
end
