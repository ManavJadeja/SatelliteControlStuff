%%% PRELIMINARY STUFF
% clear; clc


%%% LAUNCHING STK
%Create an instance of STK
uiApplication = actxserver('STK12.application');
uiApplication.Visible = 1;

%Get our IAgStkObjectRoot interface
root = uiApplication.Personality2;
disp("Started STK")


%%% SCENARIO SETTINGS
% Create a new scenario 
scenario = root.Children.New('eScenario','solid');

% Scenario time properties

scenarioStartTime = '24 Dec 2021 00:00:00.000';
scenarioStopTime = '24 Dec 2021 07:00:00.000';

scenario.SetTimePeriod(scenarioStartTime, scenarioStopTime)
scenario.StartTime = scenarioStartTime;
scenario.StopTime = scenarioStopTime;
disp("Scenario Created")


%%% FACILITY PROPERTIES
% Add facility object
facility = root.CurrentScenario.Children.New('eFacility', 'RU_GS');

% Modify facility properties
% Rutgers Ground Station Coordinates
facility.Position.AssignGeodetic(40.5215, -74.4618, 0.05) % Latitude (deg), Longitude (deg), Altitude (km)
facility.Graphics.Color = rgb2StkColor([255 255 255]);

disp("Facility Created")


%%% FACILITY SENSOR PROPERTIES
% Add sensor object to satellite
sensor = facility.Children.New('eSensor', 'Sensor');

% Modify sensor properties
sensor.CommonTasks.SetPatternSimpleConic(90, 1);

% Add range constraint
range = sensor.AccessConstraints.AddConstraint('eCstrRange');
range.EnableMin = true;
range.EnableMax = true;
range.min = 0;
range.max = 1500;

% Graphics Stuff
sensor.Graphics.Projection.UseConstraints = true;
sensor.Graphics.Projection.UseDistance = true;

disp("Facility Sensor Created")


%%% SATELLITE PROPERTIES
% Add satellite object
satellite = root.CurrentScenario.Children.New('eSatellite', 'SPICESat');

% Modify satellite properties
keplerian = satellite.Propagator.InitialState.Representation.ConvertTo('eOrbitStateClassical'); % Use the Classical Element interface
keplerian.SizeShapeType = 'eSizeShapeSemimajorAxis';  % Uses Eccentricity and Inclination
keplerian.LocationType = 'eLocationTrueAnomaly'; % Makes sure True Anomaly is being used
keplerian.Orientation.AscNodeType = 'eAscNodeRAAN'; % Use RAAN for data entry

% Assign the perigee and apogee altitude values:
keplerian.SizeShape.SemimajorAxis = 6371+350;
keplerian.SizeShape.Eccentricity = 0;

% Assign the other desired orbital parameters:
keplerian.Orientation.Inclination = 45;         % deg
keplerian.Orientation.ArgOfPerigee = 0;         % deg
keplerian.Orientation.AscNode.Value = 0;        % deg
keplerian.Location.Value = 0;                   % deg



% Apply the changes made to the satellite's state and propagate:
satellite.Propagator.InitialState.Representation.Assign(keplerian);
satellite.Propagator.Propagate;
disp("Satellite Created")

% Satellite Model and Orbit Resolution
satellite.VO.Model.ModelData.Filename = 'C:\Program Files\AGI\STK 12\STKData\VO\Models\Space\cubesat_3u.dae';
satellite.Graphics.Resolution.Orbit = 60;

disp("Satellite Model Updated")


%%% SATELLITE SENSOR PROPERTIES
% Add sensor object to satellite
sensorS = satellite.Children.New('eSensor', 'sSensor');

% Modify sensor properties
sensorS.CommonTasks.SetPatternSimpleConic(5, 1);
commandS = 'Point */Satellite/SPICESat/Sensor/sSensor AlongVector "Satellite/SPICESat Body.X" "Satellite/SPICESat North" 0';
root.ExecuteCommand(commandS);

% Add range constraint
range = sensorS.AccessConstraints.AddConstraint('eCstrRange');
range.EnableMin = true;
range.EnableMax = true;
range.min = 0;
range.max = 1501;

% Graphics Stuff
sensorS.Graphics.Projection.UseConstraints = true;
sensorS.Graphics.Projection.UseDistance = true;
%}

disp("Satellite Sensor Created")


%%% GETACCESS > Get Access between two objects
disp('Getting Access')

% Compute access between objects (satellite > facility)
access = satellite.GetAccessToObject(sensor);
access.ComputeAccess();

% Interval for attitude stuff
interval = 0.1;

disp('Access Computed')


%%% ANIMATION AND GRPAHICS SETTINGS
% Reset animation period (because its necessary)
% Connect Command > root.ExecuteCommand('Animate * Reset')
root.Rewind;


%%% DONE
disp("DONE")
