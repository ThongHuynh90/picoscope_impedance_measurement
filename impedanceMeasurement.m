% uiwait(msgbox('Connect chA to Vstack, chB to V_R'))
clear
m_ps5000a_connect
ps5000aSetting.num_average=16;
ps5000aSetting.resolution_bits=12;
ps5000aSetting.bufferLength=20000;
ps5000aSetting.trigger.threahold_mode = ps5000aEnuminfo.enPS5000AThresholdDirection.PS5000A_RISING;
ps5000aSetting.trigger.threahold_mv = 1000;
ps5000aSetting.DC_remove=1000;
ps5000aSetting.fsReduce=1; % 1: reduce by half
ps5000aSetting.trigger.delaysample=0;
R=10;
V_list=1;%V
fsweep=(0.1:1:10)*1e6;
cycles=5;
phaseshift=0;
ps5000aSetting.preSampleNum=0;
m_ps5000a_setting_update();
Vtx_array=[];Varray=[];
f=(0:ps5000aSetting.bufferLength/2)/(ps5000aSetting.bufferLength/2)*ps5000aSetting.fs/2;
Z=[];fplot=[];
for ci=1:length(cycles)
    raw_data=[];
    cal_data=[];
    for fi=1:length(fsweep)
        excitation=m_waveform(200e6,fsweep(fi),cycles(ci),1);
        vtx=20;
        for Vi=1:length(V_list)
            
            [ wf,vtx,error ]=m_ps5000a_arb_autoscale_FB(excitation,200e6,V_list(Vi)*100,vtx);
            Vtx_array(fi,Vi)=vtx;
         
            
            %     m_spectrum_plot(V1,ps5000aSetting.fs,'log','Normalize');
            raw_data(1,fi,Vi,Shift_i,:)=wf(:,1);
            raw_data(2,fi,Vi,Shift_i,:)=wf(:,2);
            cal_data.I(fi,Vi,Shift_i,:)=squeeze(wf(:,2)/100/R);
            cal_data.Vstack(fi,Vi,Shift_i,:)=squeeze((wf(:,1)-wf(:,2))/100);
            
            %% Data processing, can be done after the measurement also
            Vhat=ifftshift(fft(squeeze((wf(:,1)-wf(:,2))/100)));
            Vhat=Vhat(round(end/2):end);
            Ihat=ifftshift(fft(squeeze(wf(:,2)/100/R)));
            Ihat=Ihat(round(end/2):end);
            filterIndex=find(f>fsweep(fi)/2);
            Vhat=Vhat(filterIndex);
            Ihat=Ihat(filterIndex);
            ftemp=f(filterIndex);
            [~,maxpos]=max(abs(Vhat));
            Z(fi)=Vhat(maxpos)/Ihat(maxpos);
            %                 m_spectrum_plot(cal_data.I(fi,Vi,Shift_i,:),ps5000aSetting.fs,'log','');
            fplot(fi)=ftemp(maxpos)
            %                 excitationps=m_convert_fs(excitationps,200e6,ps5000aSetting.fs)';
            excitation(ps5000aSetting.bufferLength)=0;
            cal_data.ex(fi,Vi,Shift_i,:)=excitation;
            Varray(fi,Vi)=max(cal_data.Vstack(fi,Vi,1,:));
            figure(3)
            plot(fplot,abs(Z));
            drawnow
        end
    end
    %         figure(1)
    %         plot(Varray);
    %         figure(2)
    %         plot(Vtx_array);
    
    % figure(1)
    % plot(Vlong);hold on
end
%     fn=sprintf('%s_VI_%dcycles',cfig,cycles(ci));
% save(fn,'raw_data','cal_data','Vtx_array','-append');
%     save(fn,'raw_data','cal_data','Vtx_array');
m_ps5000a_close();
