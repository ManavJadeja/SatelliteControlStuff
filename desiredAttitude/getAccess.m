%%% GETACCESS > Get Access between two objects
disp('Getting Access')

% Compute access between objects (satellite > facility)
access = satellite.GetAccessToObject(sensor);

access.ComputeAccess();

% Access Start and Stop Times
accessDP = access.DataProviders.Item('Access Data').Exec(scenario.StartTime, scenario.StopTime);

disp('Access Computed')