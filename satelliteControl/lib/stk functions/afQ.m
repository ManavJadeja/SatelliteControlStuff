function [] = afQ(scenario, timeVector, quaternions, angularVelocities)
%%% afQ
%       Creates a quaternion attitude file from given information
%
%   INPUTS:
%       scenario                Scenario (object)
%       timeVector              Time Vector (datetime: n x 1 vector)
%                                   Format: 'dd MMM yyyy HH:mm:ss.S'
%       quaternion              Quaternions (double: n x 4 matrix)
%                                   Format: <qs, qx, qy, qz>
%       angularVelocities       Angular Velocities (double: n x 3 matrix)
%                                   Format: <wx, wy, wz>
%
%   OUTPUTS:
%       attitudeQ.a             Quaternion Attitude File in ECF Frame
%                                   File created in /tmp/attitudeQ.a
%

%%% OPEN FILE
count = length(timeVector);
fid = fopen('tmp\attitudeQ.txt', 'wt');


%%% PRELIMINARY INFORMATION
% See sample .a file on AGI help site for formatting this stuff
fprintf(fid, 'stk.v.12.2\n');
fprintf(fid, 'BEGIN Attitude\n');
fprintf(fid, 'NumberOfAttitudePoints %f\n', count);
fprintf(fid, 'ScenarioEpoch %s\n', scenario.StartTime);
fprintf(fid, 'BlockingFactor 20\n');
fprintf(fid, 'InterpolationOrder 1\n');
fprintf(fid, 'CentralBody Earth\n');
fprintf(fid, 'CoordinateAxes Fixed\n');
fprintf(fid, 'TimeFormat UTCG\n');
fprintf(fid, 'AttitudeTimeQuatAngVels\n');
    % Format: <qx, qy, qz, qs, wx, wy, wz>
fprintf(fid, '\n');
fclose(fid);


%%% ADD QUATERNION AND ANGULAR VELOCITY DATA
writematrix([datestr(timeVector(:), 'dd mmm yyyy HH:MM:SS.FFF'), repmat(' ',[count 1]),...
    num2str(quaternions(:,2), '%+.6e'), repmat(' ',[count 1]),...           % qx
    num2str(quaternions(:,3), '%+.6e'), repmat(' ',[count 1]),...           % qy
    num2str(quaternions(:,4), '%+.6e'), repmat(' ',[count 1]),...           % qz
    num2str(quaternions(:,1), '%+.6e'), repmat(' ',[count 1]),...           % qw
    num2str(angularVelocities(:,1), '%+.6e'), repmat(' ',[count 1]),...     % wx
    num2str(angularVelocities(:,2), '%+.6e'), repmat(' ',[count 1]),...     % wy
    num2str(angularVelocities(:,3), '%+.6e'), repmat(' ',[count 1]),...     % wz
    ],...
    'tmp\attitudeQ.txt', 'Delimiter', 'space', 'QuoteStrings', false, 'WriteMode', 'append')


%%% FINAL EDITS AND CLOSE FILE
fid = fopen('tmp\attitudeQ.txt', 'a+');
fprintf(fid, 'END Attitude\n');
fclose(fid);


%%% ADD .a EXTENSION
file1 = 'tmp\attitudeQ.txt';
file2 = strrep(file1,'.txt','.a');
copyfile(file1,file2)
delete('tmp\attitudeQ.txt')

disp('Attitude File Created')


end

