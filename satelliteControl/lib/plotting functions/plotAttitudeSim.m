function [] = plotAttitudeSim(satelliteModel, dt)

disp('Plotting: Attitude Simulation')


% PRELIMINARY INFORMATION
duration = length(satelliteModel.stateS(:,11));
timeHours = (1:length(satelliteModel.stateS(:,11))) * dt / 60 / 60;
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
ylim([-1.5 1.5])
hold on
plot(timeHours, qd(:,1))
hold off

subplot(2,2,2)
plot(timeHours, stateS(:,2))
title('q2')
ylim([-1.5 1.5])
hold on
plot(timeHours, qd(:,2))
hold off

subplot(2,2,3)
plot(timeHours, stateS(:,3))
title('q3')
ylim([-1.5 1.5])
hold on
plot(timeHours, qd(:,3))
hold off

subplot(2,2,4)
plot(timeHours, stateS(:,4))
title('q4')
ylim([-1.5 1.5])
hold on
plot(timeHours, qd(:,4))
hold off


% ANGULAR VELOCITY (SATELLITE AND REACTION WHEELS)
figure('Name', 'Attitude Simulation Angular Velocity', 'Position', [100 100 900 700])

subplot(2,3,1)
plot(timeHours, stateS(:,5))
title('Satellite Angular Velocity X')

subplot(2,3,2)
plot(timeHours, stateS(:,6))
title('Satellite Angular Velocity Y')

subplot(2,3,3)
plot(timeHours, stateS(:,7))
title('Satellite Angular Velocity Z')

subplot(2,3,4)
plot(timeHours, stateS(:,8))
title('Reaction Wheel X Angular Velocity')

subplot(2,3,5)
plot(timeHours, stateS(:,9))
title('Reaction Wheel Y Angular Velocity')

subplot(2,3,6)
plot(timeHours, stateS(:,10))
title('Reaction Wheel Z Angular Velocity')

% MAGNETIC FIELD
figure('Name', 'Magnetic Field', 'Position', [100 100 900 700])
length((1:length(satelliteModel.stateS(:,11))/10)*dt/60/60)
size(satelliteModel.attitudeSystem.magnetorquer.magneticField)
plot((1:1+length(satelliteModel.stateS(:,11))/10)*10*dt/60/60, 1e-9*satelliteModel.attitudeSystem.magnetorquer.magneticField)
xlabel('Time (hours)')
ylabel('Magnetic Field (Teslas)')

end