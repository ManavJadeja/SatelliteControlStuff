classdef electricalSystem
    %ELECTRICALSYSTEM Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        nothingLoadCurrent          % Current Draw for Nothing Mode (Amps)
        safetyLoadCurrent           % Current Draw for Safety Mode (Amps)
        experimentLoadCurrent       % Current Draw for Experiment Mode (Amps)
        chargingLoadCurrent         % Current Draw for Charging Mode (Amps)
        communicationLoadCurrent    % Current Draw for Communication Mode (Amps)

        % BASED ON COMMAND SYSTEM
            % 1: Nothing Mode
            % 2: Safety Mode
            % 3: Experiment Mode
            % 4: Charging Mode
            % 5: Communication Mode

    end
    
    methods
        function obj = electricalSystem(nothingLoadCurrent, safetyLoadCurrent, experimentLoadCurrent,...
                chargingLoadCurrent, communicationLoadCurrent)
            %%% electricalSystem
            %       Create an electrical system
            obj.nothingLoadCurrent = nothingLoadCurrent;
            obj.safetyLoadCurrent = safetyLoadCurrent;
            obj.experimentLoadCurrent = experimentLoadCurrent;
            obj.chargingLoadCurrent = chargingLoadCurrent;
            obj.communicationLoadCurrent = communicationLoadCurrent;

        end
        
    end
end

