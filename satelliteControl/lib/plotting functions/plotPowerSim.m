function [] = plotPowerSim(ax, satelliteModel, timeHours)

%%% SETUP
% TABS IN ATTITUDE SIM
powerTabgp = uitabgroup(ax, 'Position', [0.01,0.01, 0.99, 0.99]);


%%% POWER SIMULATION
powerTab = uitab(powerTabgp,'Title','Power Simulation');
powerTabAxes = axes(powerTab);
title('Power Simulation')

plot(powerTabAxes, timeHours, satelliteModel.stateS(:,21))
xlim([0 timeHours(end)])
ylim([-0.1 1.1])
title('Battery SOC')
xlabel('Time (hours)')
ylabel('SOC (%)')

end