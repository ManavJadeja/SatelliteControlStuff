function [powerHandles] = plotPowerSim(ax, satelliteModel, timeHours, startTime, lengthTime)

%%% SETUP
% TABS IN ATTITUDE SIM
powerTabgp = uitabgroup(ax, 'Position', [0.01,0.01, 0.99, 0.99]);

% PRELIMINARY INFORMATION
dt = satelliteModel.dt;


%%% POWER SIMULATION
powerTab = uitab(powerTabgp,'Title','Power Simulation');
powerTabAxes = axes(powerTab);

plot(powerTabAxes, timeHours(startTime:lengthTime),...
    satelliteModel.stateS(startTime:lengthTime,21))
xlim([startTime startTime+lengthTime]*dt/60/60)
ylim([-0.1 1.1])
title('Battery SOC')
xlabel('Time (hours)')
ylabel('SOC (%)')
powerHandles.power = gca;

end