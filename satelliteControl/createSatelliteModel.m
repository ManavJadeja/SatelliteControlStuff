function [SATELLITEMODEL] = createSatelliteModel(root, scenario, satellite, facilityArray, accessArray, timeVector, dt)
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
    [accessBools(:, a), accessQuaternions(:, :, a)] = getAccessQuaternions(root, scenario, satellite, facilityArray(a), accessArray(a), timeVector, dt);
    disp(['Computed: Facility ', num2str(a),' Access: ', num2str(toc), ' seconds'])
end

tic
[sunBools, sunQuaternions] = getSunQuaternions(root, scenario, satellite, timeVector, dt);
sunBools = imresize(sunBools, [length(timeVector) 1], 'nearest');
sunQuaternions = imresize(sunQuaternions, [length(timeVector) 4], 'nearest');
disp(['Computed: Sun Bools and Quaternions: ', num2str(toc), ' seconds'])

% MAGNETIC FIELD
tic
satBField = getMagneticField(scenario, satellite, dt);
satBField = imresize(satBField, [length(timeVector) 3], 'nearest');
disp(['Computed: Magnetic Field: ', num2str(toc), ' seconds'])

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
qd(:,:,4) = sunQuaternions;     % 4: Charging Mode
for a = 1:length(facilityArray)
    qd(:,:,a+4) = accessQuaternions(:,:,a);
end
%%% CREATING OBJECTS
% POWER SYSTEM
%{
obj = battery(capacity, soc, R_charge, R_discharge, maxV, maxI, cells, lineDrop)
obj = solarArray(area, normalVector, efficiency)
obj = electricalSystem(nothingLoadCurrent, safetyLoadCurrent, experimentLoadCurrent,...
        chargingLoadCurrent, communicationLoadCurrent)
obj = powerSystem(time, battery, batteryData, solarArray, electricalSystem)
%}
batteryFileName = "Moli M.battery";         % Either "Moli M.battery" or "Sony HC.battery" currently
BATTERY = battery(6.8, 0.85, 0.01, 0.01, 33.6, 40, 8, 0);
BATTERYDATA = jsondecode(fileread(batteryFileName));
SOLARARRAY = solarArray(0.06, [1,0,0], 1);
ELECTRICALSYSTEM = electricalSystem(0.5, 0.3, 5, 0.3, 5);
POWERSYSTEM = powerSystem(time, BATTERY, BATTERYDATA, SOLARARRAY, ELECTRICALSYSTEM);

% COMMAND SYSTEM
%{
obj = ssd(capacity, nothingDataGen, safetyDataGen, experimentDataGen, chargingDataGen, communicationDataGen, state0)
obj = commandSystem(socSafe, socUnsafe, ssdSafe, expDuration, dt, sunBools, accessBools, ssd)
%}
SSD = ssd(100, 0.0002, 0.0002, 0.0002+0.003+0.177, 0.0002, -0.5, 0);
COMMANDSYSTEM = commandSystem(0.75, 0.5, 0.90, 600, dt, sunBools, accessBools, SSD);

% ATTITUDE SYSTEM
%{
obj = magnetorquer(dipoleMagnitude, direction, magneticField)
obj = reactionWheel(state0, state0Error, inertiaA, inertiaError, maxMoment)
obj = attitudeSystem(state0, state0Error, qd, inertiaA, inertiaError, K, magnetorquer, reactionWheel)
%}
MAGNETORQUER = magnetorquer(0.14, [1,0,0], satBField);
REACTIONWHEEL = reactionWheel([1000,1000,1000], [0,0,0],...
    diag(5.6e-6*[1 1 1]), [0,0,0], 7e-3);
ATTITUDESYSTEM = attitudeSystem([1,0,0,0,0,0,0], [0,0,0,0,0,0,0], qd,...
    1e-2*diag([5,10,13]), 1e-4*[1,1,1], [1,1], MAGNETORQUER, REACTIONWHEEL);

% SATELLITE MODEL
%{
obj = satelliteModel(time, dt, powerSystem, attitudeSystem, commandSystem)
%}
SATELLITEMODEL = satelliteModel(time, dt, POWERSYSTEM, ATTITUDESYSTEM, COMMANDSYSTEM);



end