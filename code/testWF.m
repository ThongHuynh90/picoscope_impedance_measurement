m_ps5000a_connect;

[ wf ] = m_ps5000a_save_wf_autoscale();
m_spectrum_plot(wf(:,1),ps5000aSetting.fs,'log','Normalize');
m_ps5000a_close;    