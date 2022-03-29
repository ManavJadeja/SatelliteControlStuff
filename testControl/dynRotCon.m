function [dX] = dynRotCon(t, X, I, qd, K, dt)
%%% DYNAMICS WITH ROTATION AND CONTROL

% Setup
q = X(1:4);
w = X(5:7);

% Thruster Torques
Tc = quatETc(q, qd(floor(1+t/dt),:), w, K);

% Kinematics Equations
dq = -qp([0,w'],q)/2;

% Euler Kinematic Equations
dw = I\(-1*cpm(w)*I*w + Tc);

% Final dX Matrix
dX = [dq; dw];

end