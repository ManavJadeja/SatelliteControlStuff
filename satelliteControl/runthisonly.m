%%% PRELIMINARY STUFF
% ADDING TO PATH (TEMPORARY)
addpath(genpath('lib'));
addpath(genpath('res'));
addpath(genpath('src'));
addpath(genpath('tmp'));


%%% STK LAUNCH
uiApplication = actxserver('STK12.application');
uiApplication.Visible = 1;
root = uiApplication.Personality2;

disp("Started: STK")


%%% STK SETUP
%{
[scenario, timeVector, dt] = scenarioInfo(root, scenName, scenStartTime, scenStopTime, dt);
[facility, fSensor] = facilityInfo(root, fName, fLocation, fColor, fsName, fsCHA, fsRmin, fsRmax)
%}
% SCENARIO
[scenario, timeVector, dt] = scenarioInfo(root, 'solid',...
    '24 Dec 2021 01:30:00.000', '24 Dec 2021 04:00:00.000', 0.1);

% FACILITY AND FACILITY SENSOR
[facility1, fSensor1] = facilityInfo(root, 'rugs', [40.5215 -74.4618 0], [0 255 255],...
    'rugsSensor', 90, 0, 1500);
[facility2, fSensor2] = facilityInfo(root, 'asugs', [33.4242 -111.9280 0], [255 255 0],...
    'asugsSensor', 90, 0, 2500);

facilityArray = [facility1, facility2];
fSensorArray = [fSensor1, fSensor2];

% SATELLITE AND SATELLITE SENSOR
[satellite, sSensor] = satelliteInfo(root, 'SPICESat', 6371+350, 0, 45, 0, 0, 0,...
    [255 0 0], 'C:\Program Files\AGI\STK 12\STKData\VO\Models\Space\cubesat_3u.dae',...
    'sSensor', 1, 0, 1500);

% COMPUTE ACCESS
for a = 1:length(facilityArray)
    % NEED TO AVOID MAKING IT LIKE THIS BUT HONESTLY IDK HOW TO
    accessArray(a) = satellite.GetAccessToObject(fSensorArray(a));
    accessArray(a).ComputeAccess();
end

disp('Computed: Access')

% FINALIZE AND RESET ANIMATION PERIOD
root.Rewind;


%%% PRELIMINARY COMPUTATION
% TIME
time = 0:dt:dt*(length(timeVector)-1);
t = 1:length(timeVector);


%%% SATELLITE MODEL
% CREATE MODEL (MATLAB)
satelliteModel = createSatelliteModel(root, scenario, satellite, facilityArray, accessArray, timeVector, dt);
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


