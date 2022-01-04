function [q] = v2q(r, p)
%V2Q
%   Convert a position vector to a quaternion
%   I copied something off stackoverflow and I think I messed up


% Create unit vectors
rmag = sqrt( r(1)^2 + r(2)^2 + r(3)^2 );
r = r/rmag;

pmag = sqrt( p(1)^2 + p(2)^2 + p(3)^2 );
p = p/pmag;

% Compute cross product and dot product
rDp = r(1)*p(1) + r(2)*p(2) + r(3)*p(3);
rCp = [
    r(2)*p(3) - r(3)*p(2);
    r(3)*p(1) - r(1)*p(3);
    r(1)*p(2) - r(2)*p(1);
];
theta = acos(rDp);

% Make quaternion!
q = [
    cos(theta/2);
    rCp(1)*sin(theta/2);
    rCp(2)*sin(theta/2);
    rCp(3)*sin(theta/2);
];

end
