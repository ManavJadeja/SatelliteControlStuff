disp('Plotting...')

%%% PRELIMINARY INFORMATION
duration = length(satelliteModel.time);
timeHours = (1:length(satelliteModel.time)) * dt / 60 / 60;

%%% MAIN FIGURE
f = figure('Name', 'Plots', 'Position', [100 100 1000 800]);
tabgp = uitabgroup(f, 'Position', [0.01,0.01, 0.99, 0.99]);

% ATTITUDE TAB
attitudeTab = uitab(tabgp,'Title','Attitude System');
plotAttitudeSim(attitudeTab, satelliteModel, duration, timeHours);

% POWER TAB
powerTab = uitab(tabgp,'Title','Power System');
plotPowerSim(powerTab, satelliteModel, timeHours);

% COMMAND TAB
commandTab = uitab(tabgp,'Title','Command System');
plotCommandSim(commandTab, satelliteModel, timeHours);

disp('DONE')