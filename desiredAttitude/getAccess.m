%%% GETACCESS > Get Access between two objects
disp('Getting Access')

% Compute access between objects (satellite > facility)
access = satellite.GetAccessToObject(sensor);
access.ComputeAccess();

disp('Access Computed')