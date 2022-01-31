disp('Start')

%%% QUATERNION DATA
figure('Name', 'Quaternions (desired and actual)', 'Position', [100 100 700 700]);

% Quaternion 1 (desired and actual)
subplot(2,2,1)
plot(t, cube.stateS(:,1))
ylim([min(cube.stateS(:,1))-0.1 max(cube.stateS(:,1)+0.1)])
title('q1')
hold on
plot(t, qd(:,1))
hold off

% Quaternion 2 (desired and actual)
subplot(2,2,2)
plot(t, cube.stateS(:,2))
ylim([min(cube.stateS(:,2))-0.1 max(cube.stateS(:,2)+0.1)])
title('q2')
hold on
plot(t, qd(:,2))
hold off

% Quaternion 3 (desired and actual)
subplot(2,2,3)
plot(t, cube.stateS(:,3))
ylim([min(cube.stateS(:,3))-0.1 max(cube.stateS(:,3)+0.1)])
title('q3')
hold on
plot(t, qd(:,3))
hold off

% Quaternion 4 (desired and actual)
subplot(2,2,4)
plot(t, cube.stateS(:,4))
ylim([min(cube.stateS(:,4))-0.1 max(cube.stateS(:,4)+0.1)])
title('q4')
hold on
plot(t, qd(:,4))
hold off


%%% ANGULAR VELOCITY DATA
figure('Name', 'Angular Velocity (satellite and wheel)', 'Position', [800 100 1100 700]);

% Angular Velocity X Satellite
subplot(2,3,1)
plot(t, cube.stateS(:,5))
ylim([min(cube.stateS(:,5))-0.1 max(cube.stateS(:,5)+0.1)])
title('Satellite wx')

% Angular Velocity Y Satellite
subplot(2,3,2)
plot(t, cube.stateS(:,6))
ylim([min(cube.stateS(:,6))-0.1 max(cube.stateS(:,6)+0.1)])
title('Satellite wy')

% Angular Velocity Z Satellite
subplot(2,3,3)
plot(t, cube.stateS(:,7))
ylim([min(cube.stateS(:,7))-0.1 max(cube.stateS(:,7)+0.1)])
title('Satellite wz')

% Angular Velocity X Wheel
subplot(2,3,4)
plot(t, cube.stateS(:,8))
ylim([min(cube.stateS(:,8))-20 max(cube.stateS(:,8)+20)])
title('Wheel wx')

% Angular Velocity Y Wheel
subplot(2,3,5)
plot(t, cube.stateS(:,9))
ylim([min(cube.stateS(:,9))-20 max(cube.stateS(:,9)+20)])
title('Wheel wy')

% Angular Velocity Z Wheel
subplot(2,3,6)
plot(t, cube.stateS(:,10))
ylim([min(cube.stateS(:,10))-20 max(cube.stateS(:,10)+20)])
title('Wheel wz')

disp('Done')