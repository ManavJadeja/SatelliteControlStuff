classdef ssd < handle
    %%% ssd
    %   	Solid State Drive (Object)
    %
    %   Created by Manav Jadeja on 20220515
    
    properties
        capacity                % Capacity in MB (megabytes)
        
        dataGenerationRates     % Data Generation Rate (MB/s)
            % BASED ON COMMAND SYSTEM
            % 1: Nothing Mode
            % 2: Safety Mode
            % 3: Experiment Mode
            % 4: Charging Mode
            % 5: Communication Mode
                
        state0                  % Initial State Vector (% full)
        
        h
    end
    
    methods
        function obj = ssd(capacity, nothingDataGen, safetyDataGen, experimentDataGen,...
                chargingDataGen, communicationDataGen, state0)
            %%% ssd
            %   	Create an ssd
            obj.capacity = capacity;
            obj.dataGenerationRates = [
                nothingDataGen;
                safetyDataGen;
                experimentDataGen;
                chargingDataGen;
                communicationDataGen
            ];
        
            obj.state0 = state0;
        end
    end
end

