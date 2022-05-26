disp('Plotting...')

%%% PRELIMINARY INFORMATION
% TIME STUFF
duration = length(satelliteModel.time);
timeHours = (1:length(satelliteModel.time))*dt/60/60;
dt = satelliteModel.dt;


%%% MAIN FIGURE
f = figure('Name', 'Plots', 'Position', [100 100 1600 800]);
tabgp = uitabgroup(f, 'Position', [0.01,0.15, 0.99, 0.85]);


%%% PLOTTING FUNCTION CALLBACK
% ATTITUDE TAB
attitudeTab = uitab(tabgp,'Title','Attitude System');
attHandles = plotAttitudeSim(attitudeTab, satelliteModel, timeHours, 1, duration);

% POWER TAB
powerTab = uitab(tabgp,'Title','Power System');
powHandles = plotPowerSim(powerTab, satelliteModel, timeHours, 1, duration);

% COMMAND TAB
commandTab = uitab(tabgp,'Title','Command System');
comHandles = plotCommandSim(commandTab, satelliteModel, timeHours, 1, duration);


%%% UICONTROL
% SLIDERS AND TEXT
startTimeSlider = uicontrol('Parent',f,'Style','slider','Position',[30,30,600,30],...
    'value',1,'min',1,'max',duration); % NEED TO DEFINE THE CALLBACK AFTER OTHER SLIDER IS MADE
startTimeLabel = uicontrol('Parent',f,'Style','text',...
    'Position',[30,60,100,30], 'String','Start Time');

lengthTimeSlider = uicontrol('Parent',f,'Style','slider','Position',[830,30,600,30],...
    'value',duration,'min',1,'max',duration);
lengthTimeLabel = uicontrol('Parent',f,'Style','text',...
    'Position',[830,60,100,30], 'String','Length Time');

% CALLBACKS
startTimeSlider.Callback = {@startTimeSliderCallback, lengthTimeSlider, dt,...
        attHandles, powHandles, comHandles};
lengthTimeSlider.Callback = {@lengthTimeSliderCallback, startTimeSlider, dt,...
        attHandles, powHandles, comHandles};


%%% CALLBACK FUNCTIONS
function startTimeSliderCallback(slider1, eventData, slider2, dt,...
    attHandles, powHandles, comHandles) %#ok<INUSL>
startIndex = get(slider1, 'Value');
lengthIndex = get(slider2, 'Value');

disp([startIndex startIndex+lengthIndex].*dt/60/60)

attFn = fieldnames(attHandles);
for a = 1:numel(attFn)
    set(attHandles.(attFn{a}), 'XLim', [startIndex startIndex+lengthIndex].*dt/60/60)
end

powFn = fieldnames(powHandles);
for a = 1:numel(powFn)
    set(powHandles.(powFn{a}), 'XLim', [startIndex startIndex+lengthIndex].*dt/60/60)
end

comFn = fieldnames(comHandles);
for a = 1:numel(comFn)
    set(comHandles.(comFn{a}), 'XLim', [startIndex startIndex+lengthIndex].*dt/60/60)
end


end

function lengthTimeSliderCallback(slider1, eventData, slider2, dt,...
    attHandles, powHandles, comHandles) %#ok<INUSL>
lengthIndex = get(slider1, 'Value');
startIndex = get(slider2, 'Value');

disp([startIndex startIndex+lengthIndex].*dt/60/60)

attFn = fieldnames(attHandles);
for a = 1:numel(attFn)
    set(attHandles.(attFn{a}), 'XLim', [startIndex startIndex+lengthIndex].*dt/60/60)
end

powFn = fieldnames(powHandles);
for a = 1:numel(powFn)
    set(powHandles.(powFn{a}), 'XLim', [startIndex startIndex+lengthIndex].*dt/60/60)
end

comFn = fieldnames(comHandles);
for a = 1:numel(comFn)
    set(comHandles.(comFn{a}), 'XLim', [startIndex startIndex+lengthIndex].*dt/60/60)
end


end

