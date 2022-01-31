disp('Start')

fid = fopen('test.txt', 'wt');
fprintf(fid, 'stk.v.12.2\n');
fprintf(fid, 'BEGIN Attitude\n');
fprintf(fid, 'NumberOfAttitudePoints %f\n', 1);
fprintf(fid, 'ScenarioEpoch %s\n', 1);
fprintf(fid, 'BlockingFactor 20\n');
fprintf(fid, 'InterpolationOrder 0\n');
fprintf(fid, 'CentralBody Earth\n');
fprintf(fid, 'CoordinateAxes Fixed\n');
fprintf(fid, 'TimeFormat UTCG\n');
fprintf(fid, 'AttitudeTimeQuaternions\n');
    % Format: <qx, qy, qz, qs>
fprintf(fid, '\n');
fclose(fid);

tic
writematrix([datestr(timeVector(:)), num2str(cube.stateS(:,1:7), '%.4f')],...
    'test.txt', 'Delimiter', 'space', 'QuoteStrings', false, 'WriteMode', 'append')
toc

fid = fopen('test.txt', 'a+');
fprintf(fid, 'END Attitude\n');
fclose(fid);

file1 = 'test.txt';
file2 = strrep(file1,'.txt','.a');
copyfile(file1,file2)
delete('test.txt')

disp('Done')