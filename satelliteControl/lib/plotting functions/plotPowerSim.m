function [] = plotPowerSim(satelliteModel, dt)

disp('Plotting: Power Simulation')

% PRELIMINARY
timeHours = (1:length(satelliteModel.stateS(:,11))) * dt / 60 / 60;

% BATTERY
figure('Name', 'Power Simulation', 'Position', [100 100 900 700])
plot(timeHours, satelliteModel.stateS(:,11))
ylim([-0.1 1.1])
title('Battery SOC')
xlabel('Time (hours)')
ylabel('SOC (%)')

end