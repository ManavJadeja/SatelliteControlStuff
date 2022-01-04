function [times, eachCount] = interpolateXs(startArray, stopArray, interval)
%%% NAME: interpolatesXs
%   INPUTS:
%       startArray          List of 'Start Times'
%       stopArray           List of 'Stop Times'
%       interval            Time step (maximum)
%
%   OUTPUTS:
%       times           Time Vector containing interpolated times
%       eachCount       Interpolated time values in each access window (count)
%
%   PROCESS:
%       1) countTime function to count total size (make empty time vector)
%       2) Goes through all access window and interpolates in between
%

% Interpolation Points and Size of Output
[count, eachCount] = countTime(startArray, stopArray, interval);
times = NaT(count, 1, 'Format', 'dd MMM yyyy HH:mm:ss.S');

% Interpolating Time in Between
for a = 1:size(startArray, 1)
    timeStart = datetime(startArray(a,:), 'InputFormat', 'dd MMM yyyy HH:mm:ss.S');
    timeStop = datetime(stopArray(a,:), 'InputFormat', 'dd MMM yyyy HH:mm:ss.S');
    times(sum(eachCount(1:a-1))+1:sum(eachCount(1:a))-1) = timeStart:seconds(interval):timeStop;
    times(sum(eachCount(1:a))) = datetime(timeStop, 'InputFormat', 'dd MMM yyyy HH:mm:ss.S');
end

end

