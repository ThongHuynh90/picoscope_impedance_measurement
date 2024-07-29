# Impedance measurement using PicoScope

## Driver installing
Requires Instrument Control Toolbox.
Add these folders to Matlab path:
- code
- picotech-picosdk-ps5000a-matlab-instrument-driver-7bd78ac
- picotech-picosdk-matlab-picoscope-support-toolbox-cebd652

Install Pico SDK for both 32bits and 64bits for Matlab 32-bit and Matlab 64-bit, regardless of the OS version (Tested on PicoSDK_32_10.6.13.97 ans PicoSDK_64_10.6.13.97), newer version may not work.

Base on the lowest frequency sweep (longest pulse length), adjust the sampling frequency (reduce for low freq) and buffer length (increase for low freq)
Change the generator buffer base on different Pico model at *code\m_ps5000a_arb.m*

![Connection](/asset/BufferSize.png)


## Setup requirement
1.	Device under test (DUT)
2.	Precision resistor of value much smaller than the DUT impedance
3.	Pulser for triggering the Picoscope

## Connection
 ![Connection](/asset/Connection.png)

## Impedance measurement at different voltage levels
This code provides a ability to measure the impedance of devices under test under different voltage levels. This can be used to investigate the nonlinearity of devices, e.g. nonlinear impedance of ultrasound transducers,  at high voltage. A linear power amplifier is required for this functionality. 
