function [x] = controller(t, x0, xDesired, kp, ki, kd)
%{
    CONTROLLER

    -Inputs
        xD  > Desired value
        x0  > Initial value
        t   > Time
        kp  > proportionality constant
    -Outputs
        x           > Output value

    SYNOPSIS
    
    Get current value, compare to ideal value, take a step
%}

%%% INITIAL MATRICES
x = x0*ones(1,length(t));
dxP = zeros(1,length(t));
dxI = zeros(1,length(t));
dxD = zeros(1,length(t));
ePresent = zeros(1, length(t));
ePast = zeros(1,length(t));


%%% CONTROL LOOP
for a = 2:length(t)-1
    %%% ERROR AND STEP
    ePresent(a) = xDesired(a) - x(a);
    ePast(a) = ePresent(a-1);
    tStep = t(a) - t(a-1);
    
    %%% PID CONTROL
    % Proportional
    dxP(a) = kp*ePresent(a);
    % Integral
    dxI(a) = ki*sum(ePresent); % ERROR
    % Derivative
    dxD(a) = kd*(ePresent(a)-ePast(a))*(abs(dxD(a)) > kd)/tStep; % ERROR
    
    %%% OUTPUT
    x(a+1) = x(a) + (dxP(a) + dxI(a) + dxD(a))*tStep;
end

%{
disp('xd')
disp(xDesired)
disp('x')
disp(x)
disp('e1')
disp(ePresent)
disp('e2')
disp(ePast)
disp('D')
disp(dxD)
%}

end

