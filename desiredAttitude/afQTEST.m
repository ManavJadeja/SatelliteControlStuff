function [] = afQTEST(q, satellite, scenarioStartTime, scenarioStopTime, interval)

scenStartTime = datetime(scenarioStartTime, 'InputFormat', 'dd MMM yyyy HH:mm:ss.SSS', 'Format', 'dd MMM yyyy HH:mm:ss.S');
scenStopTime = datetime(scenarioStopTime, 'InputFormat', 'dd MMM yyyy HH:mm:ss.SSS', 'Format', 'dd MMM yyyy HH:mm:ss.S');
dt = seconds(interval);
timeVector = (scenStartTime:dt:scenStopTime)';
count = length(timeVector);

%%% CREATING ATTITUDE FILE
fid = fopen('scriptedAttitude.a', 'wt');

%%% PRELIMINARY INFORMATION
% See sample .a file on AGI help site for formatting this stuff
fprintf(fid, 'stk.v.12.2\n');
fprintf(fid, 'BEGIN Attitude\n');
fprintf(fid, 'NumberOfAttitudePoints %f\n', count); % Number of data points
fprintf(fid, 'ScenarioEpoch %s\n', scenarioStartTime); % start is starting time
fprintf(fid, 'BlockingFactor 20\n');
fprintf(fid, 'InterpolationOrder 0\n');
fprintf(fid, 'CentralBody Earth\n');
fprintf(fid, 'CoordinateAxes Fixed\n');
fprintf(fid, 'TimeFormat UTCG\n');
fprintf(fid, 'AttitudeTimeQuaternions\n');
fprintf(fid, '\n');


for i = 1:count
    fprintf( fid, '%s %f %f %f %f\n', datestr(timeVector(i), 'dd mmm yyyy HH:MM:SS.FFF'),...
        q(i,1), q(i,2), q(i,3), q(i,4));
end

fprintf(fid, 'END Attitude\n');

fclose(fid);

%%% LOAD ATTITUDE FILE
toAttitudeFile = 'C:\Users\miastra\Documents\MATLAB\Satellite Stuff\Satellite Control Stuff\desiredAttitude\scriptedAttitude.a';
satellite.Attitude.External.Load(toAttitudeFile);

disp('Attitude (quaternion) Data Added')

end