function [] = plotCommandSim(ax, satelliteModel, timeHours)

%%% SETUP
% TABS IN ATTITUDE SIM
commandTabgp = uitabgroup(ax, 'Position', [0.01,0.01, 0.99, 0.99]);


%%% COMMANDS
commandTab = uitab(commandTabgp,'Title','Commands');
commandAxes = axes(commandTab);
title('Spacecraft Commands')

plot(commandAxes, timeHours, satelliteModel.stateS(:,22))
xlim([0 timeHours(end)])
ylim([0 8])
yticklabels({'', 'Nothing Mode','Safety Mode','Experiment Mode',...
    'Charging Mode','Access 1','Access 2','Access 3'})
xlabel('Time (hours)')
ylabel('Command')

% Command (integer)
    % 1: Nothing Mode
    % 2: Safety Mode
    % 3: Experiment Mode
    % 4: Charging Mode
    % 5: Access Location 1
    % 6: Access Location 2
    % N+4: Access Location N

%%% DATA STORAGE
dataTab = uitab(commandTabgp,'Title','Data Storage');
dataAxes = axes(dataTab);
title('Data Storage')

plot(dataAxes, timeHours, satelliteModel.stateS(:,23)./satelliteModel.commandSystem.ssd.capacity)
xlim([0 timeHours(end)])
ylim([-0.1 1.1])
title('Data Storage')
xlabel('Time (hours)')
ylabel('Percent Filled')


end