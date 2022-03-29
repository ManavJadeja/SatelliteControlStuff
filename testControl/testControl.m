disp('START')

%%% SIMULATION PARAMETERS
% TIME STUFF
dt = 0.1;
t = 0:dt:25;

% INITIAL CONDITIONS
e0 = [0,0,0];
q0 = e2q(e0);
w0 = [0,0,0];
state0 = [q0,w0];
% DESIRED PATH
ed = [
    (pi/2).*unitStep(t,5);
    (pi/2).*unitStep(t,10);
    (pi/2).*unitStep(t,15);
]';
qd = e2q(ed);

% CONTROL GAINS
K = [1,1];


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
color = [0 0.5 0];     % Green

inertia = diag([1 1 1]);

cube = block(state0, qd, K, @dynRotCon, t, dt, vertices, faces, inertia, color);
[t,q1] = cube.simulate1();
q2 = cube.simulate2();

animate(q1, cube)
animate(q2', cube)

disp('DONE')