%%% CREATING ATTITUDE FILE
fid = fopen('scriptedAttitude.a', 'wt');

% Variables needed for this one
start = 'Today';
t = accessStartTimes;
[rows, cols] = size(t);

%%% PRELIMINARY INFORMATION
% See sample .a file on AGI help site for formatting this stuff
fprintf(fid, 'stk.v.12.2\n');
fprintf(fid, 'BEGIN Attitude\n');
fprintf(fid, 'NumberOfAttitudePoints %f\n', rows); % L is number of data points
fprintf(fid, 'ScenarioEpoch %s\n', start); % start is starting time
fprintf(fid, 'BlockingFactor 20\n');
fprintf(fid, 'InterpolationOrder 1\n');
fprintf(fid, 'CentralBody Earth\n');
fprintf(fid, 'CoorinateAxes Fixed\n');
fprintf(fid, 'TimeFormat UTCG\n');
fprintf(fid, 'AttitudeTimeECFVector\n');


for i = 1:rows
    b2a_i = b2a(i, 1:3);
    fprintf( fid, '%s %f %f %f\n', convertCharsToStrings(t(i,:)), b2a_i(1), b2a_i(2), b2a_i(3));
end

fprintf(fid, 'END Attitude\n');

fclose(fid);