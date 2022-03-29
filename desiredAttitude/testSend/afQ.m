function [] = afQ(root, scenario, satellite, access, scenarioStartTime, interval)
%%% AFQ
%%% CHANGE THIS TO TAKE IN A LIST OF QUATERNIONS AND OUTPUT THE FINAL FILE
%%% SHOULD COME AFTER THE CONTROL STUFF HAS BEEN ACCOUNTED FOR!
%   Creates an Attitule File (.a)
%   Format is based on the quaternion attitude
%   Iterates through access window and creates file

disp('Creating Attitude File')

%%% CREATING ATTITUDE FILE
fid = fopen('attitudeQ.a', 'wt');

% Number of Attitude Points
count = attitudepoints(scenario, access, interval);


%%% PRELIMINARY INFORMATION
% See sample .a file on AGI help site for formatting this stuff
fprintf(fid, 'stk.v.12.2\n');
fprintf(fid, 'BEGIN Attitude\n');
fprintf(fid, 'NumberOfAttitudePoints %f\n', count); % Number of data points
fprintf(fid, 'ScenarioEpoch %s\n', scenarioStartTime); % start is starting time
fprintf(fid, 'BlockingFactor 20\n');
fprintf(fid, 'InterpolationOrder 0\n');
fprintf(fid, 'CentralBody Earth\n');
fprintf(fid, 'CoordinateAxes Custom Body Satellite/SPICESat\n');
fprintf(fid, 'TimeFormat UTCG\n');
fprintf(fid, 'AttitudeTimeQuatScalarFirst\n');
fprintf(fid, '\n');


%%% GET ACCESS WINDOWS
accessDP = access.DataProviders.Item('Access Data').Exec(scenario.StartTime, scenario.StopTime);
startArray = cell2mat(accessDP.DataSets.GetDataSetByName('Start Time').GetValues);
stopArray = cell2mat(accessDP.DataSets.GetDataSetByName('Stop Time').GetValues);
rows1 = size(startArray, 1);

% Facility Position Vector
%commandF = char(['Position */Facility/RU_GS "', char(scenarioStartTime), '"']);
%F = strsplit(root.ExecuteCommand(commandF).Item(0));
%pointingF = [
%    str2double(F{1,4});
%    str2double(F{1,5});
%    str2double(F{1,6});
%];

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
        % Adding each Quaternion to the Attitude File
        pointingR_i = pointingR(i, 1:3);
        qd = v2q([1, 0, 0] , pointingR_i);
        %td(count2) = seconds(times(i) - scenStartTime);
        %count2 = count2 + 1;
        fprintf( fid, '%s %f %f %f %f\n', datestr(times(i)), qd(1), qd(2), qd(3), qd(4));
    end
end

fprintf(fid, 'END Attitude');

% Close file
fclose(fid);
disp('Attitude File Created')


%%% LOAD ATTITUDE FILE
toAttitudeFile = 'C:\Users\miastra\Documents\MATLAB\Satellite Stuff\Satellite Control Stuff\desiredAttitude\attitudeQ.a';
satellite.Attitude.External.Load(toAttitudeFile);

disp('Attitude (quaternion) Data Added')

end

