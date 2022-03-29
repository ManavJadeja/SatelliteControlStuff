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
[satellite, sSensor] = satelliteInfo(root, sName, sSMA, sE, sI, sAP, sAN, sL, sColor, sModel, ssName, ssCHA, ssRmin, ssRmax)
%}
% SCENARIO
[scenario, timeVector, dt] = scenarioInfo(root, 'solid',...
    '24 Dec 2021 01:30:00.000', '24 Dec 2021 06:00:00.000', 0.01);

% FACILITY AND FACILITY SENSOR
[facility1, fSensor1] = facilityInfo(root, 'rugs', [40.5215 -74.4618 0], [255 0 0],...
    'rugsSensor',  60, 0, 1500, 25, 85);
[facility2, fSensor2] = facilityInfo(root, 'asugs', [33.4242 -111.9280 0], [255 255 0],...
    'asugsSensor', 60, 0, 1500, 25, 85);
[facility3, fSensor3] = facilityInfo(root, 'tamgs', [30.6190 -96.3387 0], [128 0 0],...
    'tamgsSensor', 60, 0, 1500, 25, 85);

facilityArray = [facility1, facility2, facility3];
fSensorArray = [fSensor1, fSensor2, fSensor3];

% SATELLITE AND SATELLITE SENSOR
[satellite, sSensor] = satelliteInfo(root, 'SPICESat', 6371+400, 0, 45, 0, 0, 0,...
    [255 0 0], 'C:\Program Files\AGI\STK 12\STKData\VO\Models\Space\cubesat_6u.dae',...
    'sSensor', 4, 0, 1500);

disp(['Added all STK Objects: ', num2str(toc), ' seconds'])

% COMPUTE ACCESS
tic
for a = 1:length(facilityArray)
    % NEED TO AVOID MAKING IT LIKE THIS BUT HONESTLY IDK HOW TO
    accessArray(a) = satellite.GetAccessToObject(fSensorArray(a));
    accessArray(a).ComputeAccess();
end
disp(['Computed: Access: ', num2str(toc), ' seconds'])

% FINALIZE AND RESET ANIMATION PERIOD
root.Rewind;


%%% SATELLITE MODEL
% CREATE MODEL (MATLAB)
tic
disp('Creating: Satellite Object in MATLAB')
satelliteModel = createSatelliteModel(root, scenario, satellite, facilityArray, accessArray, timeVector, dt);
disp(['Created: Satellite Object in MATLAB: ', num2str(toc), ' seconds'])


% SIMULATE SYSTEM DYNAMICS
disp('Simuating: Satellite System Dynamics')
tic
satelliteModel.simulate();
disp(['Simulated: Satellite System Dynamics: ', num2str(toc), ' seconds'])

% CREATE ATTITUDE FILE
tic
afQ(scenario, timeVector, satelliteModel.stateS(:,1:4), satelliteModel.stateS(:,5:7));
disp(['Created: Attitude File: ', num2str(toc), ' seconds'])

% LOAD ATTITUDE FILE
toAttitudeFile = [pwd, '\tmp\attitudeQ.a'];
satellite.Attitude.External.Load(toAttitudeFile);


disp('DONE')