function [q] = e2q(e)
%%% EULER ANGLES TO QUATERNIONS
%   e(1) - Yaw
%   e(2) - Pitch
%   e(3) - Roll

% Trajectory of Euler Angles
[rows, cols] = size(e);
q = zeros(4,cols);

% Get all them quaternions
if rows == 3
    for i = 1:cols
        q(:,i) = [
            cos(e(3,i)/2).*cos(e(2,i)/2).*cos(e(1,i)/2) + sin(e(3,i)/2).*sin(e(2,i)/2).*sin(e(1,i)/2);
            sin(e(3,i)/2).*cos(e(2,i)/2).*cos(e(1,i)/2) - cos(e(3,i)/2).*sin(e(2,i)/2).*sin(e(1,i)/2);
            cos(e(3,i)/2).*sin(e(2,i)/2).*cos(e(1,i)/2) + sin(e(3,i)/2).*cos(e(2,i)/2).*sin(e(1,i)/2);
            cos(e(3,i)/2).*cos(e(2,i)/2).*sin(e(1,i)/2) - sin(e(3,i)/2).*sin(e(2,i)/2).*cos(e(1,i)/2);
        ];
    end
end

end