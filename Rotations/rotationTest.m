%%% STARTING STUFF > idk what matlabrc does~
matlabrc; clc; close all;


%%% SIMULATION INFORMATION
% Defining time
dt = 1/30;
duration = 10;
tspan = dt:dt:duration;
L = length(tspan);


%%% OBJECT INFORMATION
% Initial State
% w0 = randn(3,1);
w0 = [0;0;0];   
q0 = [0;0;0;1];
rotation0 = [q0; w0];

% Object Properties
mass = 1;
inertia = diag([1 1 1/3]);
vertices = [-1 -1  -1;
            -1  1 -1;
            1   1  -1;
            1  -1  -1;
            -1 -1  1;
            -1  1 1;
            1   1  1;
            1  -1  1]; % I copied this from Chris's code
faces = [1 2 6 5;
         2 3 7 6;
         3 4 8 7;
         4 1 5 8;
         1 2 3 4;
         5 6 7 8]; % I copied this from Chris's code
color = [0 0.5 0]; % Should be green

% Creating object with shape.m class
satellite = shapeR(vertices, faces, mass, inertia, color, 0);


%%% SOLVING STUFF
options = odeset('RelTol', 1e-9, 'AbsTol', 1e-9*ones(1,7));
[t,q] = ode45(@(t,X) wheelRDynamics(t,X,inertia), tspan, rotation0, options);


%%% MAKING ANIMATION
% Plot limits and camera angles
xlabel("X")
ylabel("Y")
zlabel("Z")
xlim([-5 5])
ylim([-5 5])
zlim([-5 5])
view(45,20)


% Actual Animation
for i = 1:L
    q_i = q(i, 1:4);
    rotmat = q2a(q_i);
    satellite.updateAttitude(rotmat)
    title(i)
    drawnow
    pause(1/30)
end

