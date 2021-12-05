function [dX] = dynRotCon(t, X, I, qd, K, dt)
%%% DYNAMICS WITH ROTATION AND CONTROL

% Setup
q = X(1:4);
w = X(5:7);

% Thruster Torques
M = quatCM(q, qd(:, floor(t/dt)), w, K);

% Kinematics Equations
dq = -qp([0;w],q)/2;

% Euler Kinematic Equations
dw = I\(-1*cpm(w)*I*w + M);

% Final dX Matrix
dX = [dq; dw];

end