%% Connection
% Any triger generator to ext.Trig of the pico scope. AWG and chA are
% trigged on it
% Gen to Ext trig to ChA
% triger is on Ext, rising
% pressure is on ChA
%fgen=200e6

%%Prepare the waveform
m_ps5000a_connect;
ps5000aSetting.trigger.delaysample=0;
m_ps5000a_setting_update();
% m_ps5000a_config;
% m_ps5000a_arb_config;

ex = m_waveform(200e6, 2e6, 5, 1);
% load('D:\Box Sync\2018\W19-connect 2 channels\Measurement IvsV\No resistor\voltageV1.mat', 'V1_A49')

% V1=V1_A49(1,1:end/2)/100;
% V1=ge_squarewave_genterate([0.1 1.5  -1.5 1.5  -1.5 1.5  -1.5 1.5  -1.5 1.5 -1.5 0.1],fs_V1,2e6);


[wf]=m_ps5000a_arb_autoscale(ex,200e6,100);
% 
% figure(1);
% 
%  m_spectrum_plot(V1,fs_V1,'log','Normalize');
%  figure(2);
 m_spectrum_plot(wf(:,1),ps5000aSetting.fs,'log','Normalize');
%   m_spectrum_plot(wf(:,2)/1000,fs,'log','Normalize');
  m_ps5000a_close;