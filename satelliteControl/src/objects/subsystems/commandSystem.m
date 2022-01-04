classdef commandSystem < handle
    %%% commandSystem
    %       Command System for a Satellite
    %
    %   Created by Manav Jadeja on 20220103
    
    properties
        socSafe                 % State of Charge (safe for access)
        socUnsafe               % State of Charge (unsafe for access)
        
        accessTimes             % Times for Access
        lightingTimes           % Times for Lighting
    end
    
    methods
        function obj = commandSystem(socSafe, socUnsafe)
            %%% commandSystem
            %       Create a Command System
            
            obj.socSafe = socSafe;
            obj.socUnsafe = socUnsafe;
        end
        
        function [command] = command(t, obj, powerSystem)
            %%% command
            %       Takes in some data and returns a command
            %   INPUTS:
            %       t               % Current Time Index
            %       obj             % Command System (object)
            %       powerSystem     % Power System (object)
            %   OUTPUTS:
            %       command         % Command (integer)
            %                           0: Safety Mode
            %                           1: Nothing Mode
            %                           2: Charging Mode
            %                           3: Communication Mode
            %                           4: Experiment Mode
            
            %%% CURRENT BOOLEANS
            socSafeBool = logical(powerSystem.battery.soc <= obj.socSafe);
            socUnsafeBool = logical(powerSystem.battery.soc <= obj.socUnsafe);
            lightingBool = logical(obj.lightingTimes(t));
            accessBool = logical(obj.accessTimes(t));
            
            
            %%% COMMAND GENERATION
            % See flow diagram at the following link
            % https://gyazo.com/ef278bac0c2706910483c412da6b094a
            % And pray I didn't mess this up
            if socUnsafeBool
                if lightingBool
                    command = 2;
                else
                    command = 0;
                end
            else
                if accessBool
                    command = 3;
                else
                    if socSafeBool
                        if lightingBool
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
        
        function [] = computeAccessTimes(obj, stkAccessTimes)
            %%% computeAccessTimes
            %       Convert STK Access Times into a readable format
            %   INPUTS:
            %       obj                 Attitude System (object)
            %       stkAccessTimes      STK Data Provider (Access Times)
            %   OUTPUTS:
            %       accessTimes         Access Times for easy use
            
            %%% NEED TO ADD CODE FOR READING DATA PROVIDER INFORMATION!
            
            obj.accessTimes = zeros(length(obj.time), 1);
            for a = 1:length(obj.time)
                if stkAccessTimes(a) == 'Access True'
                    obj.accessTimes(a) = 1;
                elseif stkAccessTimes(a) == 'Access False'
                    obj.accessTimes(a) = 0;
                else
                    disp('ERROR FOR ACCESS TIMES')
                end
            end
        end
        
        function [] = computeLightingTimes(obj, stkLightingTimes)
            %%% computeLightingTimes
            %       Convert STK Lighting Data into a readable format
            %   INPUTS:
            %       obj                 Power System (object)
            %       stkLightingTimes    STK Data Provider (Lighting Times)
            %   OUTPUTS:
            %       lightingTimes       Lighting Times for easy use
            
            %%% NEED TO ADD CODE FOR READING DATA PROVIDER INFORMATION!
            
            obj.lightingTimes = zeros(length(obj.time), 1);
            for a = 1:length(obj.time)
                if stkLightingTimes(a) == 'Sunlight'
                    obj.lightingTimes(a) = 1;
                else
                    obj.lightingTimes(a) = 0;
                end
            end
        end
    end
end
