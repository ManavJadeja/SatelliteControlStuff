%%% PRELIMINARY STUFF
tic
% ADDING TO PATH (TEMPORARY)
addpath(genpath('lib'));
addpath(genpath('res'));
addpath(genpath('src'));
addpath(genpath('tmp'));


%%% STK LAUNCH
uiApplication = actxserver('STK12.application');
uiApplication.Visible = 1;
root = uiApplication.Personality2;

disp("Started: Systems Tool Kit")


%%% STK SETUP
%{
[scenario, timeVector, dt] = scenarioInfo(root, scenName, scenStartTime, scenStopTime, dt);
[facility, fSensor] = facilityInfo(root, fName, fLocation, fColor, fsName, fsCHA, fsRmin, fsRmax)
%}
% SCENARIO
[scenario, timeVector, dt] = scenarioInfo(root, 'solid',...
    '24 Dec 2021 01:30:00.000', '24 Dec 2021 03:30:00.000', 0.01);

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

toc
disp('Added all STK Objects')

% COMPUTE ACCESS
tic
for a = 1:length(facilityArray)
    % NEED TO AVOID MAKING IT LIKE THIS BUT HONESTLY IDK HOW TO
    accessArray(a) = satellite.GetAccessToObject(fSensorArray(a));
    accessArray(a).ComputeAccess();
end
toc
disp('Computed: Access')

% FINALIZE AND RESET ANIMATION PERIOD
root.Rewind;

%%% PRELIMINARY COMPUTATION
%tic
% TIME
%time = 0:dt:dt*(length(timeVector)-1);
%t = 1:length(timeVector);
%toc
disp('Created: Time Vector')


%%% SATELLITE MODEL
% CREATE MODEL (MATLAB)
tic
satelliteModel = createSatelliteModel(root, scenario, satellite, facilityArray, accessArray, timeVector, dt);
toc
disp('Created: Satellite Object in MATLAB')

% SIMULATE SYSTEM DYNAMICS
disp('Simuating: Satellite System Dynamics')
tic
satelliteModel.simulate();
toc
disp('Simulated: Satellite System Dynamics')

% CREATE ATTITUDE FILE
tic
afQ(scenario, timeVector, satelliteModel.stateS(:,1:4), satelliteModel.stateS(:,5:7));
disp('Created: Attitude File')
toc
% LOAD ATTITUDE FILE
toAttitudeFile = [pwd, '\tmp\attitudeQ.a'];
satellite.Attitude.External.Load(toAttitudeFile);


