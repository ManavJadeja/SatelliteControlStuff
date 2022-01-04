function [quaternionSimulated] = controlSimulation(timeVector, desiredQuaternion, interval)
%%% NAME: controlSimulation
%       Comes from 'Control System Simulation'
%   INPUTS:
%       timeVector              Scenario Time Vector
%       desiredQuaternion       Desired Quaternions
%       interval                Time Step
%
%   OUTPUTS:
%       quaternionSimulated     Quaternions from Simulation
%
%   PROCESS:
%       1) Setup initial conditions for dynamics and control theory
%       2) Create time vector for scenario analysis period
%       3) Iterate through times and add desired quaternions
%       4) Create cube object and add relevant data
%       5) Simulate cube and return simulated quaternions
%

disp('Starting Simulation')

%%% INITIAL CONDITIONS
q0 = [1,0,0,0];           % Initial Quaternions
w0 = [0,0,0];           % Initial Angular Velocity
state0 = [q0,w0];       % Initial State (vector)

% Control Gains
K = [5,1];

% Length of File
count = length(timeVector);


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
cube = block(state0, desiredQuaternion, K, @dynRotCon, 1:interval:(count+9)*interval, vertices, faces, inertia, color);
[tFull,quaternionSimulated] = cube.simulate();         %#ok<ASGLU>
%%%%% cube.animate(); %%%%% DON'T DO THIS, IT WILL TAKE FOREVER TO ANIMATE

disp('Simulation Done')
end