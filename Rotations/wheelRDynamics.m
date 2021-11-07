function [dX] = wheelRDynamics(t,X,I)
    % Initiate variables
    q = X(1:4);
    w = X(5:7);
    
    % Thruster forces (time dependent) here
    % [M] = thrust(t, t_start, t_stop, force, distance, direction);
    M1 = wheelR(t, 1, 2, 5, 1, [0, 0, 1]);       % Burn 1
    M2 = wheelR(t, 3, 4, 5, 1, [0, 0, -1]);      % Burn 2
    M3 = wheelR(t, 5, 6, 5, 1, [0, 0, -1]);      % Burn 3
    M4 = wheelR(t, 7, 8, 5, 1, [0, 0, 1]);       % Burn 4
    
    % Sum of the moments (time dependent and preplanned here)
    M = M1+M2+M3+M4;
    
    % Euler rotation equations here
    dw = I\(-1*cpm(w)*I*w) + M;
    
    % Quaternion kinematics here
    Bq = zeros(4,3);
    Bq(1:3,:) = cpm(q(1:3)) + diag([q(4), q(4), q(4)]);
    Bq(4,:) = -q(1:3);
    dq = (1/2)*Bq*w;
    
    % Return dX here
    dX = [dq; dw];
end
