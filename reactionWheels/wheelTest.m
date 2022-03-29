disp('START')

% TIME STUFF
dt = 0.01;
t = 0:dt:25;

% TIMW VECTOR
startTime = datetime('24 Dec 2021 01:30:00.000', 'InputFormat', 'dd MMM yyyy HH:mm:ss.SSS', 'Format', 'dd MMM yyyy HH:mm:ss.S');
stopTime = startTime + seconds(25);
timeVector = (startTime:seconds(dt):stopTime)';

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

inertiaS = diag(2.2e-3*[1 1 1]);
inertiaW = diag(5.6e-6*[1 1 1]);
state0W = [0,0,0];

% CREATE OBJECTS
wheel = reactionWheel(state0W, inertiaW, 1);
cube = satellite(state0, qd, K, inertiaS, t, dt, wheel, vertices, faces, color);

% SIMULATE AND ANIMATE
tic
cube.simulate();
toc
cube.animate();

% PLOT DATA
seeData

disp('DONE')
