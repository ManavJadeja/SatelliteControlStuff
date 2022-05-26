function [commandHandles] = plotCommandSim(ax, satelliteModel, timeHours, startTime, lengthTime)

%%% SETUP
% TABS IN ATTITUDE SIM
commandTabgp = uitabgroup(ax, 'Position', [0.01,0.01, 0.99, 0.99]);

% PRELIMINARY INFORMATION
dt = satelliteModel.dt;


%%% COMMANDS
commandTab = uitab(commandTabgp,'Title','Commands');
commandAxes = axes(commandTab);

plot(commandAxes, timeHours(startTime:lengthTime),...
    satelliteModel.stateS(startTime:lengthTime,22))
xlim([startTime startTime+lengthTime]*dt/60/60)
ylim([0 8])
yticklabels({'', 'Nothing Mode','Safety Mode','Experiment Mode',...
    'Charging Mode','Access 1','Access 2','Access 3'})
xlabel('Time (hours)')
ylabel('Command')
commandHandles.commands = gca;
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

plot(dataAxes, timeHours(startTime:lengthTime),...
    satelliteModel.stateS(startTime:lengthTime,23)./satelliteModel.commandSystem.ssd.capacity)
xlim([startTime startTime+lengthTime]*dt/60/60)
ylim([-0.1 1.1])
title('Data Storage')
xlabel('Time (hours)')
ylabel('Percent Filled')
commandHandles.data = gca;

end