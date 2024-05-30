function [chA, chB ,status] = m_ps5000a_buildInGen(cycles,f0,V_peak_mV)

global ps5000aDeviceObj;
global ps5000aSetting;
global ps5000aEnuminfo;
%% Start the AWG
% Configure property value(s).
% awgBufferSize = get(ps5000aDeviceObj, 'awgBufferSize');

%% METHOD 1 : specify N and L
% N=1024*5;
% L=3e-6;
% dt=L/N;
% fbase=1/L;
% t = linspace(0,L,N);
% f=2e6;
% y = normalise(sin(2*pi*f*t)).*gausswin(N)';

%% METHOD 2 : specify dt(fgen) and N
% fgen = 200e6;
% dt=1/fgen;
% N=2^nextpow2(length(wf));
% L=dt*N;
% fbase=1/L;
% % y=prepare_input(N);
% wf=m_convert_fs(wf,f0,fgen);
% wf=normalise(wf);
% if rms(wf*V_maxMv)>1000
%     disp('warning rms >1')
%     return
% end
% wf(N)=0;
set(ps5000aDeviceObj, 'startFrequency', f0);
set(ps5000aDeviceObj, 'stopFrequency', f0);

offsetMv = 0;
% pkToPkMv = 200;
increment = 0; % Hz
dwellTime = 0; % seconds
sweepType = ps5000aEnuminfo.enPS5000ASweepType.PS5000A_UP;
operation = PicoConstants.FALSE;
sweeps = 0;
triggerType = ps5000aEnuminfo.enPS5000ASigGenTrigType.PS5000A_SIGGEN_RISING;
%triggerSource = ps5000aEnuminfo.enPS5000ASigGenTrigSource.PS5000A_SIGGEN_SOFT_TRIG;
%extInThresholdMv = 0;
triggerSource = ps5000aEnuminfo.enPS5000ASigGenTrigSource.PS5000A_SIGGEN_EXT_IN;
extInThresholdMv = ps5000aSetting.trigger.threahold_mv;

% Call function
invoke(ps5000aDeviceObj, 'setSigGenBuiltIn', offsetMv, abs(V_peak_mV*2), ps5000aEnuminfo.enPS5000AWaveType.PS5000A_SINE, increment, dwellTime, ...
    sweepType, operation, cycles, sweeps, triggerType, triggerSource, extInThresholdMv);

%% CAPTURE DATA
% Capture a block of data:
% segment index: 0

invoke(ps5000aDeviceObj, 'ps5000aRunBlock', 0);

% Software trigger the AWG to output a single cycle of the waveform
i=0;
data_ready = 0;

% mpath=mfilename('fullpath');
% mpath=fileparts(mpath);
% cmd=sprintf('%s\\extenderSoftConsole.exe COM5',mpath);
while(data_ready == 0)
    % Wait for data to be collected
%     fprintf('Waiting for data...................\n');
% i=i+1;
% system(cmd);%need to use Nano board to create triggers
% invoke(ps5000aDeviceObj, 'ps5000aSigGenSoftwareControl', 1); %remove to change to soft trig

     [status, data_ready] = invoke(ps5000aDeviceObj, 'ps5000aIsReady');
end
% i

invoke(ps5000aDeviceObj, 'setSigGenOff');
[chA, chB, ~, ~, numSamples, overflow] = ...
    invoke(ps5000aDeviceObj, 'getRapidBlockData', ps5000aSetting.num_average, 1, 0);%getRapidBlockData(obj, numCaptures, ratio, ratioMode)
%
%  [status, times, timeUnits]   = ...
%     invoke(ps5000aDeviceObj, 'ps5000aGetValuesTriggerTimeOffsetBulk64', 0,63);%getRapidBlockData(obj, numCaptures, ratio, ratioMode);



 %% Check status NEW
status=0;
maxA=max(max(abs(chA)));
maxB=max(max(abs(chB)));

range_enum=(0:10);
lim=ps5000aSetting.chA.lim_range;

idxA=find((lim*0.9)>maxA,1);

if(ps5000aSetting.chA.range>range_enum(idxA))%can be decreased more
    status=-1;
    ps5000aSetting.chA.range=range_enum(idxA);
    invoke(ps5000aDeviceObj, 'ps5000aSetChannel', ...
            ps5000aSetting.chA.channel, ps5000aSetting.chA.enabled, ...
            ps5000aSetting.chA.coupling, ps5000aSetting.chA.range, ...
            ps5000aSetting.chA.analogueOffset);
        return;
end

if (ps5000aSetting.chB.enabled)

    idxB=find((lim*0.9)>maxB,1);
    if(ps5000aSetting.chB.range>range_enum(idxB))%can be decreased more
    status=-1;
    ps5000aSetting.chB.range=range_enum(idxB);
    invoke(ps5000aDeviceObj, 'ps5000aSetChannel', ...
            ps5000aSetting.chB.channel, ps5000aSetting.chB.enabled, ...
            ps5000aSetting.chB.coupling, ps5000aSetting.chB.range, ...
            ps5000aSetting.chB.analogueOffset);
        return;
    end
end


if(sum(overflow))
    
    if(maxA >(0.9*lim(find(range_enum==ps5000aSetting.chA.range))) && ~isempty(idxA)) % overflow but range can be increased
        status=1;
        ps5000aSetting.chA.range=range_enum(idxA);
        invoke(ps5000aDeviceObj, 'ps5000aSetChannel', ...
            ps5000aSetting.chA.channel, ps5000aSetting.chA.enabled, ...
            ps5000aSetting.chA.coupling, ps5000aSetting.chA.range, ...
            ps5000aSetting.chA.analogueOffset);
    elseif (maxA >(0.9*lim(find(range_enum==ps5000aSetting.chA.range))) && isempty(idxA)) % overflow but range can NOT be increased
        status=0;
    end
    

    if (ps5000aSetting.chB.enabled)
    if(maxB >(0.9*lim(find(range_enum==ps5000aSetting.chB.range)))&& ~isempty(idxB)) % overflow but range can be increased
        status=1;
        ps5000aSetting.chB.range=range_enum(idxB);
        invoke(ps5000aDeviceObj, 'ps5000aSetChannel', ...
            ps5000aSetting.chB.channel, ps5000aSetting.chB.enabled, ...
            ps5000aSetting.chB.coupling, ps5000aSetting.chB.range, ...
            ps5000aSetting.chB.analogueOffset);
        elseif (maxB >(0.9*lim(find(range_enum==ps5000aSetting.chB.range))) && isempty(idxB)) % overflow but range can NOT be increased
        status=0;
    end
    end
    
else
    
end















 %% Check status BK
% status=0;
% maxA=max(max(abs(chA)));
% maxB=max(max(abs(chB)));
% 
% if( ps5000aSetting.chA.range>=2)
%     if(maxA<(0.9*ps5000aSetting.chA.lim_range(ps5000aSetting.chA.range-1)))
%         status=-1;
%         ps5000aSetting.chA.range=ps5000aSetting.chA.range-1;
%         invoke(ps5000aDeviceObj, 'ps5000aSetChannel', ...
%             ps5000aSetting.chA.channel, ps5000aSetting.chA.enabled, ...
%             ps5000aSetting.chA.coupling, ps5000aSetting.chA.range-1, ...
%             ps5000aSetting.chA.analogueOffset);
%     end
% end
% 
% if( ps5000aSetting.chB.enabled && ps5000aSetting.chB.range>=2)
%     if(maxB<(0.9*ps5000aSetting.chB.lim_range(ps5000aSetting.chB.range-1)))
%         status=-1;
%         ps5000aSetting.chB.range=ps5000aSetting.chB.range-1;
%         invoke(ps5000aDeviceObj, 'ps5000aSetChannel', ...
%             ps5000aSetting.chB.channel, ps5000aSetting.chB.enabled, ...
%             ps5000aSetting.chB.coupling, ps5000aSetting.chB.range-1, ...
%             ps5000aSetting.chB.analogueOffset);
%     end
% end
% 
% if(sum(overflow))
% if(maxA >(0.9*ps5000aSetting.chA.lim_range(ps5000aSetting.chA.range)) && ps5000aSetting.chA.range<11) % overflow but range can be increased
%     status=1;
%     ps5000aSetting.chA.range=ps5000aSetting.chA.range+1;
%     invoke(ps5000aDeviceObj, 'ps5000aSetChannel', ...
%         ps5000aSetting.chA.channel, ps5000aSetting.chA.enabled, ...
%         ps5000aSetting.chA.coupling, ps5000aSetting.chA.range-1, ...
%         ps5000aSetting.chA.analogueOffset);
% elseif (maxA >(0.9*ps5000aSetting.chA.lim_range(ps5000aSetting.chA.range)) && ps5000aSetting.chA.range>=11) % overflow but range can NOT be increased
%     status=0;
% end
% if (ps5000aSetting.chB.enabled)
% if(maxB >(0.9*ps5000aSetting.chB.lim_range(ps5000aSetting.chB.range)) && ps5000aSetting.chB.range<11) % overflow but range can be increased
%     status=1;
%     ps5000aSetting.chB.range=ps5000aSetting.chB.range+1;
%     invoke(ps5000aDeviceObj, 'ps5000aSetChannel', ...
%         ps5000aSetting.chB.channel, ps5000aSetting.chB.enabled, ...
%         ps5000aSetting.chB.coupling, ps5000aSetting.chB.range-1, ...
%         ps5000aSetting.chB.analogueOffset);
%     elseif (maxB >(0.9*ps5000aSetting.chB.lim_range(ps5000aSetting.chB.range)) && ps5000aSetting.chB.range>=11) % overflow but range can NOT be increased
%     status=0;
% end
% end
% end


if isempty(chA)
   chA=zeros([numSamples 1]);
else
    chA=p_correlation_mean(chA);
end

if (isempty(chB))
    chB=zeros([numSamples 1]);
else
    chB=p_correlation_mean(chB);
end
end