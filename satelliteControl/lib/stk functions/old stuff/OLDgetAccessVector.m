function [accessTimes, accessVector] = getAccessVector(scenario, satellite, facility, access, dt)
%%% getAccessVector
%       Returns a list of times when access is possible and associated access vector
%
%   INPUTS:
%       scenario            Scenario (object)
%       satellite           Satellite (object)
%       facility            Facility (object)
%       access              Access (object)
%       dt                  Time Step
%
%   OUPUTS:
%       accessTimes         List of Access Times
%       accessVector        Contains information about pointing
%                               Format: (double: <x, y, z> in Fixed Frame)
%

%%% SETUP
% ACCESS WINDOWS
accessDP = access.DataProviders.Item('Access Data').Exec(scenario.StartTime, scenario.StopTime);
accessStart = cell2mat(accessDP.DataSets.GetDataSetByName('Start Time').GetValues);
accessStop = cell2mat(accessDP.DataSets.GetDataSetByName('Stop Time').GetValues);

% Time Vector, Interval Sizes, and Empty Access Vector
[accessTimes, eachCount] = interpolateTimes(accessStart, accessStop, dt);
accessVector = zeros(sum(eachCount)-1,3);

% Iterate through each interpolated access window
for i = 1:length(eachCount)
    % Interval of Access Window
    startInterval = sum(eachCount(1:i-1))+1;
    stopInterval = sum(eachCount(1:i));
    
    % Get Object1 Position Vector
    %commandS = char(['Position */Satellite/SPICESat "', char(times(i)), '"']);
    %S = strsplit(root.ExecuteCommand(commandS).Item(0));
    obj1PosDP = satellite.DataProviders.GetDataPrvTimeVarFromPath('Cartesian Position/Fixed').Exec(accessStart(i,:), accessStop(i,:), dt);
    obj1px = cell2mat(obj1PosDP.DataSets.GetDataSetByName('x').GetValues);
    obj1py = cell2mat(obj1PosDP.DataSets.GetDataSetByName('y').GetValues);
    obj1pz = cell2mat(obj1PosDP.DataSets.GetDataSetByName('z').GetValues);
    
    % Get Object2 Position Vector
    %commandF = char(['Position */Facility/RU_GS "', char(times(i)), '"']);
    %F = strsplit(root.ExecuteCommand(commandF).Item(0));
    obj2PosDP = facility.DataProviders.GetDataPrvFixedFromPath('Cartesian Position').Exec();
    obj2px = cell2mat(obj2PosDP.DataSets.GetDataSetByName('x').GetValues);
    obj2py = cell2mat(obj2PosDP.DataSets.GetDataSetByName('y').GetValues);
    obj2pz = cell2mat(obj2PosDP.DataSets.GetDataSetByName('z').GetValues);
    
    % Final Pointing Vector
    accessVector(startInterval:stopInterval,:) = [
        obj2px - obj1px(1:stopInterval-startInterval+1),...
        obj2py - obj1py(1:stopInterval-startInterval+1),...
        obj2pz - obj1pz(1:stopInterval-startInterval+1),...
    ];
end

end
