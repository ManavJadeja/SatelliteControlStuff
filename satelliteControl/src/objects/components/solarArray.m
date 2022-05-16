classdef solarArray
    %%% solarArray
    %       Solar Array (Object)
    %
    %   Created by Manav Jadeja 20220103
    
    properties
        area                    % Solar Array Area (Total)
        normalVector            % Normal Vector to Area
        efficiency              % Efficiency (E Input > E Output)
    end
    
    methods
        function obj = solarArray(area, normalVector, efficiency)
            %%% solarArray
            %       Create a satellite solar array
            obj.area = area;
            obj.normalVector = normalVector/norm(normalVector);
            obj.efficiency = efficiency;
        end
        
        function [powerOut] = powerOut(obj, pointingVector, solarFlux)
            %%% powerOut
            %       Computes the power output for a given configuration
            %       Assumes satellite is in solar lighting
            %   INPUTS:
            %       obj                 % Solar Array (object)
            %       pointingVector      % Current Orientation
            %       solarFlux           % Energy Flux (W/m^2)
            %   OUTPUTS:
            %       powerOut            % Power Output
            
            %%% PRELIMINARY INFORMATION
            pointingVector = pointingVector/norm(pointingVector);
            angle = acos(dot(obj.normalVector, pointingVector));
            maxEnergy = solarFlux*obj.area;
            
            
            %%% COMPUTE POWER GENERATION
            if abs(angle) < pi/2
                powerOut = maxEnergy*cos(angle);
            else
                powerOut = 0;
            end
        end
    end
end

