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
scenario = root.Children.New('eScenario','test2');

% Scenario time properties
scenario.SetTimePeriod('Today','+72 hours')
scenario.StartTime = 'Today';
scenario.StopTime = '+72 hours';
disp("Scenario Created")


%%% FACILITY PROPERTIES
% Add facility object
facility = root.CurrentScenario.Children.New('eFacility', 'RU_GS');

% Modify facility properties
% Rutgers Ground Station Coordinates
lat = 40.5215;          % Latitude (deg)
lon = -74.4618;         % Longitude (deg)
alt = 0.05;             % Altitude (km)

% Position and color
facility.Position.AssignGeodetic(lat, lon, alt) % Latitude, Longitude, Altitude
facility.Graphics.Color = rgb2StkColor([255 255 255]);

disp("Facility Created")


%%% SENSOR PROPERTIES
% Add sensor object to satellite
sensor = facility.Children.New('eSensor', 'Sensor');

% Modify sensor properties
sensor.CommonTasks.SetPatternSimpleConic(90, 1);

% Add range constraint
range = sensor.AccessConstraints.AddConstraint('eCstrRange');
range.EnableMin = true;
range.EnableMax = true;
range.min = 0;
range.max = 1000;

% Graphics Stuff
sensor.Graphics.Projection.UseConstraints = true;
sensor.Graphics.Projection.UseDistance = true;

disp("Sensor Created")


%%% SATELLITE PROPERTIES
% Add satellite object
satellite = root.CurrentScenario.Children.New('eSatellite', 'SPICESat');

% Modify satellite properties
keplerian = satellite.Propagator.InitialState.Representation.ConvertTo('eOrbitStateClassical'); % Use the Classical Element interface
keplerian.SizeShapeType = 'eSizeShapeSemimajorAxis';  % Uses Eccentricity and Inclination
keplerian.LocationType = 'eLocationTrueAnomaly'; % Makes sure True Anomaly is being used
keplerian.Orientation.AscNodeType = 'eAscNodeRAAN'; % Use RAAN for data entry

% Assign the perigee and apogee altitude values:
keplerian.SizeShape.SemimajorAxis = 6371+400;
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


%%% ANIMATION AND GRPAHICS SETTINGS
% Reset animation period (because its necessary)
% Connect Command > root.ExecuteCommand('Animate * Reset')
root.Rewind;


%%% DONE
disp("DONE")
