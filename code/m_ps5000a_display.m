% figure();
% position=get(gcf,'Position');
% set(0,'defaultfigureposition',position);
   global ps5000aDeviceObj;
global ps5000aSetting;



rapidBlockGroupObj = get(ps5000aDeviceObj, 'Rapidblock');
rapidBlockGroupObj = rapidBlockGroupObj(1);

% Block specific properties and functions are located in the Instrument
% Driver's Block group.

blockGroupObj = get(ps5000aDeviceObj, 'Block');
blockGroupObj = blockGroupObj(1);


%% 
% This example uses the |runBlock()| function in order to collect a block of
% data - if other code needs to be executed while waiting for the device to
% indicate that it is ready, use the |ps5000aRunBlock()| function and poll
% the |ps5000aIsReady()| function until the device indicates that it has
% data available for retrieval.

% figure(1);
% subplot(1,2,1);
% ylim([-20 20]*10);
% hold on
% subplot(1,2,2);
% xlim([-1 20]);
% xticks(0:2:20);
% ylim([-40 0]);
% hold on
% firstrun=1;
% save_idx=0;
% %    p_spectrum_plot(eleA51_1/1000,125e6);
% % [aa,bb]= p_spectrum_plot(average_ch/1000,fs);
%   
% set(gcf,'currentchar',' ')
% subplot(1,2,1);
% % set(gca,'XLimMode','manual');
% set(gca,'YLimMode','manual');
figure
while 1  % which gets changed when key is pressed
    

% Capture the blocks of data:

% segmentIndex : 0 
invoke(blockGroupObj, 'runBlock', 0);

% Retrieve rapid block data values:



%% Obtain the number of captures

[~, numCaptures] = invoke(rapidBlockGroupObj, 'ps5000aGetNoOfCaptures');






[numSamples, overflow, chA, chB] = ...
    invoke(rapidBlockGroupObj, 'getRapidBlockData', ps5000aSetting.num_average, 1, 0);%getRapidBlockData(obj, numCaptures, ratio, ratioMode)

    if ps5000aSetting.chA.enabled == PicoConstants.TRUE
        average_ch=p_correlation_mean(chA);
    else
        average_ch=p_correlation_mean(chB);
    end
%     if firstrun==1
%         firstrun=0;
%     else
%    delete(aa);
%    delete(bb);
%     end
%     sensitive=0.2747;%V/MPa
plot(average_ch);
%    ylabel('MPa');
  ylabel('V');
%      ylim([-lim_range(channelSettings.range+1) lim_range(channelSettings.range+1)]/1e3);   
     drawnow;
 
end


