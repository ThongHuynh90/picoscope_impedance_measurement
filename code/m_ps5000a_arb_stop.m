function  m_ps5000a_arb_stop()
global ps5000aDeviceObj;
sigGenGroupObj = get(ps5000aDeviceObj, 'Signalgenerator');
sigGenGroupObj = sigGenGroupObj(1);
invoke(sigGenGroupObj, 'setSigGenOff');
end

