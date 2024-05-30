function m_ps5000a_setting_update()%% LOAD CONFIGURATION INFORMATION
%% m_ps5000a_config_fun(resolution_bits,ps5000aSetting.chA,ps5000aSetting.chB,ps5000aSetting.trigger)
%
global ps5000aSetting;
global ps5000aDeviceObj
lim_range=[10 20 50 100 200 500 1e3 2e3 5e3 10e3 20e3 50e3];

%% SET CHANNELS

% Default driver settings used - use ps5000aSetChannel to turn channels on
% or off and set voltage ranges, coupling, as well as analogue offset.

%% SET DEVICE RESOLUTION

% resolution : 12bits

[status, ~] = invoke(ps5000aDeviceObj, 'ps5000aSetDeviceResolution',ps5000aSetting.resolution_bits);


%% SET SIMPLE TRIGGER

% Channel     : 2 (PS5000A_CHANNEL_EXT)
% Threshold   : 500 (mV)
% Direction   : 2 (Rising)
% Delay       : 0
% Auto trigger: 0 (wait indefinitely)




% ps5000aSetting.trigger.delaysample,
triggerGroupObj = get(ps5000aDeviceObj, 'Trigger');
triggerGroupObj = triggerGroupObj(1);
set(triggerGroupObj, 'autoTriggerMs', ps5000aSetting.trigger.timeout);
set(triggerGroupObj, 'delay', ps5000aSetting.trigger.delaysample);
[status] = invoke(triggerGroupObj, 'setSimpleTrigger', ps5000aSetting.trigger.trig_source, ...
    ps5000aSetting.trigger.threahold_mv, ps5000aSetting.trigger.threahold_mode);

[status] = invoke(ps5000aDeviceObj, 'ps5000aSetChannel', ...
        ps5000aSetting.chA.channel, ps5000aSetting.chA.enabled, ...
        ps5000aSetting.chA.coupling, ps5000aSetting.chA.range, ...
        ps5000aSetting.chA.analogueOffset);
    [status] = invoke(ps5000aDeviceObj, 'ps5000aSetChannel', ...
        ps5000aSetting.chB.channel, ps5000aSetting.chB.enabled, ...
        ps5000aSetting.chB.coupling, ps5000aSetting.chB.range, ...
        ps5000aSetting.chB.analogueOffset);
%% SET UP RAPID BLOCK PARAMETERS AND CAPTURE DATA

% Configure number of memory segments, ideally a power of 2, query
% ps5000aGetMaxSegments to find the maximum number of segments for the
% device.

[status, nMaxSamples] = invoke(ps5000aDeviceObj, 'ps5000aMemorySegments', 64);

% Set number of captures - can be less than or equal to the number of
% segments.
rapidBlockGroupObj = get(ps5000aDeviceObj, 'Rapidblock');
rapidBlockGroupObj = rapidBlockGroupObj(1);

[status] = invoke(rapidBlockGroupObj, 'ps5000aSetNoOfCaptures', ps5000aSetting.num_average);

% Set number of samples to collect pre- and post-trigger. Ensure that the
% total does not exceeed nMaxSamples above.
set(ps5000aDeviceObj, 'numPreTriggerSamples', ps5000aSetting.preSampleNum);
set(ps5000aDeviceObj, 'numPostTriggerSamples',min(ps5000aSetting.bufferLength,49512));
%% GET TIMEBASE

% Use ps5000aGetTimebase or ps5000aGetTimebase2 to query the driver as to
% suitability of using a particular timebase index then set the 'timebase'
% property if required.

% timebase      : 4 (16ns at 12-bit resolution)
% segment index : 0
status=1;
timebase_num=0;
while(status)
    timebase_num=timebase_num+1;
[status, timeIntNs, ~] = invoke(ps5000aDeviceObj, 'ps5000aGetTimebase', timebase_num, 0);
end
if(ps5000aSetting.fsReduce)
    timebase_num=timebase_num+ps5000aSetting.fsReduce;
    [status, timeIntNs, ~] = invoke(ps5000aDeviceObj, 'ps5000aGetTimebase', timebase_num, 0);
end
% If status is ok, set the timebase property, otherwise query
% ps5000aGetTimebase with another timebase index. In the case above, the
% status code 0 is returned (PICO_OK).

set(ps5000aDeviceObj, 'timebase', timebase_num);
% timeIntNs
ps5000aSetting.fs=1/double(timeIntNs)*1e9;
end