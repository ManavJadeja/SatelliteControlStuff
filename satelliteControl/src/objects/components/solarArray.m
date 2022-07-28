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
    end
end

