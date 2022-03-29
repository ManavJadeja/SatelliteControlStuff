%  Position */Facility/Facility1 "26 Nov 2021 00:00:00.000"
disp('Getting ECFVectors')

% Use 'times' variable with time inputs
[rows, cols] = size(times);
pointingR = zeros(rows,cols,3);

for i = 1:rows
    for j = 1:cols
        % Command Strings
        commandF = char(['Position */Facility/RU_GS "', char(times(i,j)), '"']);
        commandS = char(['Position */Satellite/SPICESat "', char(times(i,j)), '"']);
    
        % Command Output
        F = strsplit(root.ExecuteCommand(commandF).Item(0));
        S = strsplit(root.ExecuteCommand(commandS).Item(0));
    
        % Final Pointing Vector
        pointingR(i,j,:) = [
            str2double(F{1,4})-str2double(S{1,7}),...
            str2double(F{1,5})-str2double(S{1,8}),...
            str2double(F{1,6})-str2double(S{1,9}),...
        ];
    end
end

disp('ECFVectors Computed')
