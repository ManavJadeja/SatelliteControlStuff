function [] = plotCommandSim(satelliteModel, dt)

disp('Plotting: Command Simulation')

% PRELIMINARY
timeHours = (1:length(satelliteModel.stateS(:,12))) * dt / 60 / 60;

% BATTERY
figure('Name', 'Command Simulation', 'Position', [100 100 900 700])
plot(timeHours, satelliteModel.stateS(:,12))
xlim([0 timeHours(end)])
ylim([0 8])
yticklabels({'', 'Nothing Mode','Safety Mode','Experiment Mode',...
    'Charging Mode','Access 1','Access 2','Access 3'})
title('Spacecraft Commands')
xlabel('Time (hours)')
ylabel('Command Number')

% Command (integer)
    % 1: Nothing Mode
    % 2: Safety Mode
    % 3: Experiment Mode
    % 4: Charging Mode
    % 5: Access Location 1
    % 6: Access Location 2
    % N+4: Access Location N

end