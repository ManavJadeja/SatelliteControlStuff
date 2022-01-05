function [satellite, sSensor] = satelliteInfo(root)
%%% SATELLITE INFORMATION
%   Information for Satellite (object) in Systems Tool Kit
%       1) Input Parameters
%       2) Definitions derived from Parameters
%
%   PARAMETERS
%       sName                   Satellite Name (char array: name)
%       sSMA                    Semimajor Axis (double: km)
%       sE                      Eccentricity (double: unitless)
%       sI                      Angle of Inclination (double: deg)
%       sAP                     Argument of Perigee (double: deg)
%       sAN                     Ascending Node (double: deg)
%       sL                      Location in Orbit (double: deg)
%       sModel                  Satellite Model (char array: model path)
%
%       ssName                  Satellite Sensor Name (char array: name)
%       ssCHA                   Satellite Sensor Cone Half Angle
%                                   (double: degrees)
%       ssRmin                  Satellite Sensor Range Min (double: km)
%       ssRmax                  Satellite Sensor Range Max (double: km)
%
%   DEFINITIONS
%       satellite               Satellite (object)
%       sSensor                 Satellite Sensor (object)
%


%%% PARAMETERS
% SATELLITE INFORMATION
sName = 'SPICESat';
sSMA = 6371+350;
sE = 0;
sI = 45;
sAP = 0;
sAN = 0;
sL = 0;
sModel = 'C:\Program Files\AGI\STK 12\STKData\VO\Models\Space\cubesat_3u.dae';

% SATELLITE SENSOR INFORMATION
ssName = 'sSensor';
ssCHA = 1;
ssRmin = 0;
ssRmax = 1501;


%%% DEFINITIONS
% SATELLITE (OBJECT)
satellite = root.CurrentScenario.Children.New('eSatellite', sName);

% SATELLITE PROPERTIES
keplerian = satellite.Propagator.InitialState.Representation.ConvertTo('eOrbitStateClassical'); % Classical Elements
keplerian.SizeShapeType = 'eSizeShapeSemimajorAxis';        % Uses Eccentricity and Inclination
keplerian.LocationType = 'eLocationTrueAnomaly';            % Makes sure True Anomaly is being used
keplerian.Orientation.AscNodeType = 'eAscNodeRAAN';         % Use RAAN for data entry

keplerian.SizeShape.SemimajorAxis = sSMA;
keplerian.SizeShape.Eccentricity = sE;
keplerian.Orientation.Inclination = sI;
keplerian.Orientation.ArgOfPerigee = sAP;
keplerian.Orientation.AscNode.Value = sAN;
keplerian.Location.Value = sL;

satellite.Propagator.InitialState.Representation.Assign(keplerian);
satellite.Propagator.Propagate;

disp("Created: Satellite")

satellite.VO.Model.ModelData.Filename = sModel;
satellite.Graphics.Resolution.Orbit = 60;

disp("Updated: Satellite Model")


%%% SATELLITE SENSOR (OBJECT)
sSensor = satellite.Children.New('eSensor', ssName);


%%% SATELLITE SENSOR PROPERTIES
sSensor.CommonTasks.SetPatternSimpleConic(ssCHA, 1);
sSensor.CommonTasks.SetPointingAlongVector('Satellite/SPICESat Body.X', 'Satellite/SPICESat North', 0);

ssRange = sSensor.AccessConstraints.AddConstraint('eCstrRange');
ssRange.EnableMin = true;
ssRange.EnableMax = true;
ssRange.min = ssRmin;
ssRange.max = ssRmax;

sSensor.Graphics.Projection.UseConstraints = true;
sSensor.Graphics.Projection.UseDistance = true;

disp("Created: Satellite Sensor")


end