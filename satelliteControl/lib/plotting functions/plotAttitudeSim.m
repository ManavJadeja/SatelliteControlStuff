function [] = plotAttitudeSim(satelliteModel, dt)

disp('Plotting: Attitude Simulation')


% PRELIMINARY INFORMATION
duration = length(satelliteModel.time);
timeHours = (1:length(satelliteModel.time)) * dt / 60 / 60;
qd = zeros(duration, 4);

for i = 1:size(satelliteModel.stateS,1)
    command = satelliteModel.stateS(i,22);
    qd(i,:) = satelliteModel.attitudeSystem.qd(i,:,command);
end
stateS = satelliteModel.stateS;

% ACTUAL QUATERNION DATA
figure('Name', 'Attitude Simulation Quaternions (Actual)', 'Position', [100 100 900 700])

subplot(2,2,1)
plot(timeHours, stateS(:,1))
title('q1')
xlim([0 timeHours(end)])
ylim([-1.5 1.5])
hold on
plot(timeHours, stateS(:,11))
plot(timeHours, qd(:,1))
hold off

subplot(2,2,2)
plot(timeHours, stateS(:,2))
title('q2')
xlim([0 timeHours(end)])
ylim([-1.5 1.5])
hold on
plot(timeHours, stateS(:,12))
plot(timeHours, qd(:,2))
hold off

subplot(2,2,3)
plot(timeHours, stateS(:,3))
title('q3')
xlim([0 timeHours(end)])
ylim([-1.5 1.5])
hold on
plot(timeHours, stateS(:,13))
plot(timeHours, qd(:,3))
hold off

subplot(2,2,4)
plot(timeHours, stateS(:,4))
title('q4')
xlim([0 timeHours(end)])
ylim([-1.5 1.5])
hold on
plot(timeHours, stateS(:,14))
plot(timeHours, qd(:,4))
hold off


% ANGULAR VELOCITY (ACTUAL)
figure('Name', 'Attitude Simulation Angular Velocity', 'Position', [100 100 900 700])

subplot(2,3,1)
plot(timeHours, stateS(:,5))
hold on
plot(timeHours, stateS(:,15))
xlim([0 timeHours(end)])
xlabel('Time (hours)')
ylabel('Angular Velocity (rad/s)')
title('Satellite Angular Velocity X')

subplot(2,3,2)
plot(timeHours, stateS(:,6))
hold on
plot(timeHours, stateS(:,16))
xlim([0 timeHours(end)])
xlabel('Time (hours)')
ylabel('Angular Velocity (rad/s)')
title('Satellite Angular Velocity Y')

subplot(2,3,3)
plot(timeHours, stateS(:,7))

hold on
plot(timeHours, stateS(:,17))
xlim([0 timeHours(end)])
xlabel('Time (hours)')
ylabel('Angular Velocity (rad/s)')
title('Satellite Angular Velocity Z')

subplot(2,3,4)
plot(timeHours, stateS(:,8))
hold on
plot(timeHours, stateS(:,18))
xlim([0 timeHours(end)])
title('Reaction Wheel X')
xlabel('Time (hours)')
ylabel('Angular Velocity (rad/s)')
title('Reaction Wheel X Angular Velocity')

subplot(2,3,5)
plot(timeHours, stateS(:,9))
hold on
plot(timeHours, stateS(:,19))
xlim([0 timeHours(end)])
title('Reaction Wheel Y')
xlabel('Time (hours)')
ylabel('Angular Velocity (rad/s)')
title('Reaction Wheel Y Angular Velocity')

subplot(2,3,6)
plot(timeHours, stateS(:,10))

hold on
plot(timeHours, stateS(:,20))
xlim([0 timeHours(end)])
title('Reaction Wheel Z')
xlabel('Time (hours)')
ylabel('Angular Velocity (rad/s)')
title('Reaction Wheel Z Angular Velocity')

% MAGNETIC FIELD
figure('Name', 'Magnetic Field', 'Position', [100 100 900 700])
plot(timeHours, 1e-9*satelliteModel.attitudeSystem.magnetorquer.magneticField)
xlim([0 timeHours(end)])
xlabel('Time (hours)')
ylabel('Magnetic Field (nT)')

end