global ps5000aMethodinfo;
global ps5000aStructs;
global ps5000aEnuminfo;
global ps5000aThunkLibName;
PS5000aConfig;
global ps5000aSetting
global ps5000aDeviceObj
%% DEVICE CONNECTION


% Create a device object. 
if(isempty(ps5000aDeviceObj))
    ps5000aDeviceObj = icdevice('picotech_ps5000a_generic.mdd');
    connect(ps5000aDeviceObj);
end


% Connect device object to hardware.


lim_range=[10 20 50 100 200 500 1e3 2e3 5e3 10e3 20e3];
ps5000aSetting.chA.channel = ps5000aEnuminfo.enPS5000AChannel.PS5000A_CHANNEL_A;
ps5000aSetting.chA.enabled = PicoConstants.TRUE;
ps5000aSetting.chA.coupling = ps5000aEnuminfo.enPS5000ACoupling.PS5000A_AC;
ps5000aSetting.chA.range = ps5000aEnuminfo.enPS5000ARange.PS5000A_20V;
ps5000aSetting.chA.analogueOffset = 0.0;
ps5000aSetting.chA.lim_range=lim_range;
ps5000aSetting.num_average=8;
ps5000aSetting.bufferLength=5000;
ps5000aSetting.preSampleNum=1000;
% ps5000aSetting.HydrophoneSN=2096;
ps5000aSetting.corr=1;

ps5000aSetting.chB.channel = ps5000aEnuminfo.enPS5000AChannel.PS5000A_CHANNEL_B;
ps5000aSetting.chB.enabled = PicoConstants.TRUE;
ps5000aSetting.chB.coupling = ps5000aEnuminfo.enPS5000ACoupling.PS5000A_AC;
ps5000aSetting.chB.range = ps5000aEnuminfo.enPS5000ARange.PS5000A_10V;
ps5000aSetting.chB.analogueOffset = 0.0;
ps5000aSetting.chB.lim_range=lim_range;

clear lim_range;

ps5000aSetting.trigger.trig_source =  ps5000aEnuminfo.enPS5000AChannel.PS5000A_EXTERNAL;
ps5000aSetting.trigger.threahold_mode = ps5000aEnuminfo.enPS5000AThresholdDirection.PS5000A_RISING;
ps5000aSetting.trigger.threahold_mv = 1000;
ps5000aSetting.trigger.delaysample=0;
ps5000aSetting.trigger.timeout=0;

ps5000aSetting.resolution_bits =12;
ps5000aSetting.DC_remove=1;
ps5000aSetting.fsReduce=0; % 0: no reduce; 1: reduce by half; % 2: reduce by 1/4
m_ps5000a_setting_update();


