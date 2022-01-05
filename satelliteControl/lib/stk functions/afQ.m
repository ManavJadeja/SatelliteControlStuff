function [] = afQ(quaternion, timeVector, scenarioStartTime)
%%% afQ
%       Creates a quaternion attitude file from given information
%
%   INPUTS:
%       quaternion              Quaternion Data (double: n x 4 matrix)
%                                   Format: <qs, qx, qy, qz>
%       timeVector              Time Vector (datetime: n x 1 vector)
%                                   Format: 'dd MMM yyyy HH:mm:ss.S'
%       scenarioStartTime       Scenario Start Time
%
%   OUTPUTS:
%       attitudeQ.a             Quaternion Attitude File in ECF Frame
%                                   File created in /tmp/attitudeQ.a
%

%%% OPEN FILE
count = length(timeVector);
fid = fopen('..\..\tmp\attitudeQ.a', 'wt');


%%% PRELIMINARY INFORMATION
% See sample .a file on AGI help site for formatting this stuff
fprintf(fid, 'stk.v.12.2\n');
fprintf(fid, 'BEGIN Attitude\n');
fprintf(fid, 'NumberOfAttitudePoints %f\n', count);
fprintf(fid, 'ScenarioEpoch %s\n', scenarioStartTime);
fprintf(fid, 'BlockingFactor 20\n');
fprintf(fid, 'InterpolationOrder 0\n');
fprintf(fid, 'CentralBody Earth\n');
fprintf(fid, 'CoordinateAxes Fixed\n');
fprintf(fid, 'TimeFormat UTCG\n');
fprintf(fid, 'AttitudeTimeQuaternions\n');
    % Format: <qx, qy, qz, qs>
fprintf(fid, '\n');


%%% ADD QUATERNION DATA    
for i = 1:count
    fprintf(fid, '%s %f %f %f %f\n', datestr(timeVector(i), 'dd mmm yyyy HH:MM:SS.FFF'),...
        quaternion(i,2), quaternion(i,3), quaternion(i,4), quaternion(i,1));
end
fprintf(fid, 'END Attitude');


%%% CLOSE FILE
fclose(fid);
disp('Attitude File Created')


end

