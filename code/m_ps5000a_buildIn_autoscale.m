function [ wf ] = m_ps5000a_buildIn_autoscale(cycles,f0,pkToPkMv)
%% [ wf ] = m_ps5000a_buildIn_autoscale(cycles,f0,pkToPkMv)
%m_ps5000a_save_wf_autoscale re-record until status is 0 : not overload or underload
%   wf is 1 or 2 column, corresponding to channel A and B , in mV
global ps5000aSetting;
status=1;

while(status)
     [chA, chB ,status] = m_ps5000a_buildInGen(cycles,f0,pkToPkMv);
end

DC_remove=0;
if (DC_remove==1)
DCnoise=(chA(1:ps5000aSetting.preSampleNum));
chA=chA(ps5000aSetting.preSampleNum+1:end)-mean(DCnoise);
if(std(DCnoise)>1)
    disp('Warning: chA std > 1mV, too noisy');
end
DCnoise=(chB(1:ps5000aSetting.preSampleNum));
chB=chB(ps5000aSetting.preSampleNum+1:end)-mean(DCnoise);
if(std(DCnoise)>1)
    disp('Warning: chB std > 1mV, too noisy');
end
end
wf(:,1)=chA';
wf(:,2)=chB';
end

