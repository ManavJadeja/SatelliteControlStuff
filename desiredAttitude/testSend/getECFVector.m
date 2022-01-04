function [pointingR] = getECFVector(root, times)
%GETECFVECTOR
%   Obtains the vector connecting two objects (facility and satellite)
%   Uses two connect commands to get both vectors
%   Vectors are position vectors relative to Earth Central Fixed Frame
%   Takes the difference of them (to get the relative position vector)

% Use 'times' variable with time inputs
rows = size(times, 1);
pointingR = zeros(rows,3);

% Get Facility Position Vector
commandF = char(['Position */Facility/RU_GS "', char(times(1)), '"']);
F = strsplit(root.ExecuteCommand(commandF).Item(0));

for i = 1:rows
    % Get Satellite Position Vector
    commandS = char(['Position */Satellite/SPICESat "', char(times(i)), '"']);
    S = strsplit(root.ExecuteCommand(commandS).Item(0));
    
    % Final Pointing Vector
    pointingR(i,:) = [
        str2double(F{1,4})-str2double(S{1,7}),...
        str2double(F{1,5})-str2double(S{1,8}),...
        str2double(F{1,6})-str2double(S{1,9}),...
    ];
end

end

