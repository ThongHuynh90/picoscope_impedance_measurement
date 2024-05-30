m_ps5000a_connect;
ex = m_waveform(200e6, 2e6, 5, 1);
m_ps5000a_arb_create(ex,200e6,500);
pause (10);
m_ps5000a_arb_stop;
m_ps5000a_close;
