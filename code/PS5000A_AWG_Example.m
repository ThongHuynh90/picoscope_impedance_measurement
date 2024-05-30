%% Connection
% Gen to Ext trig to ChA
% triger is on Ext
% pressure is on ChA
%fgen=200e6

%%Prepare the waveform
m_ps5000a_connect;
% m_ps5000a_config;
% m_ps5000a_config;
% m_ps5000a_arb_config;

delay_ms=0;
Vp=10;%mV
pkToPkMv=Vp*2;
fs_V1=250e6;
load('D:\Box Sync\2018\W19-connect 2 channels\Measurement IvsV\No resistor\voltageV1.mat', 'V1_A49')

V1=V1_A49(1,1:end/2)/100;
% V1=ge_squarewave_genterate([0.1 1.5  -1.5 1.5  -1.5 1.5  -1.5 1.5  -1.5 1.5 -1.5 0.1],fs_V1,2e6);

fs=ps5000aSetting.fs;
[wf]=m_ps5000a_arb_autoscale(V1,fs_V1,pkToPkMv);
disp(['RangeA',num2str(ps5000aSetting.chA.lim_range(ps5000aSetting.chA.range+1)),' mV']);
disp(['RangeB',num2str(ps5000aSetting.chB.lim_range(ps5000aSetting.chB.range+1)),' mV']);

figure(1);

 m_spectrum_plot(V1,fs_V1,'log','Normalize');
%  figure(2);
 m_spectrum_plot(wf(:,1)/1000,fs,'log','Normalize');
%  figure(3)
  m_spectrum_plot(wf(:,2)/1000,fs,'log','Normalize');
%   m_ps5000a_close;