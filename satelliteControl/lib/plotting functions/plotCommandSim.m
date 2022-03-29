function [] = plotCommandSim(satelliteModel, dt)

disp('Plotting: Command Simulation')

% PRELIMINARY
timeHours = (1:length(satelliteModel.stateS(:,12))) * dt / 60 / 60;

% BATTERY
figure('Name', 'Command Simulation', 'Position', [100 100 900 700])
plot(timeHours, satelliteModel.stateS(:,12))
ylim([0 8])
title('Spacecraft Commands')
xlabel('Time (hours)')
ylabel('Command Number')

end