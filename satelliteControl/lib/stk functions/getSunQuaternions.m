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
%       sunBools            Boolean for Lighting Times
%                               0: Lighting Unavailable (sunlight)
%                               1: Lighting Available (sunlight)
%       sunQuaternions      Quaternion associated with Sun Pointing
%                               Format: <qs, qx, qy, qz>
%

%%% SETUP
% INITIALIZE MATRICES
count = 1+(length(timeVector)-1)/10;
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
    satSolarArray = root.CentralBodies.Earth.Vgt.Vectors.Item('Fixed.X');
        % This line assumes solar panel normal vector is +X Body Axes
        % To make this more versatile, need to make it use the data from
        % solar array direction instead of this fixed value
    
    % Satellite Sun Vector
    satSunVector = vgtSat.Vectors.Item('Sun');
    
    % Create Sun Rotation Angle
    sunAngle = AngFactory.Create('sunRotationAngle', 'Rotation Angle between Body +X to Sun', 'eCrdnAngleTypeBetweenVectors');
    sunAngle.FromVector.SetVector(satSolarArray);
    sunAngle.ToVector.SetVector(satSunVector);
    VectFactory.CreateCrossProductVector('sunRotationAxis', satSolarArray, satSunVector);
    
    % Add Vector and Angle to Satellite
    vector = satellite.VO.Vector;
    vectorSRAxis = vector.RefCrdns.Add('eVectorElem', ['Satellite/', satellite.InstanceName, ' sunRotationAxis']);
    angleSRAngle = vector.RefCrdns.Add('eAngleElem', ['Satellite/', satellite.InstanceName, ' sunRotationAngle']);

    % Making Vector and Angle Visible
    vectorSRAxis.Color = 65535;
    angleSRAngle.Color = 65535;
    vectorSRAxis.Visible = false;
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
sunRotationAxis = satellite.DataProviders.GetDataPrvTimeVarFromPath('Vectors(Fixed)/sunRotationAxis').Exec(scenario.StartTime, scenario.StopTime, 10*dt);
sunRotationAngle = satellite.DataProviders.GetDataPrvTimeVarFromPath('Angles/sunRotationAngle').Exec(scenario.StartTime, scenario.StopTime, 10*dt);


%%% EXTRACT DATA
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
for a = 1:size(satLTstart, 1)
    sunStarti = datetime(satLTstart(a,:), 'InputFormat', 'dd MMM yyyy HH:mm:ss.SSSSSSSSS', 'Format', 'dd MMM yyy HH:mm:ss.SSS');
    sunStopi = datetime(satLTstop(a,:), 'InputFormat', 'dd MMM yyyy HH:mm:ss.SSSSSSSSS', 'Format', 'dd mmm yyy HH:mm:ss.SSS');

    startIndex = find(dateshift(sunStarti, 'end', 'second') == timeVector(1:10:end));
    stopIndex = find(dateshift(sunStopi, 'end', 'second') == timeVector(1:10:end));
    sunBools(startIndex:stopIndex) = true;
end


% COMPUTATION
chunks = 500000;
    % If you start having memory problems, reduce 'size' as needed
numChunks = floor(count/chunks);
endPiece = rem(count, chunks);

% SUN QUATERNIONS
for a = 1:numChunks
    sunQuaternions(1+(a-1)*chunks:a*chunks,1) = cosd(sunRotationAngle(1+(a-1)*chunks:a*chunks)/2);
    sunQuaternions(1+(a-1)*chunks:a*chunks,2:4) = sunRotationAxis(1+(a-1)*chunks:a*chunks,:).*sind(sunRotationAngle(1+(a-1)*chunks:a*chunks)/2);
end

sunQuaternions(1+numChunks*chunks:end,1) = cosd(sunRotationAngle(1+numChunks*chunks:endPiece+numChunks*chunks)/2);
sunQuaternions(1+numChunks*chunks:end,2:4) = sunRotationAxis(1+numChunks*chunks:endPiece+numChunks*chunks,:).*sind(sunRotationAngle(1+numChunks*chunks:endPiece+numChunks*chunks)/2);

end