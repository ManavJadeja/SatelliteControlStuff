function [] = afECF(root, scenario, satellite, access, scenarioStartTime, interval)
%%% AFECF 
%   Creates an Attitule File (.a)
%   Format is based on the ECF Vector between objects
%   Iterates through access window and creates file


disp('Creating Attitude File')

%%% CREATING ATTITUDE FILE
fid = fopen('attitudeECF.a', 'wt');

% Number of Attitude Points
countT = attitudepoints(scenario, access, interval);
count0 = 1;
pointingVector = zeros(countT, 3);

%%% PRELIMINARY INFORMATION
% See sample .a file on AGI help site for formatting this stuff
fprintf(fid, 'stk.v.12.2\n');
fprintf(fid, 'BEGIN Attitude\n');
fprintf(fid, 'NumberOfAttitudePoints %f\n', countT); % Number of data points
fprintf(fid, 'ScenarioEpoch %s\n', scenarioStartTime); % start is starting time
fprintf(fid, 'BlockingFactor 20\n');
fprintf(fid, 'InterpolationOrder 0\n');
fprintf(fid, 'CentralBody Earth\n');
fprintf(fid, 'CoordinateAxes Inertial\n');
fprintf(fid, 'TimeFormat UTCG\n');
fprintf(fid, 'AttitudeTimeECFVector\n');
fprintf(fid, '\n');


%%% GET ACCESS WINDOWS
accessDP = access.DataProviders.Item('Access Data').Exec(scenario.StartTime, scenario.StopTime);
startArray = cell2mat(accessDP.DataSets.GetDataSetByName('Start Time').GetValues);
stopArray = cell2mat(accessDP.DataSets.GetDataSetByName('Stop Time').GetValues);
rows1 = size(startArray, 1);

% Interpolate through all access windows
for a = 1:rows1
    % Get all the data!
    timeStart = datetime(startArray(a,:), 'InputFormat', 'dd MMM yyyy HH:mm:ss.SSSSSSSSS');
    timeStop = datetime(stopArray(a,:), 'InputFormat', 'dd MMM yyyy HH:mm:ss.SSSSSSSSS');
    times = interpolateXs(timeStart, timeStop, interval);
    pointingR = getECFVector(root, times);
    
    % Add data
    rows2 = size(times, 1);
    for i = 1:rows2
        % Adding each ECF Vector to the Attitude File
        pointingR_i = pointingR(i, 1:3);
        pointingVector(count0, :) = pointingR(i, 1:3)/norm(pointingR(i, 1:3));
        count0 = count0 + 1;
        fprintf( fid, '%s %f %f %f\n', datestr(times(i), 'dd mmm yyyy HH:MM:SS.FFF'), pointingR_i(1), pointingR_i(2), pointingR_i(3));
    end
end

fprintf(fid, 'END Attitude');

% Close file
fclose(fid);
disp('Attitude File Created')


%%% LOAD ATTITUDE FILE
toAttitudeFile = 'C:\Users\miastra\Documents\MATLAB\Satellite Stuff\Satellite Control Stuff\desiredAttitude\attitudeECF.a';
satellite.Attitude.External.Load(toAttitudeFile);

disp('Attitude (ECF) Data Added')

end

