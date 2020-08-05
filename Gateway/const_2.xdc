----------------------------------------------------------------------------
--CMV12000-Simulation
--const_2.vhd
--
--Apertus AXIOM Beta
--
--Copyright (C) 2020 Seif Eldeen Emad Abdalazeem
--Email: destfolk@gmail.com
----------------------------------------------------------------------------

create_clock -period 10.000 -name {ps7_stub_inst/FCLKCLK[0]} -waveform {0.000 5.000} [get_pins {ps7_stub_inst/PS7_inst/FCLKCLK[0]}]
