% Data Providers
sunRAxis = satellite.DataProviders.GetDataPrvTimeVarFromPath('Vectors(Fixed)/RotationAxis1').Exec(scenario.StartTime, scenario.StopTime, interval);
sunRAngle = satellite.DataProviders.GetDataPrvTimeVarFromPath('Angles/RotationAngle1').Exec(scenario.StartTime, scenario.StopTime, interval);

sunRAxis = [
    cell2mat(sunRAxis.DataSets.GetDataSetByName('x/Magnitude').GetValues),...
    cell2mat(sunRAxis.DataSets.GetDataSetByName('y/Magnitude').GetValues),...
    cell2mat(sunRAxis.DataSets.GetDataSetByName('z/Magnitude').GetValues),...
];

sunRAngle = cell2mat(sunRAngle.DataSets.GetDataSetByName('Angle').GetValues);
