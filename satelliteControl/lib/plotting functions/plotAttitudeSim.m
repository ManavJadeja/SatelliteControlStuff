function [] = plotAttitudeSim(satelliteModel, dt)

disp('Plotting: Attitude Simulation')


% PRELIMINARY INFORMATION
duration = length(satelliteModel.time);
timeHours = (1:length(satelliteModel.time)) * dt / 60 / 60;
qd = zeros(duration, 4);

for i = 1:length(satelliteModel.commandSystem.stateS)
    command = satelliteModel.commandSystem.stateS(i);
    qd(i,:) = satelliteModel.attitudeSystem.qd(i,:,command);
end
stateS = satelliteModel.stateS;

% QUATERNION DATA
figure('Name', 'Attitude Simulation Quaternions', 'Position', [100 100 900 700])

subplot(2,2,1)
plot(timeHours, stateS(:,1))
title('q1')
xlim([0 timeHours(end)])
ylim([-1.5 1.5])
hold on
plot(timeHours, qd(:,1))
hold off

subplot(2,2,2)
plot(timeHours, stateS(:,2))
title('q2')
xlim([0 timeHours(end)])
ylim([-1.5 1.5])
hold on
plot(timeHours, qd(:,2))
hold off

subplot(2,2,3)
plot(timeHours, stateS(:,3))
title('q3')
xlim([0 timeHours(end)])
ylim([-1.5 1.5])
hold on
plot(timeHours, qd(:,3))
hold off

subplot(2,2,4)
plot(timeHours, stateS(:,4))
title('q4')
xlim([0 timeHours(end)])
ylim([-1.5 1.5])
hold on
plot(timeHours, qd(:,4))
hold off


% ANGULAR VELOCITY (SATELLITE AND REACTION WHEELS)
figure('Name', 'Attitude Simulation Angular Velocity', 'Position', [100 100 900 700])

subplot(2,3,1)
plot(timeHours, stateS(:,5))
xlim([0 timeHours(end)])
xlabel('Time (hours)')
ylabel('Angular Velocity (rad/s)')
title('Satellite Angular Velocity X')

subplot(2,3,2)
plot(timeHours, stateS(:,6))
xlim([0 timeHours(end)])
xlabel('Time (hours)')
ylabel('Angular Velocity (rad/s)')
title('Satellite Angular Velocity Y')

subplot(2,3,3)
plot(timeHours, stateS(:,7))
xlim([0 timeHours(end)])
xlabel('Time (hours)')
ylabel('Angular Velocity (rad/s)')
title('Satellite Angular Velocity Z')

subplot(2,3,4)
plot(timeHours, stateS(:,8))
xlim([0 timeHours(end)])
title('Reaction Wheel X')
xlabel('Time (hours)')
ylabel('Angular Velocity (rad/s)')
title('Reaction Wheel X Angular Velocity')

subplot(2,3,5)
plot(timeHours, stateS(:,9))
xlim([0 timeHours(end)])
title('Reaction Wheel Y')
xlabel('Time (hours)')
ylabel('Angular Velocity (rad/s)')
title('Reaction Wheel Y Angular Velocity')

subplot(2,3,6)
plot(timeHours, stateS(:,10))
xlim([0 timeHours(end)])
title('Reaction Wheel Z')
xlabel('Time (hours)')
ylabel('Angular Velocity (rad/s)')
title('Reaction Wheel Z Angular Velocity')

% MAGNETIC FIELD
figure('Name', 'Magnetic Field', 'Position', [100 100 900 700])
plot((1:1+length(satelliteModel.stateS(:,11))/10)*10*dt/60/60, 1e-9*satelliteModel.attitudeSystem.magnetorquer.magneticField)
xlim([0 timeHours(end)])
xlabel('Time (hours)')
ylabel('Magnetic Field (nT)')

end