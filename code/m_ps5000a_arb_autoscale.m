function [ wf ] = m_ps5000a_arb_autoscale(Vin,fs_Vin,V_peak_mV)
%% [ wf ] = m_ps5000a_arb_autoscale(Vin,fs_V1,pkToPkMv)
%m_ps5000a_save_wf_autoscale re-record until status is 0 : not overload or underload
%   wf is 1 or 2 column, corresponding to channel A and B , in mV
global ps5000aSetting;
status=1;

while(status)
    [chA,chB,status]=m_ps5000a_arb(Vin,fs_Vin,V_peak_mV);
end

if (ps5000aSetting.DC_remove==1)
    DCnoise=(chA(1:ps5000aSetting.preSampleNum));
    chA=chA(ps5000aSetting.preSampleNum+1:end)-mean(DCnoise);
    if(std(DCnoise)/max(abs(chA))>0.01)
        %     disp('Warning: chA std > 1%, too noisy');
    end
    DCnoise=(chB(1:ps5000aSetting.preSampleNum));
    chB=chB(ps5000aSetting.preSampleNum+1:end)-mean(DCnoise);
    if(std(DCnoise)/max(abs(chB))>0.01)
        %     disp('Warning: chB std > 1%, too noisy');
    end
end
wf(:,1)=chA';
wf(:,2)=chB';
end

