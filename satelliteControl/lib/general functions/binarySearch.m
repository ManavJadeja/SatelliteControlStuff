function [index] = binarySearch(list, val)
%%% binarySearch
%       Returns index of where value would be located within list
%   INPUTS:
%       list            Sorted list of values to search through
%       val             Value to find an index for
%
%   OUTPUTS:
%       index           Index of where value would be located within list
%

lo = 1;
hi = length(list);
best_ind = lo;
while lo <= hi
    mid = cast(lo + (hi - lo) / 2 - 0.5, "uint32");
    if list(mid) < val
        lo = mid + 1;
    elseif list(mid)> val
        hi = mid - 1;
    else
        best_ind = mid;
        break
    end
    if abs(list(mid) - val) < abs(list(best_ind) - val)
        best_ind = mid;
    end
end
index = best_ind; 

end

