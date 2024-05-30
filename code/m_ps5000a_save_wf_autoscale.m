function [ wf ] = m_ps5000a_save_wf_autoscale()
%m_ps5000a_save_wf_autoscale re-record until status is 0 : not overload or underload 
%   wf is 1 or 2 column, corresponding to channel A and B , in mV
global ps5000aSetting;
status=1;
while(status)
     [ chA chB,status ] = m_ps5000a_save_wf();
end
if(ps5000aSetting.DC_remove)
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
% wf(:,2)=chB'/1.1133;
wf(:,2)=chB';
end

