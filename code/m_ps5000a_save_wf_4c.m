function [chA chB chC chD status] = m_ps5000a_save_wf_4c()
%OSC_SAVE_WF
%   Save 1 waveform, no autoscale, no average.only channel A
%   status = 0:ok ; 1 overflow; -1 underflow
global ps5000aDeviceObj;
global ps5000aSetting;
blockGroupObj = get(ps5000aDeviceObj, 'Block');
blockGroupObj = blockGroupObj(1);
invoke(blockGroupObj, 'runBlock', 0);

rapidBlockGroupObj = get(ps5000aDeviceObj, 'Rapidblock');
rapidBlockGroupObj = rapidBlockGroupObj(1);
[numSamples, overflow, chA, chB, chC, chD] = ...
    invoke(rapidBlockGroupObj, 'getRapidBlockData', ps5000aSetting.num_average, 1, 0);%getRapidBlockData(obj, numCaptures, ratio, ratioMode)
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
if isempty(chA)
    chA=zeros([numSamples 1]);
else
    if(ps5000aSetting.corr==1)
        chA=p_correlation_mean(chA);
    else
        chA=mean(chA,2);
    end
end

if (isempty(chB))
    chB=zeros([numSamples 1]);
else
    if(ps5000aSetting.corr==1)
        chB=p_correlation_mean(chB);
    else
        chB=mean(chB,2);
    end
end
end
