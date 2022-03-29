function [sunBool, sunVectorFull] = getSunVectorFull(scenario, satellite, timeVector, dt)
%%% getSunVectorFull
%       Return index of when access is available and associated pointing vector
%
%   INPUTS:
%       scenario            Scenario (object)
%       satellite           Satellite (object)
%       timeVector          Time Vector
%       dt                  Time Step
%
%   OUTPUTS:
%       sunBool             List of Sun Time Bools
%                               0 (false):  Access Unavailable
%                               1 (true):   Access Available
%       sunVectorFull       Contains all information about pointing
%                               Format: (double: <x, y, z> in Fixed Frame)
%                               Returns <0, 1, 0> if access unavailable
%

%%% SETUP
% EMPTY SUN VECTOR (FULL)
count = length(timeVector);
sunBool = false(count,1);
sunVectorFull = zeros(count,3);

%%% DATA PROVIDERS
% LIGHTING
satLTDP = satellite.DataProviders.GetDataPrvIntervalFromPath('Lighting Times/Sunlight').Exec(scenario.StartTime, scenario.StopTime);
satLTstart = cell2mat(satLTDP.DataSets.GetDataSetByName('Start Time').GetValues);
satLTstop = cell2mat(satLTDP.DataSets.GetDataSetByName('Stop Time').GetValues);

% SUN ROTATION AXIS AND ANGLE
sunRotationAxis = satellite.DataProviders.GetDataPrvTimeVarFromPath('Vectors(Fixed)/RotationAxis1').Exec(scenario.StartTime, scenario.StopTime, interval);
sunRotationAngle = satellite.DataProviders.GetDataPrvTimeVarFromPath('Angles/RotationAngle1').Exec(scenario.StartTime, scenario.StopTime, interval);

sunRotationAxis = [
    cell2mat(sunRotationAxis.DataSets.GetDataSetByName('x/Magnitude').GetValues),...
    cell2mat(sunRotationAxis.DataSets.GetDataSetByName('y/Magnitude').GetValues),...
    cell2mat(sunRotationAxis.DataSets.GetDataSetByName('z/Magnitude').GetValues),...
];

sunRotationAngle = cell2mat(sunRotationAngle.DataSets.GetDataSetByName('Angle').GetValues);

[sunTimes, eachCount] = interpolateTimes(satLTstart, satLTstop, dt);



a = 1;
for i = 1:count
    if abs(timeVector(i) - sunTimes(a)) <= 0.05
        sunBool(i) = true;
        a = a + 1;
    else
        sunBool(i) = false;
    end
end


end

