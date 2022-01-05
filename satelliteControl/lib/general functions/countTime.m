function [count, eachCount] = countTime(startArray, stopArray, interval)
%%% countTime
%       Counts the number of points in time after interpolation
%   INPUTS:
%       startArray      List of 'Start Times'
%       stopArray       List of 'Stop Times'
%       interval        Time step (maximum)
%
%   OUTPUTS:
%       count           Total number of points in time
%       eachCount       Number of points in each access window
%


%%% SETUP
rows1 = size(startArray, 1);
eachCount = zeros(1, rows1);
count = 0;

%%% ITERATE AND COUNT
for i = 1:rows1
    timeStart = datetime(startArray(i,:), 'InputFormat', 'dd MMM yyyy HH:mm:ss.SSSSSSSSS');
    timeStop = datetime(stopArray(i,:), 'InputFormat', 'dd MMM yyyy HH:mm:ss.SSSSSSSSS');
    duration = seconds(timeStop - timeStart);
    eachCount(i) = ceil(duration/interval) + 1;
    count = count + eachCount(i);
end

% Minus one because some stupid round off issue
count = count-1;

end
