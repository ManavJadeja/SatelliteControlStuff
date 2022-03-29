%%% INTERPOLATE IN ACCESS WINDOW
disp('Interpolating Times')

% Access Data
accessDP = access.DataProviders.Item('Access Data').Exec(scenario.StartTime, scenario.StopTime);

% Start and Stop Times
startArray = cell2mat(accessDP.DataSets.GetDataSetByName('Start Time').GetValues);
stopArray = cell2mat(accessDP.DataSets.GetDataSetByName('Stop Time').GetValues);
[rows,cols] = size(startArray);

%%% INTERPOLATION SCHEMES

% Equally Spaced Times
points = 16;
times = NaT(rows, points, 'Format', 'dd MMM yyyy HH:mm:ss.SSSSSSSSS');

% Interpolation
for a = 1:rows
    times(a,1) = datetime(startArray(a,:), 'InputFormat', 'dd MMM yyyy HH:mm:ss.SSSSSSSSS');
    times(a,end) = datetime(stopArray(a,:), 'InputFormat', 'dd MMM yyyy HH:mm:ss.SSSSSSSSS');
    dt = times(a,end) - times(a,1);
    for b = 1:points-1
        times(a,b) = times(a,1) + (b-1)*dt/points;
    end
end


disp('Interpolated Times Computed')