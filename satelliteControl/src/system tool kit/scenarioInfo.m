function [scenario, timeVector, dt] = scenarioInfo(root)
%%% SCENARIO INFORMATION
%   Information for Scenario (object) in Systems Tool Kit
%       1) Input Parameters
%       2) Definitions derived from Parameters
%
%   Parameters
%       scenName                Scenario Name (char array: name)
%       scenStartTime           Scenario Start Time (char array: date)
%                                   % Format: 'dd MMM yyyy HH:mm:ss:SSS'
%       scenStopTime            Scenario Stop Time (char array: date)
%                                   % Format: 'dd MMM yyyy HH:mm:ss:SSS'
%       interval                Time Step (double: seconds)
%
%   Definitions
%       scenStartTime           Analysis Start Time (datetime: date)
%       scenStopTime            Analysis Stop Time (datetime: date)
%       dt                      Time Step (duration: seconds)
%       timeVector              Time Vector (column list of datetimes)
%       scenario                Scenario (object)
%
%   Created by Manav Jadeja on 20220101


%%% PARAMETERS
scenName = 'solid';
scenStartTime = '24 Dec 2021 00:00:00.000';
scenStopTime = '24 Dec 2021 02:00:00.000';
% TIME STEP (FIXED)
dt = 0.1;


%%% DEFINITIONS
% TIME VECTOR
scenStart = datetime(scenStartTime, 'InputFormat', 'dd MMM yyyy HH:mm:ss.SSS', 'Format', 'dd MMM yyyy HH:mm:ss.S');
scenStop = datetime(scenStopTime, 'InputFormat', 'dd MMM yyyy HH:mm:ss.SSS', 'Format', 'dd MMM yyyy HH:mm:ss.S');
interval = seconds(dt);
timeVector = (scenStart:interval:scenStop)';

% SCENARIO (OBJECT)
scenario = root.Children.New('eScenario',scenName);

% SCENARIO PROPERTIES
scenario.SetTimePeriod(scenStartTime, scenStopTime)
scenario.StartTime = scenStartTime;
scenario.StopTime = scenStopTime;

disp("Created: Scenario")


end
