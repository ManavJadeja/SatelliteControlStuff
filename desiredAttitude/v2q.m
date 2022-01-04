function [q] = v2q(r, p)
%V2Q
%   Convert a position vector to a quaternion
%   I copied something off stackoverflow and I think I messed up


% Create unit vectors
pmag = sqrt( p(1)^2 + p(2)^2 + p(3)^2 );
p = p/pmag;

q = zeros(size(r,1), 4);

% Compute cross product and dot product
for i = 1:size(r,1)
    rmag = sqrt( r(i,1)^2 + r(i,2)^2 + r(i,3)^2 );
    r = r./rmag;
    
    rDp = r(i,1)*p(1) + r(i,2)*p(2) + r(i,3)*p(3);
    rCp = [
        r(i,2)*p(3) - r(i,3)*p(2);
        r(i,3)*p(1) - r(i,1)*p(3);
        r(i,1)*p(2) - r(i,2)*p(1);
    ];
    theta = acos(rDp);

    % Make quaternion!
    q(i,:) = [
        cos(theta/2);
        rCp(1)*sin(theta/2);
        rCp(2)*sin(theta/2);
        rCp(3)*sin(theta/2);
    ];
end

end
