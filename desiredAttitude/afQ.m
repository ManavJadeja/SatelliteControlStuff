function [] = afQ(scenario, satellite, facility, access, scenarioStartTime, scenarioStopTime, interval)
%%% NAME: afQ
%       Comes from 'Attitude File based on Quaternions'
%
%   INPUTS:
%       scenario                Scenario (object)
%       satellite               Satellite (object)
%       facility                Facility (object)
%       access                  Access (object)
%       scenarioStartTime       Scenario Start Time
%       scenarioStopTime        Scenario Stop Time
%       interval                Time Step
%
%   OUTPUTS:
%      Attitude File (.a) > Created in folder with name 'attitudeQ.a'
%
%   PROCESS:
%       1) Compute relevant access data and pointing vector data
%       2) Format of attitude file
%       3) Iterate through times and pointing vectors and add data to file
%


%%% ATTITUDE FILE DATA
% Time Vector
scenStartTime = datetime(scenarioStartTime, 'InputFormat', 'dd MMM yyyy HH:mm:ss.SSS', 'Format', 'dd MMM yyyy HH:mm:ss.S');
scenStopTime = datetime(scenarioStopTime, 'InputFormat', 'dd MMM yyyy HH:mm:ss.SSS', 'Format', 'dd MMM yyyy HH:mm:ss.S');
dt = seconds(interval);
timeVector = (scenStartTime:dt:scenStopTime)';
count = length(timeVector);

% Obtain and Load Access Vector
%afECF(scenario, satellite, facility, access, scenarioStartTime, scenarioStopTime, interval)

% Get Pointing Vector Data
disp('Creating Attitude File (Quaternion)')
%finalQuaternion = getDesiredQuaternion(scenario, satellite, timeVector, interval);


%%% CREATING ATTITUDE FILE
fid = fopen('attitudeQ.a', 'wt');


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


%%% ADD DATA TO ATTITUDE FILE    
for i = 1:count
    fprintf(fid, '%s %f %f %f %f\n', datestr(timeVector(i), 'dd mmm yyyy HH:MM:SS.FFF'),...
        0, 0, 0, 1);
        %finalQuaternion(i,1), finalQuaternion(i,2), finalQuaternion(i,3), finalQuaternion(i,4));
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
