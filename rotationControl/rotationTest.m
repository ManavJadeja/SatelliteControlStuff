disp('Start')

%%% SIMULATION INFORMATION
% Time Stuff
dt = 1/100;              % 10 ms time-step
t = dt:dt:25;            % 25 second simulation

% Initial Conditions
e0 = [0;0;0];           % Initial Euler Angles (yaw, pitch, roll convention)
q0 = e2q(e0);           % Initial Quaternions
w0 = [0;0;0];           % Initial Angular Velocity
state0 = [q0;w0];       % Initial State (vector)

% Desired Path and Control Gains
ed = [
    (pi/2).*unitStep(t,5);
    (pi/2).*unitStep(t,10);
    (pi/2).*unitStep(t,15);
];
qd = e2q(ed);
K = [1;1];

%%% CREATE CUBE
% Block properties
vertices = [
    -1 -1  -1;
    -1  1 -1;
    1   1  -1;
    1  -1  -1;
    -1 -1  1;
    -1  1 1;
    1   1  1;
    1  -1  1
];                      % I copied this
faces = [
    1 2 6 5;
    2 3 7 6;
    3 4 8 7;
    4 1 5 8;
    1 2 3 4;
    5 6 7 8
];                      % I copied this
color = [0 0.5 0];      % Green
inertia = diag([1 1 1]);

% Create cube
cube = block(state0, qd, K, @dynRotCon, t, dt, vertices, faces, inertia, color);
[t,q] = cube.simulate();
cube.animate();



disp('Done')