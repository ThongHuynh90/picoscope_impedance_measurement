# Impedance measurement setup using PicoScope
## Driver installing
Requires Instrument Control Toolbox.
Add these folders to Matlab path:
- code
- picotech-picosdk-ps5000a-matlab-instrument-driver-7bd78ac
- picotech-picosdk-matlab-picoscope-support-toolbox-cebd652

Install Pico SDK for both 32bits and 64bits for Matlab 32-bit and Matlab 64-bit, regardless of the OS version (Tested on PicoSDK_32_10.6.13.97 ans PicoSDK_64_10.6.13.97), newer version may not work.

Base on the lowest frequency sweep (longest pulse length), adjust the sampling frequency (reduce for low freq) and buffer length (increase for low freq)
Change the generator buffer base on different Pico model at.
> code\m_ps5000a_arb.m :
> > N=49152; % for Picoscope 5244B/5444B
> > N=32768; % for Picoscope 5243B/5443B/5000D series
> > N=16384; % for Picoscope 5242B/5442B
## Setup requirement
1.	Device under test (DUT)
2.	Precision resistor of value much smaller than the DUT impedance
3.	Pulser for triggering the Picoscope
## Connection
 ![Connection](/asset/Connection.png)
