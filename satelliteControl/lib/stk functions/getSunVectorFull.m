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
%       sunBool             List of Access Time Bools
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

% PRELIMINARY COMPUTATION
[sunTimes, sunVector] = getSunVector(scenario, satellite, dt);


%%% ACCESS VECTOR FULL AND BOOL
a = 1;
for i = 1:count
    if abs(timeVector(i) - sunTimes(a)) <= 0.05
        sunVectorFull(i,:) = sunVector(a,:);
        sunBool(i) = true;
        a = a + 1;
    else
        sunVectorFull(i,:) = [0,1,0];
        sunBool(i) = false;
    end
end


end

