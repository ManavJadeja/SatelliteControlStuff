function [attitudeHandles] = plotAttitudeSim(ax, satelliteModel, timeHours, startTime, lengthTime)

%%% SETUP
% TABS IN ATTITUDE SIM
attitudeTabgp = uitabgroup(ax, 'Position', [0.01,0.01, 0.99, 0.99]);

% PRELIMINARY INFORMATION
dt = satelliteModel.dt;
duration = length(satelliteModel.time);
qd = zeros(duration, 4);
for i = 1:size(satelliteModel.stateS,1)
    command = satelliteModel.stateS(i,22);
    qd(i,:) = satelliteModel.attitudeSystem.qd(i,:,command);
end
stateS = satelliteModel.stateS;


%%% SPACECRAFT QUATERNIONS
scQuaterTab = uitab(attitudeTabgp,'Title','SC Quaternions');
axes('parent',scQuaterTab);

attitudeHandles.scQuat1Axes = subplot(4,1,1);
plot(timeHours(startTime:lengthTime), stateS(startTime:lengthTime,1))
hold(attitudeHandles.scQuat1Axes,'on');
plot(timeHours(startTime:lengthTime), stateS(startTime:lengthTime,11))
plot(timeHours(startTime:lengthTime), qd(startTime:lengthTime,1))
title('q1')
xlim([startTime startTime+lengthTime]*dt/60/60)
ylim([-1.5 1.5])
legend('Actual','Estimate','Desired')
hold(attitudeHandles.scQuat1Axes,'off');

attitudeHandles.scQuat2Axes = subplot(4,1,2);
plot(timeHours(startTime:lengthTime), stateS(startTime:lengthTime,2))
hold(attitudeHandles.scQuat2Axes,'on');
plot(timeHours(startTime:lengthTime), stateS(startTime:lengthTime,12))
plot(timeHours(startTime:lengthTime), qd(startTime:lengthTime,2))
title('q2')
xlim([startTime startTime+lengthTime]*dt/60/60)
ylim([-1.5 1.5])
legend('Actual','Estimate','Desired')
hold(attitudeHandles.scQuat2Axes,'off');

attitudeHandles.scQuat3Axes = subplot(4,1,3);
plot(timeHours(startTime:lengthTime), stateS(startTime:lengthTime,3))
hold(attitudeHandles.scQuat3Axes,'on');
plot(timeHours(startTime:lengthTime), stateS(startTime:lengthTime,13))
plot(timeHours(startTime:lengthTime), qd(startTime:lengthTime,3))
title('q3')
xlim([startTime startTime+lengthTime]*dt/60/60)
ylim([-1.5 1.5])
legend('Actual','Estimate','Desired')
hold(attitudeHandles.scQuat3Axes,'off');

attitudeHandles.scQuat4Axes = subplot(4,1,4);
plot(timeHours(startTime:lengthTime), stateS(startTime:lengthTime,4))
hold(attitudeHandles.scQuat4Axes,'on');
plot(timeHours(startTime:lengthTime), stateS(startTime:lengthTime,14))
plot(timeHours(startTime:lengthTime), qd(startTime:lengthTime,4))
title('q4')
xlim([startTime startTime+lengthTime]*dt/60/60)
ylim([-1.5 1.5])
legend('Actual','Estimate','Desired')
hold(attitudeHandles.scQuat4Axes,'off');


%%% SEMILOG ERROR PLOTS
scQErrorTab = uitab(attitudeTabgp,'Title','SC Quaternion Error');
axes('parent',scQErrorTab);

% ACTUAL - ESTIMATE
attitudeHandles.scQ1AE = subplot(4,2,1);
semilogy(attitudeHandles.scQ1AE, timeHours(startTime:lengthTime),...
    abs(stateS(startTime:lengthTime,1) - stateS(startTime:lengthTime,11)))
xlim([startTime startTime+lengthTime]*dt/60/60)
ylim([1e-15 2*1e1])
yticks([1e-15 1e-10 1e-5 1e0])
yticklabels({'1e-15','1e-10','1e-5','1e0'})
title('q1 (Actual - Estimate)')

attitudeHandles.scQ2AE = subplot(4,2,3);
semilogy(attitudeHandles.scQ2AE, timeHours(startTime:lengthTime),...
    abs(stateS(startTime:lengthTime,2) - stateS(startTime:lengthTime,12)))
xlim([startTime startTime+lengthTime]*dt/60/60)
ylim([1e-15 2*1e1])
yticks([1e-15 1e-10 1e-5 1e0])
yticklabels({'1e-15','1e-10','1e-5','1e0'})
title('q2 (Actual - Estimate)')

attitudeHandles.scQ3AE = subplot(4,2,5);
semilogy(attitudeHandles.scQ3AE, timeHours(startTime:lengthTime),...
    abs(stateS(startTime:lengthTime,3) - stateS(startTime:lengthTime,13)))
xlim([startTime startTime+lengthTime]*dt/60/60)
ylim([1e-15 2*1e1])
yticks([1e-15 1e-10 1e-5 1e0])
yticklabels({'1e-15','1e-10','1e-5','1e0'})
title('q3 (Actual - Estimate)')

attitudeHandles.scQ4AE = subplot(4,2,7);
semilogy(attitudeHandles.scQ4AE, timeHours(startTime:lengthTime),...
    abs(stateS(startTime:lengthTime,4) - stateS(startTime:lengthTime,14)))
xlim([startTime startTime+lengthTime]*dt/60/60)
ylim([1e-15 2*1e1])
yticks([1e-15 1e-10 1e-5 1e0])
yticklabels({'1e-15','1e-10','1e-5','1e0'})
title('q4 (Actual - Estimate)')

% ACTUAL - DESIRED
attitudeHandles.scQ1AD = subplot(4,2,2);
semilogy(attitudeHandles.scQ1AD, timeHours(startTime:lengthTime),...
    abs(stateS(startTime:lengthTime,1) - qd(startTime:lengthTime,1)))
xlim([startTime startTime+lengthTime]*dt/60/60)
ylim([1e-15 2*1e1])
yticks([1e-15 1e-10 1e-5 1e0])
yticklabels({'1e-15','1e-10','1e-5','1e0'})
title('q1 (Actual - Desired)')

attitudeHandles.scQ2AD = subplot(4,2,4);
semilogy(attitudeHandles.scQ2AD, timeHours(startTime:lengthTime),...
    abs(stateS(startTime:lengthTime,2) - qd(startTime:lengthTime,2)))
xlim([startTime startTime+lengthTime]*dt/60/60)
ylim([1e-15 2*1e1])
yticks([1e-15 1e-10 1e-5 1e0])
yticklabels({'1e-15','1e-10','1e-5','1e0'})
title('q2 (Actual - Desired)')

attitudeHandles.scQ3AD = subplot(4,2,6);
semilogy(attitudeHandles.scQ3AD, timeHours(startTime:lengthTime),...
    abs(stateS(startTime:lengthTime,3) - qd(startTime:lengthTime,3)))
xlim([startTime startTime+lengthTime]*dt/60/60)
ylim([1e-15 2*1e1])
yticks([1e-15 1e-10 1e-5 1e0])
yticklabels({'1e-15','1e-10','1e-5','1e0'})
title('q3 (Actual - Desired)')

attitudeHandles.scQ4AD = subplot(4,2,8);
semilogy(attitudeHandles.scQ4AD, timeHours(startTime:lengthTime),...
    abs(stateS(startTime:lengthTime,4) - qd(startTime:lengthTime,4)))
xlim([startTime startTime+lengthTime]*dt/60/60)
ylim([1e-15 2*1e1])
yticks([1e-15 1e-10 1e-5 1e0])
yticklabels({'1e-15','1e-10','1e-5','1e0'})
title('q4 (Actual - Desired)')


%%% SPACECRAFT ANGULAR VELOCITY
scAngVelTab = uitab(attitudeTabgp,'Title','SC Angular Velocity');
axes(scAngVelTab);

attitudeHandles.scAngVelXAxes = subplot(3,1,1);
plot(timeHours(startTime:lengthTime), stateS(startTime:lengthTime,5))
hold(attitudeHandles.scAngVelXAxes,'on');
plot(timeHours(startTime:lengthTime), stateS(startTime:lengthTime,15))
xlim([startTime startTime+lengthTime]*dt/60/60)
xlabel('Time (hours)')
ylabel('Angular Velocity (rad/s)')
title('Satellite Angular Velocity X')
legend('Actual', 'Estimate')
hold(attitudeHandles.scAngVelXAxes,'off');

attitudeHandles.scAngVelYAxes = subplot(3,1,2);
plot(timeHours(startTime:lengthTime), stateS(startTime:lengthTime,6))
hold(attitudeHandles.scAngVelYAxes,'on');
plot(timeHours(startTime:lengthTime), stateS(startTime:lengthTime,16))
xlim([startTime startTime+lengthTime]*dt/60/60)
xlabel('Time (hours)')
ylabel('Angular Velocity (rad/s)')
title('Satellite Angular Velocity Y')
legend('Actual', 'Estimate')
hold(attitudeHandles.scAngVelYAxes,'off');

attitudeHandles.scAngVelZAxes = subplot(3,1,3);
plot(timeHours(startTime:lengthTime), stateS(startTime:lengthTime,7))
hold(attitudeHandles.scAngVelZAxes,'on');
plot(timeHours(startTime:lengthTime), stateS(startTime:lengthTime,17))
xlim([startTime startTime+lengthTime]*dt/60/60)
xlabel('Time (hours)')
ylabel('Angular Velocity (rad/s)')
title('Satellite Angular Velocity Z')
legend('Actual', 'Estimate')
hold(attitudeHandles.scAngVelZAxes,'off');


%%% REACTION WHEEL ANGULAR VELOCITY
rwAngVelTab = uitab(attitudeTabgp,'Title','RW Angular Velocity');
axes(rwAngVelTab);

attitudeHandles.rwAngVelXAxes = subplot(3,1,1);
plot(timeHours(startTime:lengthTime), stateS(startTime:lengthTime,8))
hold(attitudeHandles.rwAngVelXAxes,'on');
plot(timeHours(startTime:lengthTime), stateS(startTime:lengthTime,18))
xlim([startTime startTime+lengthTime]*dt/60/60)
title('Reaction Wheel X')
xlabel('Time (hours)')
ylabel('Angular Velocity (rad/s)')
title('Reaction Wheel X Angular Velocity')
legend('Actual','Estimate')
hold(attitudeHandles.rwAngVelXAxes,'off');

attitudeHandles.rwAngVelYAxes = subplot(3,1,2);
plot(timeHours(startTime:lengthTime), stateS(startTime:lengthTime,9))
hold(attitudeHandles.rwAngVelYAxes,'on');
plot(timeHours(startTime:lengthTime), stateS(startTime:lengthTime,19))
xlim([startTime startTime+lengthTime]*dt/60/60)
title('Reaction Wheel Y')
xlabel('Time (hours)')
ylabel('Angular Velocity (rad/s)')
title('Reaction Wheel Y Angular Velocity')
legend('Actual','Estimate')
hold(attitudeHandles.rwAngVelYAxes,'off');

attitudeHandles.rwAngVelZAxes = subplot(3,1,3);
plot(timeHours(startTime:lengthTime), stateS(startTime:lengthTime,10))
hold(attitudeHandles.rwAngVelZAxes,'on');
plot(timeHours(startTime:lengthTime), stateS(startTime:lengthTime,20))
xlim([startTime startTime+lengthTime]*dt/60/60)
title('Reaction Wheel Z')
xlabel('Time (hours)')
ylabel('Angular Velocity (rad/s)')
title('Reaction Wheel Z Angular Velocity')
legend('Actual','Estimate')
hold(attitudeHandles.rwAngVelZAxes,'off');


%%% MAGNETIC FIELD
magFieldTab = uitab(attitudeTabgp,'Title','Magnetic Field');
magFieldAxes = axes(magFieldTab);

plot(magFieldAxes, timeHours(startTime:lengthTime),...
    satelliteModel.attitudeSystem.magnetorquer.magneticField(startTime:lengthTime,:))
xlim([startTime startTime+lengthTime]*dt/60/60)
xlabel('Time (hours)')
ylabel('Magnetic Field (nT)')
attitudeHandles.magField = gca;

end