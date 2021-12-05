%%% PLOTTING DATA

% Quaternion Data
figure('Name', 'Quaternion Data', 'Position', [100 100 900 700]);

% Quaternion 1 (desired and actual)
subplot(2,2,1)
plot(t, q(1,:))
title('q1')
hold on
plot(t, qd(1,:))
hold off

% Quaternion 2 (desired and actual)
subplot(2,2,2)
plot(t, q(2,:))
title('q2')
hold on
plot(t, qd(2,:))
hold off

% Quaternion 3 (desired and actual)
subplot(2,2,3)
plot(t, q(3,:))
title('q3')
hold on
plot(t, qd(3,:))
hold off

% Quaternion 4 (desired and actual)
subplot(2,2,4)
plot(t, q(4,:))
title('q4')
hold on
plot(t, qd(4,:))
hold off