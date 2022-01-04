function [count] = attitudepoints(scenario, access, intervalX)

% Get Access Windows
accessDP = access.DataProviders.Item('Access Data').Exec(scenario.StartTime, scenario.StopTime);
startArray = cell2mat(accessDP.DataSets.GetDataSetByName('Start Time').GetValues);
stopArray = cell2mat(accessDP.DataSets.GetDataSetByName('Stop Time').GetValues);

count = 0;
for a = 1:size(startArray, 1)
    timeStart = datetime(startArray(a,:), 'InputFormat', 'dd MMM yyyy HH:mm:ss.SSSSSSSSS');
    timeStop = datetime(stopArray(a,:), 'InputFormat', 'dd MMM yyyy HH:mm:ss.SSSSSSSSS');
    times = interpolateXs(timeStart, timeStop, intervalX);
    
    % Add relevant data
    [rows2, cols2] = size(times);
    count = count + rows2*cols2;
end

end