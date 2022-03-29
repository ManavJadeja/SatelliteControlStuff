function [SATELLITEMODEL] = createSatelliteModel(root, scenario, satellite, facilityArray, accessArray, timeVector, dt)
%%%
%{
POWER SYSTEM
obj = battery(capacity, soc, R_charge, R_discharge, maxV, maxI, cells, lineDrop)
obj = solarArray(area, normalVector, efficiency)
obj = electricalSystem(nothingLoadCurrent, safetyLoadCurrent, experimentLoadCurrent,...
        chargingLoadCurrent, communicationLoadCurrent)
obj = powerSystem(time, battery, batteryData, solarArray, electricalSystem)

COMMAND SYSTEM
obj = commandSystem(socSafe, socUnsafe, sunBools, accessBools)

ATTITUDE SYSTEM
obj = magnetorquer(dipoleMagnitude, direction, magneticField)
obj = reactionWheel(stateI, inertia, maxMoment)
obj = attitudeSystem(time, t, stateI, qd, I, K, magnetorquer, reactionWheel)

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
accessQuaternions = zeros(length(t), 4, length(facilityArray));
accessBools = false(length(t), length(facilityArray));
for a = 1:length(facilityArray)
    tic
    disp(['Access for Facility ', num2str(a)])
    [accessBools(:, a), accessQuaternions(:, :, a)] = getAccessQuaternions(root, scenario, satellite, facilityArray(a), accessArray(a), timeVector, dt);
    toc
end

tic
disp('Sun Bools and Quaternions')
[sunBools, sunQuaternions] = getSunQuaternions(root, scenario, satellite, timeVector, dt);
toc

% MAGNETIC FIELD
tic
disp('Magnetic Field')
satBField = getMagneticField(scenario, satellite, dt);
toc

%%% COMPONENTS AND SUBSYSTEMS
% Command System
    % 1: Nothing Mode
    % 2: Safety Mode
    % 3: Experiment Mode
    % 4: Charging Mode
    % 5: Access Location 1
    % 6: Access Location 2
    % n+4: Access Location n
qd = zeros(length(timeVector), 4, 4+length(facilityArray));
qd(:,:,4) = sunQuaternions;                 % 4: Charging Mode
for a = 1:length(facilityArray)
    qd(:,:,a+4) = accessQuaternions(:,:,a);
end
%%% CREATING OBJECTS
% POWER SYSTEM
batteryFileName = "Moli M.battery";         % Either "Moli M.battery" or "Sony HC.battery" currently

BATTERY = battery(6.8, 0.75, 0.01, 0.01, 33.6, 40, 8, 0);
BATTERYDATA = jsondecode(fileread(batteryFileName));
SOLARARRAY = solarArray(0.06, [1,0,0], 1);
ELECTRICALSYSTEM = electricalSystem(2, 0, 10, 0.3, 5);
POWERSYSTEM = powerSystem(time, BATTERY, BATTERYDATA, SOLARARRAY, ELECTRICALSYSTEM);

% COMMAND SYSTEM
COMMANDSYSTEM = commandSystem(1, 0.5, sunBools, accessBools);

% ATTITUDE SYSTEM
MAGNETORQUER = magnetorquer(0.14, [1,0,0], satBField);
REACTIONWHEEL = reactionWheel([0,0,0], diag(5.6e-6*[1 1 1]), 6e-4);
ATTITUDESYSTEM = attitudeSystem(time, t, [1,0,0,0,0.6,0.6,0.6], qd, 3.3e-3*diag([1, 1, 1]), [1,1], MAGNETORQUER, REACTIONWHEEL);

% SATELLITE MODEL
SATELLITEMODEL = satelliteModel(time, dt, POWERSYSTEM, ATTITUDESYSTEM, COMMANDSYSTEM);



end