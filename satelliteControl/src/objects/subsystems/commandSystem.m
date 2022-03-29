classdef commandSystem < handle
    %%% commandSystem
    %       Command System for a Satellite
    %
    %   Created by Manav Jadeja on 20220103
    
    properties
        socSafe                 % State of Charge (safe for access)
        socUnsafe               % State of Charge (unsafe for access)
        
        sunBools                % Sun Bools
        accessBools             % Access Bools

        stateS                  % Simulated State (commands)
    end
    
    methods
        function obj = commandSystem(socSafe, socUnsafe, sunBools, accessBools)
            %%% commandSystem
            %       Create a Command System
            
            obj.socSafe = socSafe;
            obj.socUnsafe = socUnsafe;
            
            obj.sunBools = sunBools;
            obj.accessBools = accessBools;
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
            %                           % 1: Nothing Mode
            %                           % 2: Safety Mode
            %                           % 3: Experiment Mode
            %                           % 4: Charging Mode
            %                           % 5: Access Location 1
            %                           % 6: Access Location 2
            %                           % N+4: Access Location N
            
            %%% CURRENT BOOLEANS
            socSafeBool = logical(powerSystem.battery.soc >= obj.socSafe);
            socUnsafeBool = logical(powerSystem.battery.soc <= obj.socUnsafe);
            sunBoolT = obj.sunBools(t);
            accessBoolsT = obj.accessBools(t,:);
            
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
                        command = 3;
                    end
                end
            end

            obj.stateS(t) = command;

        end
    end
end
