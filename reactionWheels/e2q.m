function [q] = e2q(e)
%%% EULER ANGLES TO QUATERNIONS
%   e(1) - Yaw
%   e(2) - Pitch
%   e(3) - Roll

% Trajectory of Euler Angles
[rows, cols] = size(e);
q = zeros(rows, 4);

% Get all them quaternions
if cols == 3
    for i = 1:rows
        q(i,:) = [
            cos(e(i,3)/2).*cos(e(i,2)/2).*cos(e(i,1)/2) + sin(e(i,3)/2).*sin(e(i,2)/2).*sin(e(i,1)/2);
            sin(e(i,3)/2).*cos(e(i,2)/2).*cos(e(i,1)/2) - cos(e(i,3)/2).*sin(e(i,2)/2).*sin(e(i,1)/2);
            cos(e(i,3)/2).*sin(e(i,2)/2).*cos(e(i,1)/2) + sin(e(i,3)/2).*cos(e(i,2)/2).*sin(e(i,1)/2);
            cos(e(i,3)/2).*cos(e(i,2)/2).*sin(e(i,1)/2) - sin(e(i,3)/2).*sin(e(i,2)/2).*cos(e(i,1)/2);
        ];
    end
end

end