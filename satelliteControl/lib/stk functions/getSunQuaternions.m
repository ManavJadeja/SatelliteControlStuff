function [sunBools, sunQuaternions] = getSunQuaternions(root, scenario, satellite, timeVector, dt)
%%% getSunQuaternions
%       Get Quaternions associated with pointing towards the sun
%
%   INPUTS:
%       root                STK (object)
%       scenario            Scenario (object)
%       satellite           Satellite (object)
%       timeVector          Time Vector
%       dt                  Time Step
%
%   OUTPUTS:
%       sunBool             Boolean for Lighting Times
%                               0: Lighting Unavailable (sunlight)
%                               1: Lighting Available (sunlight)
%       sunQuaternions      Quaternion associated with Sun Pointing
%                               Format: <qs, qx, qy, qz>
%

%%% SETUP
% INTIALIZE MATRICES
count = length(timeVector);
sunBools = false(count,1);
sunQuaternions = zeros(count,4);

% DEFINE VECTORS
    % Need to use try because creating it twice throws an error
try
    % Vector and Angle Factory
    vgtSat = satellite.Vgt;
    VectFactory = vgtSat.Vectors.Factory;
    AngFactory = vgtSat.Angles.Factory;
    
    % Satellite Solar Array Normal Vector
    satSolarArray = root.CentralBodies.Earth.Vgt.Vectors.Item('Fixed.-Z');
        % This line assumes solar panel normal vector is -Z Body Axes
        % To make this more versatile, need to make it use the data from
        % solar array direction instead of this fixed value
    
    % Satellite Sun Vector    
    satSunVector = vgtSat.Vectors.Item('Sun');
    
    % Create Sun Rotation Angle
    sunAngle = AngFactory.Create('sunRotationAngle', 'Rotation Angle between Body -Z to Sun', 'eCrdnAngleTypeBetweenVectors');
    sunAngle.FromVector.SetVector(satSolarArray);
    sunAngle.ToVector.SetVector(satSunVector);
    VectFactory.CreateCrossProductVector('sunRotationAxis', satSolarArray, satSunVector);
    
    % Add Vector and Angle to Satellite
    vector = satellite.VO.Vector;
    vectorSRAxis = vector.RefCrdns.Add('eVectorElem', ['Satellite/',satellite.InstanceName, ' sunRotationAxis']);
    angleSRAngle = vector.RefCrdns.Add('eAngleElem', ['Satellite/',satellite.InstanceName, ' sunRotationAngle']);

    % Making Vector and Angle Visible
    vectorSRAxis.Visible = true;
    angleSRAngle.Visible = true;
    angleSRAngle.LabelVisible = true;
    angleSRAngle.AngleValueVisible = true;
catch
    disp('Sun Rotation Axis and Angle already exist')
end


%%% DATA PROVIDERS
% LIGHTING
satLTDP = satellite.DataProviders.GetDataPrvIntervalFromPath('Lighting Times/Sunlight').Exec(scenario.StartTime, scenario.StopTime);
satLTstart = cell2mat(satLTDP.DataSets.GetDataSetByName('Start Time').GetValues);
satLTstop = cell2mat(satLTDP.DataSets.GetDataSetByName('Stop Time').GetValues);

% SUN ROTATION AXIS AND ANGLE
sunRotationAxis = satellite.DataProviders.GetDataPrvTimeVarFromPath('Vectors(Fixed)/sunRotationAxis').Exec(scenario.StartTime, scenario.StopTime, dt);
sunRotationAngle = satellite.DataProviders.GetDataPrvTimeVarFromPath('Angles/sunRotationAngle').Exec(scenario.StartTime, scenario.StopTime, dt);


%%% EXTRACT DATA
% LIST OF AVAILABLE SUN TIMES
[sunTimes, eachCount] = interpolateTimes(satLTstart, satLTstop, dt);

% SUN ROTATION AXIS
sunRotationAxis = [
    cell2mat(sunRotationAxis.DataSets.GetDataSetByName('x/Magnitude').GetValues),...
    cell2mat(sunRotationAxis.DataSets.GetDataSetByName('y/Magnitude').GetValues),...
    cell2mat(sunRotationAxis.DataSets.GetDataSetByName('z/Magnitude').GetValues),...
];

% SUN ROTATION ANGLE
sunRotationAngle = cell2mat(sunRotationAngle.DataSets.GetDataSetByName('Angle').GetValues);


%%% COMPUTATION
% SUN BOOLEANS
a = 1;
for i = 1:count
    if (a < sum(eachCount)) && (abs(timeVector(i) - sunTimes(a)) <= 0.000005)
        sunBools(i) = true;
        a = a + 1;
    end
end

% SUN QUATERNIONS
sunQuaternions(:,1) = cosd(sunRotationAngle/2);
sunQuaternions(:,2:4) = sunRotationAxis.*sind(sunRotationAngle/2);


end