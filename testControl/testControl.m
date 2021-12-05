disp('start')

%%% DEFINE PARAMETERS
% Time
t = 0:0.001:5;
tStep = 0.5;
% Position
x0 = 0;

%%% CONTROL STUFF
% Desired Position
xDesired = unitStep(t, tStep);
% Controller
xActual1 = controller(t, x0, xDesired, 1, 0, 0);
xActual2 = controller(t, x0, xDesired, 1, 1, 0);
xActual3 = controller(t, x0, xDesired, 1, 1, 1);

%%% OUTPUT
plot(t, xDesired)
hold on
plot(t, xActual1)
plot(t, xActual2)
plot(t, xActual3)



disp('done')