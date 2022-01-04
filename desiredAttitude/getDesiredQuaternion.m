function [finalQuaternion] = getDesiredQuaternion(scenario, satellite, timeVector, interval)
%%% NAME: getAccessQuaternion
%
%   INPUTS:
%       scenario                Scenario (object)
%       satellite               Satellite (object)
%       timeVector              Scenario Time Vector
%       interval                Time step
%
%   OUPUTS:
%       finalQuaternion         Desired Quaternion Values
%
%   PROCESS:
%       1) Iterate through scenario at fixed interval
%       2) Find all access window and sun vector pointings
%       3) Add desired vector per hierarchy
%

% Empty Quaternion Matrix
finalQuaternion = zeros(length(timeVector),4);

% Get Object Quaternions (first three vector, fourth is scalar)
satATDP = satellite.DataProviders.GetDataPrvTimeVarFromPath('ECF Attitude Quaternions').Exec(scenario.StartTime, scenario.StopTime, interval);
satQ1 = cell2mat(satATDP.DataSets.GetDataSetByName('q1').GetValues);
satQ2 = cell2mat(satATDP.DataSets.GetDataSetByName('q2').GetValues);
satQ3 = cell2mat(satATDP.DataSets.GetDataSetByName('q3').GetValues);
satQ4 = cell2mat(satATDP.DataSets.GetDataSetByName('q4').GetValues);

finalQuaternion(1:length(timeVector),:) = [
    satQ4(1:length(timeVector)),...
    satQ1(1:length(timeVector)),...
    satQ2(1:length(timeVector)),...
    satQ3(1:length(timeVector)),...
];

end

