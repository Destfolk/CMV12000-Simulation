create_clock -period 33.333 -name SPI_CLK -waveform {0.000 16.667} [get_ports SPI_CLK]
create_clock -period 3.3333 -name LVDS_CLK -waveform {0.000 1.6667} [get_ports LVDS_CLK]
