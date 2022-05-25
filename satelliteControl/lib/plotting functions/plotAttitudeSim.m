function [] = plotAttitudeSim(ax, satelliteModel, duration, timeHours)

%%% SETUP
% TABS IN ATTITUDE SIM
attitudeTabgp = uitabgroup(ax, 'Position', [0.01,0.01, 0.99, 0.99]);

% PRELIMINARY INFORMATION
qd = zeros(duration, 4);
for i = 1:size(satelliteModel.stateS,1)
    command = satelliteModel.stateS(i,22);
    qd(i,:) = satelliteModel.attitudeSystem.qd(i,:,command);
end
stateS = satelliteModel.stateS;


%%% SPACECRAFT QUATERNIONS
scQuaterTab = uitab(attitudeTabgp,'Title','SC Quaternions');
axes('parent',scQuaterTab);

scQuat1Axes = subplot(4,1,1);
plot(timeHours, stateS(:,1))
hold(scQuat1Axes,'on');
plot(timeHours, stateS(:,11))
plot(timeHours, qd(:,1))
title('q1')
xlim([0 timeHours(end)])
ylim([-1.5 1.5])
legend('Actual','Estimate','Desired')
hold(scQuat1Axes,'off');

scQuat2Axes = subplot(4,1,2);
plot(timeHours, stateS(:,2))
hold(scQuat2Axes,'on');
plot(timeHours, stateS(:,12))
plot(timeHours, qd(:,2))
title('q2')
xlim([0 timeHours(end)])
ylim([-1.5 1.5])
legend('Actual','Estimate','Desired')
hold(scQuat2Axes,'off');

scQuat3Axes = subplot(4,1,3);
plot(timeHours, stateS(:,3))
hold(scQuat3Axes,'on');
plot(timeHours, stateS(:,13))
plot(timeHours, qd(:,3))
title('q3')
xlim([0 timeHours(end)])
ylim([-1.5 1.5])
legend('Actual','Estimate','Desired')
hold(scQuat3Axes,'off');

scQuat4Axes = subplot(4,1,4);
plot(timeHours, stateS(:,4))
hold(scQuat4Axes,'on');
plot(timeHours, stateS(:,14))
plot(timeHours, qd(:,4))
title('q4')
xlim([0 timeHours(end)])
ylim([-1.5 1.5])
legend('Actual','Estimate','Desired')
hold(scQuat4Axes,'off');


%%% SPACECRAFT ANGULAR VELOCITY
scAngVelTab = uitab(attitudeTabgp,'Title','SC Angular Velocity');
axes(scAngVelTab);

scAngVelXAxes = subplot(3,1,1);
plot(timeHours, stateS(:,5))
hold(scAngVelXAxes,'on');
plot(timeHours, stateS(:,15))
xlim([0 timeHours(end)])
xlabel('Time (hours)')
ylabel('Angular Velocity (rad/s)')
title('Satellite Angular Velocity X')
legend('Actual', 'Estimate')
hold(scAngVelXAxes,'off');

scAngVelYAxes = subplot(3,1,2);
plot(timeHours, stateS(:,6))
hold(scAngVelYAxes,'on');
plot(timeHours, stateS(:,16))
xlim([0 timeHours(end)])
xlabel('Time (hours)')
ylabel('Angular Velocity (rad/s)')
title('Satellite Angular Velocity Y')
legend('Actual', 'Estimate')
hold(scAngVelYAxes,'off');

scAngVelZAxes = subplot(3,1,3);
plot(timeHours, stateS(:,7))
hold(scAngVelZAxes,'on');
plot(timeHours, stateS(:,17))
xlim([0 timeHours(end)])
xlabel('Time (hours)')
ylabel('Angular Velocity (rad/s)')
title('Satellite Angular Velocity Z')
legend('Actual', 'Estimate')
hold(scAngVelZAxes,'off');


%%% REACTION WHEEL ANGULAR VELOCITY
rwAngVelTab = uitab(attitudeTabgp,'Title','RW Angular Velocity');
axes(rwAngVelTab);

rwAngVelXAxes = subplot(3,1,1);
plot(timeHours, stateS(:,8))
hold(rwAngVelXAxes,'on');
plot(timeHours, stateS(:,18))
xlim([0 timeHours(end)])
title('Reaction Wheel X')
xlabel('Time (hours)')
ylabel('Angular Velocity (rad/s)')
title('Reaction Wheel X Angular Velocity')
legend('Actual','Estimate')
hold(rwAngVelXAxes,'off');

rwAngVelYAxes = subplot(3,1,2);
plot(timeHours, stateS(:,9))
hold(rwAngVelYAxes,'on');
plot(timeHours, stateS(:,19))
xlim([0 timeHours(end)])
title('Reaction Wheel Y')
xlabel('Time (hours)')
ylabel('Angular Velocity (rad/s)')
title('Reaction Wheel Y Angular Velocity')
legend('Actual','Estimate')
hold(rwAngVelYAxes,'off');

rwAngVelZAxes = subplot(3,1,3);
plot(timeHours, stateS(:,10))
hold(rwAngVelZAxes,'on');
plot(timeHours, stateS(:,20))
xlim([0 timeHours(end)])
title('Reaction Wheel Z')
xlabel('Time (hours)')
ylabel('Angular Velocity (rad/s)')
title('Reaction Wheel Z Angular Velocity')
legend('Actual','Estimate')
hold(rwAngVelZAxes,'off');


%%% MAGNETIC FIELD
magFieldTab = uitab(attitudeTabgp,'Title','Magnetic Field');
magFieldAxes = axes(magFieldTab);

plot(magFieldAxes, timeHours, 1e-9*satelliteModel.attitudeSystem.magnetorquer.magneticField)
xlim([0 timeHours(end)])
xlabel('Time (hours)')
ylabel('Magnetic Field (nT)')

end