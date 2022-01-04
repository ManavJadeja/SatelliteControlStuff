function [times, accessVector] = getAccessVector(scenario, object1, object2, access, interval)
%%% NAME: getPointingVector
%
%   INPUTS:
%       scenario        Scenario (object)
%       object1         Satellite (object)
%       object2         Facility (object)
%       access          Access (object)
%       interval        Interval between two points in time
%
%   OUPUTS:
%       times           List of times (interpolated between access windows)
%       accessVector    The vector connecting object1 and object2 in times
%
%   PROCESS:
%       1) Interpolates all access windows and creates a 'time vector'
%       2) Creates an empty matrix to store all the values
%       3) Goes through all interpolated access windows (one at a time)
%       4) Get position data from objects in a interpolated access window
%       5) Take the difference of position to get relative position vector
%

% Access Windows
accessDP = access.DataProviders.Item('Access Data').Exec(scenario.StartTime, scenario.StopTime);
accessStart = cell2mat(accessDP.DataSets.GetDataSetByName('Start Time').GetValues);
accessStop = cell2mat(accessDP.DataSets.GetDataSetByName('Stop Time').GetValues);

% Time Vector, Interval Sizes, and Empty Access Vector
[times, eachCount] = interpolateXs(accessStart, accessStop, interval);
accessVector = zeros(sum(eachCount)-1,3);

% Iterate through each interpolated access window
for i = 1:length(eachCount)
    % Interval of Access Window
    startInterval = sum(eachCount(1:i-1))+1;
    stopInterval = sum(eachCount(1:i));
    
    % Get Object1 Position Vector
    %commandS = char(['Position */Satellite/SPICESat "', char(times(i)), '"']);
    %S = strsplit(root.ExecuteCommand(commandS).Item(0));
    obj1PosDP = object1.DataProviders.GetDataPrvTimeVarFromPath('Cartesian Position/Fixed').Exec(accessStart(i,:), accessStop(i,:), interval);
    obj1px = cell2mat(obj1PosDP.DataSets.GetDataSetByName('x').GetValues);
    obj1py = cell2mat(obj1PosDP.DataSets.GetDataSetByName('y').GetValues);
    obj1pz = cell2mat(obj1PosDP.DataSets.GetDataSetByName('z').GetValues);
    
    % Get Object2 Position Vector
    %commandF = char(['Position */Facility/RU_GS "', char(times(i)), '"']);
    %F = strsplit(root.ExecuteCommand(commandF).Item(0));
    obj2PosDP = object2.DataProviders.GetDataPrvFixedFromPath('Cartesian Position').Exec();
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

