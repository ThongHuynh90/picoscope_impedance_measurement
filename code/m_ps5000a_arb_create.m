function  m_ps5000a_arb_create(wf,fs_wf,V_maxMv)

global ps5000aDeviceObj;
global ps5000aSetting;
global ps5000aEnuminfo;

%% METHOD 3 : specify dt(fgen) and N
fgen = 200e6;
dt=1/fgen;
N=49152;
L=dt*N;
fbase=1/L;
% y=prepare_input(N);
wf=m_convert_fs(wf,fs_wf,fgen);
wf=normalise(wf);
wf(N)=0;
if rms(wf*V_maxMv)>1000
    disp('warning rms >1')
    return
end
wf(N)=0;
sigGenGroupObj = get(ps5000aDeviceObj, 'Signalgenerator');
sigGenGroupObj = sigGenGroupObj(1);
set(sigGenGroupObj, 'startFrequency', fbase);
set(sigGenGroupObj, 'stopFrequency', fbase);
offsetMv = 0;
set(sigGenGroupObj, 'offsetVoltage',offsetMv);
set(sigGenGroupObj, 'peakToPeakVoltage', 2*abs(V_maxMv));


% pkToPkMv = 200;
increment = 0; % Hz
dwellTime = 1; % seconds
sweepType 			= ps5000aEnuminfo.enPS5000ASweepType.PS5000A_UP;
operation 			= ps5000aEnuminfo.enPS5000AExtraOperations.PS5000A_ES_OFF;
indexMode 			= ps5000aEnuminfo.enPS5000AIndexMode.PS5000A_SINGLE;
shots = 1;
sweeps = 0;
triggerType = ps5000aEnuminfo.enPS5000ASigGenTrigType.PS5000A_SIGGEN_RISING;
%triggerSource = ps5000aEnuminfo.enPS5000ASigGenTrigSource.PS5000A_SIGGEN_SOFT_TRIG;
%extInThresholdMv = 0;
triggerSource = ps5000aEnuminfo.enPS5000ASigGenTrigSource.PS5000A_SIGGEN_EXT_IN;
extInThresholdMv = ps5000aSetting.trigger.threahold_mv;

% Call function
invoke(sigGenGroupObj, 'setSigGenArbitrary', ...
    increment, dwellTime, ...
    wf*sign(V_maxMv), sweepType, operation, indexMode, shots, sweeps, triggerType, triggerSource, extInThresholdMv);




end








