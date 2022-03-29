function [sunTimes, sunVector] = getSunVector(scenario, satellite, dt)
%%% getSunVector
%       Returns a list of times when in sunlight and associated sun vector
%
%   INPUTS:
%       scenario            Scenario (object)
%       satellite           Satellite (object)
%       dt                  Time Step
%
%   OUTPUTS:
%       sunTimes            Times of Lighting (sun)
%       sunVector           Components of Sun Vector
%                               Format: (double: <x, y, z> in Fixed Frame)
%

% Lighting Data Provider
satLTDP = satellite.DataProviders.GetDataPrvIntervalFromPath('Lighting Times/Sunlight').Exec(scenario.StartTime, scenario.StopTime);
satLTstart = cell2mat(satLTDP.DataSets.GetDataSetByName('Start Time').GetValues);
satLTstop = cell2mat(satLTDP.DataSets.GetDataSetByName('Stop Time').GetValues);

% Time Vector, Interval Sizes, and Empty Sun Vector
[sunTimes, eachCount] = interpolateTimes(satLTstart, satLTstop, dt);
sunVector = zeros(sum(eachCount)-1,3);

for i = 1:length(eachCount)
    % Interval of Access Window
    startInterval = sum(eachCount(1:i-1))+1;
    stopInterval = sum(eachCount(1:i));
    
    % Sun Vector Data Provider
    satSVDP = satellite.DataProviders.GetDataPrvTimeVarFromPath('Sun Vector/Fixed').Exec(satLTstart(i,:), satLTstop(i,:), dt);
    satSVx = cell2mat(satSVDP.DataSets.GetDataSetByName('x').GetValues);
    satSVy = cell2mat(satSVDP.DataSets.GetDataSetByName('y').GetValues);
    satSVz = cell2mat(satSVDP.DataSets.GetDataSetByName('z').GetValues);
    
    sunVector(startInterval:stopInterval,:) = [
        satSVx(1:stopInterval-startInterval+1),...
        satSVy(1:stopInterval-startInterval+1),...
        satSVz(1:stopInterval-startInterval+1),...
    ];  % ROTATION MATRIX HERE > 90 DEGRESS AROUND Y AXIS TO PUT Z AXIS ON X AXIS!
end
