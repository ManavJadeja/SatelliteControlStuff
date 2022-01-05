%%% PRELIMINARY STUFF
% ADDING TO PATH (TEMPORARY)
addpath(genpath('lib'));
addpath(genpath('src'));
addpath(genpath('tmp'));


%%% STK LAUNCH
uiApplication = actxserver('STK12.application');
uiApplication.Visible = 1;
root = uiApplication.Personality2;

disp("Started: STK")


%%% STK SETUP
% SCENARIO
[scenario, timeVector, dt] = scenarioInfo(root);

% FACILITY AND FACILITY SENSOR
[facility, fSensor] = facilityInfo(root);

% SATELLITE AND SATELLITE SENSOR
[satellite, sSensor] = satelliteInfo(root);

% FINALIZE AND RESET ANIMATION PERIOD
root.Rewind;


%%% STK COMPUTATION
% Compute Access (satellite > facility sensor)
access = satellite.GetAccessToObject(fSensor);
access.ComputeAccess();

disp('Access Computed')


%%% PRELIMINARY COMPUTATION
time = 0:dt:dt*(length(timeVector)-1);
t = 1:length(timeVector);

%%% SATELLITE MODEL
%{
obj = battery(capacity, socI, R_charge, R_discharge,...
                maxV, maxI, cells, lineDrop);
obj = solarArray(area, normalVector, efficiency)
obj = powerSystem(time, battery, solarArray, sunVector)

obj  = attitudeSystem(time, stateI, I, K,...
                magnetorquer, magneticField)

obj = commandSystem(socSafe, socUnsafe)

obj = satelliteModel(time, dt, powerSystem, attitudeSystem, commandSystem)


% POWER SYSTEM
battery = battery();
solarArray = solarArray();
powerSystem = powerSystem();

% ATTITUDE SYSTEM
attitudeSystem = attitudeSystem();

% COMMAND SYSTEM
commandSystem = commandSystem();

% FINAL SATELLITE MODEL
satelliteModel = satelliteModel();
%}


