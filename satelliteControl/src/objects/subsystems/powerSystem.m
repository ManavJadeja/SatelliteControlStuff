classdef powerSystem < handle
    %%% powerSystem
    %       Power System for a Satellite
    %       
    %   Created by Manav Jadeja on 20220102
    
    properties
        time                % Time Vector
        stateI              % Initial State Vector
        
        battery             % Battery (object)
        batteryVoltage      % Voltage of battery (vector)
        chargingVoltage     % Charging voltage from battery data curve (vector)
        chargingSoc         % Charging SOC from battery data curve (vector)
        dischargingVoltage  % Discharging voltage from battery data curve (vector)
        dischargingSoc      % Discharging SOC from battery data curve (vector)
        solarArray          % Solar Array (object)
        electricalSystem    % Electrical System (object)
                
        h                   % Handle
    end

    properties (Constant)
        SimpleSolarValue = 100         % Power, in watts, generated by the solar panel
    end
    
    methods
        function obj = powerSystem(time, battery, batteryData, solarArray, electricalSystem)
            %%% powerSystem
            %       Create a power system
            
            obj.time = time;
            obj.battery = battery;
            obj.chargingVoltage = transpose([batteryData.battChgRows.cV]);
            obj.chargingSoc = transpose([batteryData.battChgRows.cSOC]);
            obj.dischargingVoltage = transpose([batteryData.battDchgRows.dV]);
            obj.dischargingSoc = transpose([batteryData.battDchgRows.dSOC]);
            obj.solarArray = solarArray;
            obj.electricalSystem = electricalSystem;
            obj.stateI = obj.battery.soc;

            obj.batteryVoltage = obj.chargingVoltage(binarySearch(obj.chargingSoc, obj.stateI));
        end

        function [soc] = step(obj, dt, command)
            %%% Simulates a single time step of the power system

            nothingLoadCurrent = obj.electricalSystem.nothingLoadCurrent;
            safetyLoadCurrent = obj.electricalSystem.safetyLoadCurrent;
            experimentLoadCurrent = obj.electricalSystem.experimentLoadCurrent;
            chargingLoadCurrent = obj.electricalSystem.chargingLoadCurrent;
            communicationLoadCurrent = obj.electricalSystem.communicationLoadCurrent;

            % Compute current produced by solar array
            solarArrayCurrent = 0;
            action = command;
            if action == 4 % charging mode
                solarArrayCurrent = obj.SimpleSolarValue / obj.batteryVoltage;
            end

            %%% Compute current used by load
            if action >= 5 % Communication Mode
                loadCurrent = communicationLoadCurrent;
            elseif action == 4 % Charging Mode
                loadCurrent = chargingLoadCurrent;
            elseif action == 3 % Experiment Mode
                loadCurrent = experimentLoadCurrent;
            elseif action == 2 % Safety Mode
                loadCurrent = safetyLoadCurrent;
            else % Nothing Mode
                loadCurrent = nothingLoadCurrent;
            end

            %%% Net current through the battery
            % Compute the current through the battery
            batteryCurrent = solarArrayCurrent - loadCurrent;

            %%% Voltage data 
            if batteryCurrent > 0
                voltageCharge = obj.chargingVoltage(binarySearch(obj.chargingSoc, obj.stateI));

                batteryCurrent = min(batteryCurrent, obj.battery.maxI);

                obj.batteryVoltage = voltageCharge + obj.battery.R_charge * batteryCurrent;
                
                %if obj.batteryVoltage > obj.battery.maxV
                %    obj.batteryVolage = obj.battery.maxV;
                %    batteryCurrent = (obj.batteryVoltage - voltageCharge) / obj.battery.R_charge;
                %end

            else
                voltageDischarge = obj.dischargingVoltage(binarySearch(obj.dischargingSoc, obj.stateI));

                obj.batteryVoltage = voltageDischarge + obj.battery.R_discharge * batteryCurrent;

            end

            % Compute change in the charge of the battery
            ahrChange = batteryCurrent * dt / 60 / 60;
            % Return the new SOC, clamped between 0 and 1
            soc = min(1, max(0, obj.stateI + ahrChange / obj.battery.capacity));
            obj.stateI = soc;

        end
    end
end

