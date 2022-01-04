% Add an external attitude file (learn how to make a .a file)
disp('Adding Attitude Data to Satellite')

% Get and Load File
toAttitudeFile = 'C:\Users\miastra\Documents\MATLAB\Satellite Stuff\Satellite Control Stuff\desiredAttitude\scriptedAttitude.a';
satellite.Attitude.External.Load(toAttitudeFile);

disp('Attitude Data Added')