function [] = afQSIM(scenario, satellite, facility, access, scenarioStartTime, scenarioStopTime, interval)
%%% NAME: afQSIM
%       Comes from 'Attitude File based on Quaternion Simulation'
%
%   INPUTS:
%       scenario                Scenarion (object)
%       satellite               Satellite (object)
%       facility                Facility (object)
%       access                  Access (object)
%       scenarioStartTime       Scenario Start Time
%       scenarioStopTime        Scenario Stop Time
%       interval                Time Step
%       
%   OUTPUTS:
%      Attitude File (.a) > Created in folder with name 'attitudeQSIM.a'
%
%   PROCESS:
%       1) Given scenario information (and objects in it)
%       2) Go through access windows (interpolated) and get access vectors
%       3) Load access vectors and obtain access quaternions
%       4) Use access quaternions to run control system simulation
%       5) Create and format attitude file
%       6) Add simulated times and quaternions data to file
%


%%% ATTITUDE FILE DATA
% Time Vector
scenStartTime = datetime(scenarioStartTime, 'InputFormat', 'dd MMM yyyy HH:mm:ss.SSS', 'Format', 'dd MMM yyyy HH:mm:ss.S');
scenStopTime = datetime(scenarioStopTime, 'InputFormat', 'dd MMM yyyy HH:mm:ss.SSS', 'Format', 'dd MMM yyyy HH:mm:ss.S');
dt = seconds(interval);
timeVector = (scenStartTime:dt:scenStopTime)';
count = length(timeVector);

% Obtain and Load Access Vector
afECF(scenario, satellite, facility, access, scenarioStartTime, scenarioStopTime, interval)

% Obtain Access Quaternions
finalQuaternion = getDesiredQuaternion(scenario, satellite, timeVector, interval);

% Run Simulation
disp('Creating Attitude File (Simulated Quaternion)')
quaternionSimulated = controlSimulation(timeVector, finalQuaternion, interval);


%%% CREATING ATTITUDE FILE
fid = fopen('attitudeQSIM.a', 'wt');


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
        quaternionSimulated(i,2), quaternionSimulated(i,3), quaternionSimulated(i,4), quaternionSimulated(i,1));
end

fprintf(fid, 'END Attitude');

% Close file
fclose(fid);
disp('Attitude File Created')


%%% LOAD ATTITUDE FILE
toAttitudeFile = 'C:\Users\miastra\Documents\MATLAB\Satellite Stuff\Satellite Control Stuff\desiredAttitude\attitudeQSIM.a';
satellite.Attitude.External.Load(toAttitudeFile);

disp('Attitude (quaternion) Data Added')

end
