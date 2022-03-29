classdef battery < handle
    %%% battery
    %       Battery Object
    %
    %   Created by Manav Jadeja on 20220102
    
    properties
        capacity            % Battery Capacity (Ahr)
        soc                 % State of Charge
        R_charge            % Charging Internal Resistance (Ohms)
        R_discharge         % Discharging Internal Resistance (Ohms)
        maxV                % Battery Max Voltage (V)
        maxI                % Battery Max Current (A)
        cells               % Battery Cells (num)
        lineDrop            % Battery Line Drop
        
        h                   % Handle
    end
    
    methods
        function obj = battery(capacity, soc, R_charge, R_discharge,...
                maxV, maxI, cells, lineDrop)
            %%% Battery
            %       Create a battery
            
            obj.capacity = capacity;
            obj.soc = soc;
            obj.R_charge = R_charge;
            obj.R_discharge = R_discharge;
            obj.maxV = maxV;
            obj.maxI = maxI;
            obj.cells = cells;
            obj.lineDrop = lineDrop;
            
        end
        
    end
end

