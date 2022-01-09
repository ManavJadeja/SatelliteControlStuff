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
% COMPUTE ACCESS (satellite > facility sensor)
access = satellite.GetAccessToObject(fSensor);
access.ComputeAccess();

disp('Access Computed')


%%% PRELIMINARY COMPUTATION
% TIME
time = 0:dt:dt*(length(timeVector)-1);
t = 1:length(timeVector);


%%% SATELLITE MODEL
% CREATE MODEL (MATLAB)
satelliteModel = createSatelliteModel(root, scenario, satellite, access, timeVector, dt);

% SIMULATE SYSTEM DYNAMICS
satelliteModel.simulate();

% CREATE ATTITUDE FILE
afQ(scenario, timeVector, satelliteModel.stateS(:,1:4));

% LOAD ATTITUDE FILE
toAttitudeFile = 'tmp\attitudeQ.a';
satellite.Attitude.External.Load(toAttitudeFile);


