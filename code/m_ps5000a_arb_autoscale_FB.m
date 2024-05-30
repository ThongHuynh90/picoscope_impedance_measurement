function [ wf,Vtx,error ] = m_ps5000a_arb_autoscale_FB(Vin,fs_Vin,Vmax_mV,varargin)
%% [ wf,Vtx,error ]  = m_ps5000a_arb_autoscale_FB(Vin,fs_V1,Vmax_mV)
%m_ps5000a_save_wf_autoscale re-record until status is 0 : not overload or underload
%   wf is 1 or 2 column, corresponding to channel A and B , in mV
% FB is always on channel A
global ps5000aSetting;
status=1;
Vtx=50;
error=0;
V_lim=2000;
if nargin>3
    Vtx=min(varargin{1},V_lim);
end
    [wf]=m_ps5000a_arb_autoscale(Vin,fs_Vin,Vtx);
for i=1:100
%     Vmax_mVi=max(abs(wf(:,1)-wf(:,2)));%V1-V2
    Vmax_mVi=max(abs(wf(:,1)));% V1
    scale=abs(Vmax_mV)/Vmax_mVi;
    Vtx=scale*Vtx;
    if(abs(scale-1)<0.01 )
        break;
    end
    if ( Vmax_mVi>=200e3 || Vtx>V_lim || i>30)
        error=1
        break;
    end
        [wf]=m_ps5000a_arb_autoscale(Vin,fs_Vin,Vtx);
end

end

