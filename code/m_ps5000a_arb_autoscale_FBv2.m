function [ wf,Vtx,error ] = m_ps5000a_arb_autoscale_FBv2(Vin,fs_Vin,Vmax_mV,varargin)
%%[ wf,Vtx,error ] = m_ps5000a_buildIn_autoscale_FB(cycles,f0,Vmax_mV,varargin)
%m_ps5000a_save_wf_autoscale re-record until status is 0 : not overload or underload
%   wf is 1 or 2 column, corresponding to channel A and B , in mV
% FB is always on channel A
%global ps5000aSetting;

Vtx=50;
error=0;

V_lim=2000;
if nargin>3
    Vtx=min(varargin{1},V_lim);
end
x1=0;
y1=0;
x2=Vtx;
[wf,y2 ] =p_cal(Vin,fs_Vin,x2);
watchdog=20;
while (abs(y2-Vmax_mV)/Vmax_mV>0.005)
    watchdog=watchdog-1;
    Vtx=(Vmax_mV-y1)/(y2-y1)*(x2-x1)+x1;
    x1=x2;
    x2=Vtx;
    y1=y2;
    if ( y2>=200e3 || Vtx>V_lim || watchdog<0)
        error=1
        break;
    end
    [wf,y2 ] =p_cal(Vin,fs_Vin,x2);
end


end
function [ wf,y2 ] =p_cal(Vin,fs_Vin,Vtx)

[wf]=m_ps5000a_arb_autoscale(Vin,fs_Vin,Vtx);
 y2=max(abs(wf(:,1)-wf(:,2)));%V1-V2
%     y2=max(abs(wf(:,1)));% V1

end
