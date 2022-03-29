%  Position */Facility/Facility1 "26 Nov 2021 00:00:00.000"
disp('Getting ECFVectors')

accessStartTimes = cell2mat(accessDP.DataSets.GetDataSetByName('Start Time').GetValues);
[rows, cols] = size(accessStartTimes);
b2a = zeros(rows,3);

for i=1:rows
    % Command Strings
    commandF = char(['Position */Facility/RU_GS "', char(accessStartTimes(i,:)), '"']);
    commandS = char(['Position */Satellite/SPICESat "', char(accessStartTimes(i,:)), '"']);
    %disp(['Start Time Count ', int2str(i)])
    %disp(commandF)
    %disp(commandS)
    
    % Command Output
    F = strsplit(root.ExecuteCommand(commandF).Item(0));
    S = strsplit(root.ExecuteCommand(commandS).Item(0));
    
    % Parsing Ouput to get ECF (Earth Center Frame) Vector
    %disp('a')
    %disp([a{1,4}, ' ', a{1,5}, ' ', a{1,6}])
    %disp('b')
    %disp([b{1,13}, ' ', b{1,14}, ' ', b{1,15}])
    
    % Final Pointing Vector
    b2a(i,:) = [
        str2double(F{1,4})-str2double(S{1,7}),...
        str2double(F{1,5})-str2double(S{1,8}),...
        str2double(F{1,6})-str2double(S{1,9}),...
        ];
    %disp('b2a')
    %disp(b2a(i))
end

disp('ECFVectors Computed')
