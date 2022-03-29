%%% SATELLITE SENSOR PROPERTIES
% Add sensor object to satellite
sensor = satellite.Children.New('eSensor', 'Sensor');

% Modify sensor properties
sensor.CommonTasks.SetPatternSimpleConic(5, 1);
sensor.CommonTasks.SetPointingAlongVector('AlignVector', '', 'eCrdnVectorTypeFixedInAxes')
AlignConstain.AlignmentReferenceVector.SetVector(bodyXSat);
AlignConstain.AlignmentDirection.AssignXYZ(1, 0, 0);

% Add range constraint
range = sensor.AccessConstraints.AddConstraint('eCstrRange');
range.EnableMin = true;
range.EnableMax = true;
range.min = 0;
range.max = 1501;
