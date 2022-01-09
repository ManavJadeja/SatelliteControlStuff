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
satelliteModel = createSatelliteModel(root, scenario, satellite, facility, access, timeVector, dt);
disp('Created: Satellite Object in MATLAB')

% SIMULATE SYSTEM DYNAMICS
disp('Simuating: Satellite System Dynamics')
satelliteModel.simulate();
disp('Simulation: Complete')

% CREATE ATTITUDE FILE
afQ(scenario, timeVector, satelliteModel.stateS(:,1:4));

% LOAD ATTITUDE FILE
toAttitudeFile = [pwd, '\tmp\attitudeQ.a'];
satellite.Attitude.External.Load(toAttitudeFile);

