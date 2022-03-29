function [accessBools, accessQuaternions] = getAccessQuaternions(root, scenario, satellite, facility, access, timeVector, dt)
%%% getAccessQuaternions
%       Get Quaternions associated with pointing towards an access window
%
%   INPUTS:
%       root                STK (object)
%       scenario            Scenario (object)
%       satellite           Satellite (object)
%       access              Access (object)
%       timeVector          Time Vector
%       dt                  Time Step
%
%   OUTPUTS:
%       accessBool          Boolean for Access Times
%                               0: Access Unavailable
%                               1: Access Available
%       accessQuaternions   Quaternion associated with Access Pointing
%                               Format: <qs, qx, qy, qz>
%

%%% SETUP
% INTIALIZE MATRICES
count = length(timeVector);
accessBools = false(count,1);
accessQuaternions = zeros(count,4);

% DEFINE VECTORS
    % Need to use try because creating it twice throws an error
arAngleName = [facility.InstanceName, 'AccessRotationAngle'];
arAxisName = [facility.InstanceName, 'AccessRotationAxis'];
try
    % Vector and Angle Factory
    vgtSat = satellite.Vgt;
    VectFactory = vgtSat.Vectors.Factory;
    AngFactory = vgtSat.Angles.Factory;
    
    % Satellite Antenna Vector
    satAntenna = root.CentralBodies.Earth.Vgt.Vectors.Item('Fixed.X');
        % This line assumes the antenna is along the X Body Axes
        % To make this more versatile, need to make it use data from
        % antenna direction instead of this fixed value
    
    % Displacement Vector From Satellite to Facility
    pointSCenter = satellite.Vgt.Points.Item('Center');
    pointFCenter = facility.Vgt.Points.Item('Center');
    satAccessVector = VectFactory.CreateDisplacementVector(['sat2', facility.InstanceName], pointSCenter, pointFCenter);
    
    % Access Rotation Angle
    accessAngle = AngFactory.Create(arAngleName, ['Rotation Angle between Body X to ', facility.InstanceName], 'eCrdnAngleTypeBetweenVectors');
    accessAngle.FromVector.SetVector(satAntenna);
    accessAngle.ToVector.SetVector(satAccessVector);
    VectFactory.CreateCrossProductVector(arAxisName, satAntenna, satAccessVector);
    
    % Add Vector and Angle to Satellite
    vector = satellite.VO.Vector;
    vectorARAxis = vector.RefCrdns.Add('eVectorElem', ['Satellite/', satellite.InstanceName, ' ', arAxisName]);
    angleARAngle = vector.RefCrdns.Add('eAngleElem', ['Satellite/', satellite.InstanceName, ' ', arAngleName]);

    % Make Access Rotation Angle Visible
    vector.VectorSizeScale = 0.2;
    vector.AngleSizeScale = 0.5;
    vectorARAxis.Color = facility.Graphics.Color;
    angleARAngle.Color = facility.Graphics.Color;
    vectorARAxis.Visible = true;
    angleARAngle.Visible = true;
    angleARAngle.LabelVisible = true;
    angleARAngle.AngleValueVisible = true;
catch
    disp('Access Rotation Axis and Angle already exist')
end


%%% DATA PROVIDERS
% ACCESS WINDOWS
try
    accessDP = access.DataProviders.Item('Access Data').Exec(scenario.StartTime, scenario.StopTime);
    accessStart = cell2mat(accessDP.DataSets.GetDataSetByName('Start Time').GetValues);
    accessStop = cell2mat(accessDP.DataSets.GetDataSetByName('Stop Time').GetValues);

    % ACCESS ROTATION AXIS AND ANGLE
    accessRotationAxis = satellite.DataProviders.GetDataPrvTimeVarFromPath(['Vectors(Fixed)/', arAxisName]).Exec(scenario.StartTime, scenario.StopTime, dt);
    accessRotationAngle = satellite.DataProviders.GetDataPrvTimeVarFromPath(['Angles/', arAngleName]).Exec(scenario.StartTime, scenario.StopTime, dt);


    %%% EXTRACT DATA
    % ACCESS ROTATION AXIS
    accessRotationAxis = [
        cell2mat(accessRotationAxis.DataSets.GetDataSetByName('x/Magnitude').GetValues),...
        cell2mat(accessRotationAxis.DataSets.GetDataSetByName('y/Magnitude').GetValues),...
        cell2mat(accessRotationAxis.DataSets.GetDataSetByName('z/Magnitude').GetValues),...
    ];

    % ACCESS ROTATION ANGLE
    accessRotationAngle = cell2mat(accessRotationAngle.DataSets.GetDataSetByName('Angle').GetValues);


    %%% COMPUTATION
    chunks = 500000;
        % If you start having memory problems, reduce 'size' as needed
    numChunks = floor(count/chunks);
    
    for a = 1:numChunks
        % ACCESS QUATERNIONS
        accessQuaternions(1+(a-1)*chunks:a*chunks,1) = cosd(accessRotationAngle(1+(a-1)*chunks:a*chunks)/2);
        accessQuaternions(1+(a-1)*chunks:a*chunks,2:4) = accessRotationAxis(1+(a-1)*chunks:a*chunks,:).*sind(accessRotationAngle(1+(a-1)*chunks:a*chunks)/2);
    end

    accessQuaternions(1+numChunks*chunks:end,1) = cosd(accessRotationAngle(1+numChunks*chunks:end)/2);
    accessQuaternions(1+numChunks*chunks:end,2:4) = accessRotationAxis(1+numChunks*chunks:end,:).*sind(accessRotationAngle(1+numChunks*chunks:end)/2);


    % ACCESS BOOLS
    for a = 1:size(accessStart, 1)
        accessStarti = datetime(accessStart(a,:), 'InputFormat', 'dd MMM yyyy HH:mm:ss.SSSSSSSSS', 'Format', 'dd MMM yyy HH:mm:ss.SSS');
        accessStopi = datetime(accessStop(a,:), 'InputFormat', 'dd MMM yyyy HH:mm:ss.SSSSSSSSS', 'Format', 'dd mmm yyy HH:mm:ss.SSS');

        startIndex = find(dateshift(accessStarti, 'start', 'second') == timeVector);
        stopIndex = find(dateshift(accessStopi, 'start', 'second') == timeVector);
        accessBools(startIndex:stopIndex) = true;
    end

catch
    disp('NO ACCESS WINDOWS FOUND')
end

end