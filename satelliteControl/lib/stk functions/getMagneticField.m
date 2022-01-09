function [satBField] = getMagneticField(scenario, satellite, dt)
%%% getMagneticField
%       Get Full Magnetic Field
%
%   INPUTS:
%       scenario            Scenario (object)
%       satellite           Satellite (object)
%       dt                  Time Step
%
%   OUTPUTS:
%       satBField           B Field at Satellite Location
%                               ECF Frame (double: teslas)
%

%%% DATA PROVIDER
% SEET MAGNETIC FIELD
satBDP = satellite.DataProviders.GetDataPrvTimeVarFromPath('SEET Magnetic Field').Exec(scenario.StartTime, scenario.StopTime, dt);


%%% OUTPUT
% SATELLITE MAGNETIC FIELD
satBField = [
    cell2mat(satBDP.DataSets.GetDataSetByName('B Field - ECF x').GetValues),...
    cell2mat(satBDP.DataSets.GetDataSetByName('B Field - ECF y').GetValues),...
    cell2mat(satBDP.DataSets.GetDataSetByName('B Field - ECF z').GetValues),...
];


end

