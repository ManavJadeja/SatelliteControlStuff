% Date time vector?

disp(scenarioStartTime)
disp(scenarioStopTime)

a1 = datetime(scenarioStartTime, 'InputFormat', 'dd MMM yyyy HH:mm:ss.SSSSSSSSS');
a2 = datetime(scenarioStopTime, 'InputFormat', 'dd MMM yyyy HH:mm:ss.SSSSSSSSS');
dt = hours(8);

v = a1:dt:a2;
disp(v)