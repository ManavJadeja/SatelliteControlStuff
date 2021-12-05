%%% CREATING ATTITUDE FILE
disp('Creating Attitude File')

% Open File
fid = fopen('scriptedAttitude.a', 'wt');

% Variables needed for this one
start = 'Today';
[rows, cols] = size(times);

%%% PRELIMINARY INFORMATION
% See sample .a file on AGI help site for formatting this stuff
fprintf(fid, 'stk.v.12.2\n');
fprintf(fid, 'BEGIN Attitude\n');
fprintf(fid, 'NumberOfAttitudePoints %f\n', rows*cols); % L is number of data points
fprintf(fid, 'ScenarioEpoch %s\n', start); % start is starting time
fprintf(fid, 'BlockingFactor 20\n');
fprintf(fid, 'InterpolationOrder 0\n');
fprintf(fid, 'CentralBody Earth\n');
fprintf(fid, 'CoorinateAxes Fixed\n');
fprintf(fid, 'TimeFormat UTCG\n');
fprintf(fid, 'AttitudeTimeECFVector\n');
fprintf(fid, '\n');

% Add relevant data
for i = 1:rows
    for j = 1:cols
        pointingR_i = pointingR(i, j, 1:3);
        fprintf( fid, '%s %f %f %f\n', datestr(times(i,j), 'dd mmm yyyy HH:MM:SS.FFF'), pointingR_i(1), pointingR_i(2), pointingR_i(3));
    end
end

fprintf(fid, 'END Attitude\n');

% Close file
fclose(fid);

disp('Attitude File Created')