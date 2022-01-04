function [times] = interpolateXs(timeStart, timeStop, interval)
%INTERPOLATEXS
%   Interpolates time between a given access window
%   Starts at the 'Start Time', ends at the 'Stop Time'
%   Creates a point every x seconds (until 'Stop Time')

% Interpolation Points and Size of Output
duration = seconds(timeStop-timeStart);
points = ceil(duration/interval);
times = NaT(points+1, 1, 'Format', 'dd MMM yyyy HH:mm:ss.SSSSSSSSS');

% Start and Ending Values
times(1) = datetime(timeStart, 'InputFormat', 'dd MMM yyyy HH:mm:ss.SSSSSSSSS');
times(end) = datetime(timeStop, 'InputFormat', 'dd MMM yyyy HH:mm:ss.SSSSSSSSS');

% Interpolation
for a = 2:points
    times(a) = times(1) + (a-1)*seconds(interval);
end


end

