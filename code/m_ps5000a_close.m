function m_ps5000a_close()
global ps5000aDeviceObj
disconnect(ps5000aDeviceObj);

ps5000aDeviceObj=[];
clear ps5000aMethodinfo;
clear ps5000aStructs;
clear ps5000aEnuminfo;
clear ps5000aThunkLibName;
% clear ps5000aSetting;
clear ps5000aDeviceObj;
end