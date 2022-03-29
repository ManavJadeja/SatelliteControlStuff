function [q] = v2q(r, p)
%%% v2q
%       Convert rotation between two vectors to a quaternion
%
%   INPUTS:
%       r               Vector Start) Only a single, starting vector!
%                           Format: (double: 1x3)
%       p               Vector Final) Can be multiple vectors (double: nx3)
%                           Format: (double: 1x3)
%
%   OUTPUTS:
%       q               Quaternion Output 
%                           Format: <qs, qx, qy, qz>
%


%%% SETUP
q = zeros(size(r,1), 4);

% P UNIT VECTOR
pmag = sqrt( p(1)^2 + p(2)^2 + p(3)^2 );
p = p./pmag;


%%% LOOP THROUGH R
for i = 1:size(r,1)
    % R UNIT VECTOR
    rmag = sqrt( r(i,1)^2 + r(i,2)^2 + r(i,3)^2 );
    r = r./rmag;
    
    % DOT PRODUCT
    rDp = r(i,1)*p(1) + r(i,2)*p(2) + r(i,3)*p(3);
    
    % CROSS PRODUCT
    rCp = [
        r(i,2)*p(3) - r(i,3)*p(2);
        r(i,3)*p(1) - r(i,1)*p(3);
        r(i,1)*p(2) - r(i,2)*p(1);
    ];

    % HALF ANGLE
    half_theta = 0.5*acos(rDp);

    % QUATERNION
    q(i,:) = [
        cos(half_theta),...
        rCp(1)*sin(half_theta),...
        rCp(2)*sin(half_theta),...
        rCp(3)*sin(half_theta),...
    ];
end

end
