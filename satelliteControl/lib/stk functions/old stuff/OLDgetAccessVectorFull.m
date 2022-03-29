function [accessBool, accessVectorFull] = getAccessVectorFull(scenario, satellite, facility, access, timeVector, dt)
%%% getAccessVectorFull
%       Return index of when access is available and associated pointing vector
%
%   INPUTS:
%       scenario            Scenario (object)
%       satellite           Satellite (object)
%       facility            Facility (object)
%       access              Access (object)
%       timeVector          Time Vector
%       dt                  Time Step
%
%   OUPUTS:
%       accessBool          List of Access Time Bools
%                               0 (false):  Access Unavailable
%                               1 (true):   Access Available
%       accessVectorFull    Contains all information about pointing
%                               Format: (double: <x, y, z> in Fixed Frame)
%                               Returns <1, 0, 0> if access unavailable
%

%%% SETUP
% EMPTY ACCESS VECTOR (FULL)
count = length(timeVector);
accessBool = zeros(count,1);
accessVectorFull = zeros(count,3);

% PRELIMINARY COMPUTATION
[accessTimes, accessVector] = getAccessVector(scenario, satellite, facility, access, dt);


%%% ACCESS VECTOR FULL AND BOOL
a = 1;
for i = 1:count
    if abs(timeVector(i) - accessTimes(a)) <= 0.05
        accessVectorFull(i,:) = accessVector(a,:);
        accessBool(i) = true;
        a = a + 1;
    else
        accessVectorFull(i,:) = [1,0,0];
        accessBool(i) = false;
    end
end

end

