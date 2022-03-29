function [count, eachCount] = countTime(startArray, stopArray, interval)
%%% NAME: countTime
%   INPUTS:
%       startArray      List of 'Start Times'
%       stopArray       List of 'Stop Times'
%       interval        Time step (maximum)
%
%   OUTPUTS:
%       count           Total number of points in time
%       eachCount       Number of points in each access window
%
%   PROCESS:
%       1) Get duration between each 'Start Time' and 'Stop Time'
%       2) Compute number of points in each window
%       3) Sum over and keep track of each size
%

% Setup
rows1 = size(startArray, 1);
eachCount = zeros(1, rows1);
count = 0;

% Iterate through and count
for i = 1:rows1
    timeStart = datetime(startArray(i,:), 'InputFormat', 'dd MMM yyyy HH:mm:ss.SSSSSSSSS');
    timeStop = datetime(stopArray(i,:), 'InputFormat', 'dd MMM yyyy HH:mm:ss.SSSSSSSSS');
    duration = seconds(timeStop - timeStart);
    eachCount(i) = ceil(duration/interval) + 1;
    count = count + eachCount(i);
end

% Minus one because???
count = count-1;

end

