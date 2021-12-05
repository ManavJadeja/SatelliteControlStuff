function [x] = unitStep(t, t0)

%{
    UNIT STEP FUNCTION
    
    -Inputs
        t   > current time
        t0  > start time
    -Outputs
        x   > output

    SYNOPSIS
    x = 1 if t < t0
    x = 1 if t >= t0
%}

x = t >= t0;

end

