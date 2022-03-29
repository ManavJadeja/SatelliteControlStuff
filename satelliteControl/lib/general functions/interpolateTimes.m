function [times, eachCount] = interpolateTimes(startArray, stopArray, interval)
%%% interpolatesTimes
%   INPUTS:
%       startArray          List of 'Start Times'
%       stopArray           List of 'Stop Times'
%       interval            Time step (maximum)
%
%   OUTPUTS:
%       times           Time Vector containing interpolated times
%       eachCount       Interpolated time values in each access window (count)
%


%%% SETUP
% TOTAL LENGTH AND EMPTY LIST
[count, eachCount] = countTime(startArray, stopArray, interval);
times = NaT(count, 1, 'Format', 'dd MMM yyyy HH:mm:ss.SSSSS');

%%% INTERPOLATION
for a = 1:size(startArray, 1)
    timeStart = datetime(startArray(a,:), 'InputFormat', 'dd MMM yyyy HH:mm:ss.SSSSS');
    timeStop = datetime(stopArray(a,:), 'InputFormat', 'dd MMM yyyy HH:mm:ss.SSSSS');
    times(sum(eachCount(1:a-1))+1:sum(eachCount(1:a))-1) = timeStart:seconds(interval):timeStop;
    times(sum(eachCount(1:a))) = datetime(timeStop, 'InputFormat', 'dd MMM yyyy HH:mm:ss.SSSSS');
end

end


