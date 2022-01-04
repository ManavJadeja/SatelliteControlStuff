function [] = afECF(scenario, satellite, facility, access, scenarioStartTime, scenarioStopTime, interval)
%%% NAME: afECF
%       Comes from 'Attitude File in Earth Centered Fixed Frame'
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
%      Attitude File (.a) > Created in folder with name 'attitudeECF.a'
%
%   PROCESS:
%       1) Compute relevant access data and pointing vector data
%       2) Format of attitude file
%       3) Iterate through times and pointing vectors and add data to file
%


%%% ATTITUDE FILE DATA
disp('Creating Attitude File (ECF)')

% Time Vector
scenStartTime = datetime(scenarioStartTime, 'InputFormat', 'dd MMM yyyy HH:mm:ss.SSS', 'Format', 'dd MMM yyyy HH:mm:ss.S');
scenStopTime = datetime(scenarioStopTime, 'InputFormat', 'dd MMM yyyy HH:mm:ss.SSS', 'Format', 'dd MMM yyyy HH:mm:ss.S');
dt = seconds(interval);
timeVector = (scenStartTime:dt:scenStopTime)';
count = length(timeVector);

% Access Vector Data
[accessTimes, accessVector] = getAccessVector(scenario, satellite, facility, access, interval);

% Sun Vector Data
[sunTimes, sunVector] = getSunVector(scenario, satellite, interval);

% Full Vector
finalVector = zeros(count, 3);
vectorLast = [1;0;0];
tCountA = 1;
tCountS = 1;
for a = 1:count
    if abs(accessTimes(tCountA) - timeVector(a)) <= seconds(0.05)
        finalVector(a,:) = accessVector(tCountA,:);
        vectorLast = accessVector(tCountA,:);
        tCountA = tCountA + 1;
        if abs(sunTimes(tCountS) - timeVector(a)) <= seconds(0.05)
            tCountS = tCountS + 1;
        end
    elseif abs(sunTimes(tCountS) - timeVector(a)) <= seconds(0.05)
        finalVector(a,:) = sunVector(tCountS,:);
        vectorLast = sunVector(tCountS,:);
        tCountS = tCountS + 1;
    else
        finalVector(a,:) = vectorLast;
    end
end


%%% CREATING ATTITUDE FILE
fid = fopen('attitudeECF.a', 'wt');

% Preliminary Information
fprintf(fid, 'stk.v.12.2\n');
fprintf(fid, 'BEGIN Attitude\n');
fprintf(fid, 'NumberOfAttitudePoints %f\n', count);
fprintf(fid, 'ScenarioEpoch %s\n', scenarioStartTime);
fprintf(fid, 'BlockingFactor 20\n');
fprintf(fid, 'InterpolationOrder 0\n');
fprintf(fid, 'CentralBody Earth\n');
fprintf(fid, 'CoordinateAxes Fixed\n');
fprintf(fid, 'TimeFormat UTCG\n');
fprintf(fid, 'AttitudeTimeECFVector\n');
fprintf(fid, '\n');


%%% ADD DATA TO ATTITUDE FILE    
for i = 1:count
    fprintf(fid, '%s %f %f %f\n', datestr(timeVector(i), 'dd mmm yyyy HH:MM:SS.FFF'), finalVector(i,1), finalVector(i,2), finalVector(i,3));
end

fprintf(fid, 'END Attitude');

% Close file
fclose(fid);
disp('Attitude File Created')


%%% LOAD ATTITUDE FILE TO SATELLITE
toAttitudeFile = 'C:\Users\miastra\Documents\MATLAB\Satellite Stuff\Satellite Control Stuff\desiredAttitude\attitudeECF.a';
satellite.Attitude.External.Load(toAttitudeFile);

disp('Attitude (ECF) Data Added')

end

