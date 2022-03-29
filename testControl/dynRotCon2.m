function [dX] = dynRotCon2(dt, X, qd, I, K)

% Setup
q = X(1:4);
w = X(5:7)';

% Thruster Torques
Tc = quatETc(q, qd, w, K);

% Kinematics Equations
dq = -qp([0;w],q)/2;

% Euler Kinematic Equations
dw = I\(-1*cpm(w)*I*w + Tc);

% Final dX Matrix
dX = [dq', dw'];
end

