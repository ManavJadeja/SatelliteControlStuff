function [q] = aa2q(axis, angle)
%%% AXIS-ANGLE TO QUATERNION

rows = length(angle);
q = zeros(rows, 4);

for i = 1:rows
    q(i,:) = [
        axis(i,1)*sind(angle(i)/2);
        axis(i,2)*sind(angle(i)/2);
        axis(i,3)*sind(angle(i)/2);
        cosd(angle(i)/2);
    ];
end

end
