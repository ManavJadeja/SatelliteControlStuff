function [SATELLITEMODEL] = createSatelliteModel(root, scenario, satellite, facility, access, timeVector, dt)
%%%
%{
POWER SYSTEM
obj = battery(capacity, soc, R_charge, R_discharge, maxV, maxI, cells, lineDrop)
obj = solarArray(area, normalVector, efficiency)
obj = powerSystem(time, battery, solarArray, sunVector)

COMMAND SYSTEM
obj = commandSystem(socSafe, socUnsafe, accessBools, sunBools)

ATTITUDE SYSTEM
obj = magnetorquer(dipoleMagnitude, direction, magneticField)
obj = attitudeSystem(time, t, stateI, qd, I, K, magnetorquer)

SATELLITE MODEL
obj = satelliteModel(time, dt, powerSystem, attitudeSystem, commandSystem)

%}

%%% PRELIMINARY
% OBJECT PATHS
addpath(genpath('../../lib'));
addpath(genpath('../../src'));
addpath(genpath('../../tmp'));
addpath(genpath('../../res'));

% TIME
time = 0:dt:dt*(length(timeVector)-1);
t = 1:length(timeVector);

% BOOLS AND QUATERNIONS
[accessBools, accessQuaternions] = getAccessQuaternions(root, scenario, satellite, facility, access, timeVector, dt);
[sunBools, sunQuaternions] = getSunQuaternions(root, scenario, satellite, timeVector, dt);

% MAGNETIC FIELD
satBField = getMagneticField(scenario, satellite, dt);


%%% COMPONENTS AND SUBSYSTEMS
% Command System
qd = zeros(length(timeVector), 4, 5);       % 0: Safety Mode % 1: Nothing Mode % 4: Experiment Mode
qd(:,:,2) = sunQuaternions;                 % 2: Charging Mode
qd(:,:,3) = accessQuaternions;              % 3: Communication Mode

%%% CREATING OBJECTS
% POWER SYSTEM
batteryFileName = "Moli M.battery";         % Either "Moli M.battery" or "Sony HC.battery" currently

BATTERY = battery(1000, 0.70, 0.01, 0.01, 33.6, 40, 8, 0);
BATTERYDATA = jsondecode(fileread(batteryFileName));
SOLARARRAY = solarArray(1, [0,0,-1], 1);
POWERSYSTEM = powerSystem(time, BATTERY, BATTERYDATA, SOLARARRAY);

% COMMAND SYSTEM
COMMANDSYSTEM = commandSystem(0.9, 0.8, accessBools, sunBools);

% ATTITUDE SYSTEM
MAGNETORQUER = magnetorquer(0.2, [1,0,0], satBField);
ATTITUDESYSTEM = attitudeSystem(time, t, [1,0,0,0,0,0,0], qd, diag([1, 1, 1]), [1,1], MAGNETORQUER);

% SATELLITE MODEL
SATELLITEMODEL = satelliteModel(time, dt, POWERSYSTEM, ATTITUDESYSTEM, COMMANDSYSTEM);



end