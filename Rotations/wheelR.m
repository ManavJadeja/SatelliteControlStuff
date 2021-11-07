function [M] = wheelR(t, t_start, t_stop, force, distance, direction)

% Burn between expected time 
if (t <= t_start || t >= t_stop)
    fire = 0;
else
    fire = 1;
end
% Should I make this its own script?
% It's just the sum of two step functions~

% Moment components
M = force*distance*fire*[direction(1);direction(2);direction(3)];

end