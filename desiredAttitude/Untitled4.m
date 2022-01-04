
%%% NAME: TEST FUNCTION!
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
disp('Getting Relevant Data')

% Time Vector
scenStartTime = datetime(scenarioStartTime, 'InputFormat', 'dd MMM yyyy HH:mm:ss.SSS', 'Format', 'dd MMM yyyy HH:mm:ss.S');
scenStopTime = datetime(scenarioStopTime, 'InputFormat', 'dd MMM yyyy HH:mm:ss.SSS', 'Format', 'dd MMM yyyy HH:mm:ss.S');
dt = seconds(interval);
timeVector = (scenStartTime:dt:scenStopTime)';
count = length(timeVector);
quaternionFinal = zeros(count, 4);

% Obtain and Load Access Vector
[accessTimes, accessVector] = getAccessVector(scenario, satellite, facility, access, interval);
qAccess = v2q(accessVector, [1,0,0]);

% Obtain and Load Sun Vector
[sunTimes, sunVector] = getSunVector(scenario, satellite, interval);
qSun = v2q(sunVector, [0,0,-1]);

% Sift through everything
tCountA = 1;
tCountS = 1;
for a = 1:count
    if abs(accessTimes(tCountA) - timeVector(a)) <= seconds(0.05)
        quaternionFinal(a,:) = qAccess(tCountA,:);
        qLast = qAccess(tCountA,:);
        tCountA = tCountA + 1;
        if abs(sunTimes(tCountS) - timeVector(a)) <= seconds(0.05)
            tCountS = tCountS + 1;
        end
    elseif abs(sunTimes(tCountS) - timeVector(a)) <= seconds(0.05)
        quaternionFinal(a,:) = qSun(tCountS,:);
        qLast = qSun(tCountS,:);
        tCountS = tCountS + 1;
    else
        quaternionFinal(a,:) = qLast;
    end
end

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
        quaternionFinal(i,2), quaternionFinal(i,3), quaternionFinal(i,4), quaternionFinal(i,1));
end

fprintf(fid, 'END Attitude');

% Close file
fclose(fid);
disp('Attitude File Created')


%%% LOAD ATTITUDE FILE
toAttitudeFile = 'C:\Users\miastra\Documents\MATLAB\Satellite Stuff\Satellite Control Stuff\desiredAttitude\attitudeQ.a';
satellite.Attitude.External.Load(toAttitudeFile);

disp('Attitude (quaternion) Data Added')

