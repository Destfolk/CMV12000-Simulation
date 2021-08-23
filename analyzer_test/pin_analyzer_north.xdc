create_clock -period 100.000 -name clk_100 -waveform {0.000 50.000} [get_pins */PS7_inst/FCLKCLK[0]]
# ANALYZER Signals

# LVDS_3 [BANK13_03] (non inverted)
set_property PACKAGE_PIN T5  [get_ports analyzer_d[6]]
set_property PACKAGE_PIN U5  [get_ports analyzer_d[2]]

# LVDS_2 [JX1_23] (non inverted)
#set_property PACKAGE_PIN P15 [get_ports {analyzer_d[5]}]
set_property PACKAGE_PIN P16 [get_ports {analyzer_d[3]}]

# LVDS_1 [JX1_21] (non inverted)
#set_property PACKAGE_PIN W18 [get_ports {analyzer_d[3]}]
#set_property PACKAGE_PIN W19 [get_ports {analyzer_d[2]}]

# LVDS_0 [JX1_19] (non inverted)
#set_property PACKAGE_PIN T17 [get_ports {analyzer_d[1]}]
#set_property PACKAGE_PIN R18 [get_ports {analyzer_d[0]}]

# LVDS_5A [BANK13_00_P] #channel 5
set_property PACKAGE_PIN U7 [get_ports {analyzer_d[4]}] 

# LVDS_5B [BANK13_00_N]
set_property PACKAGE_PIN V7 [get_ports {analyzer_d[0]}]

# LVDS_4A [BANK13_02_N]
set_property PACKAGE_PIN W8 [get_ports {analyzer_d[5]}]

# LVDS_4B [BANK13_02_P]
set_property PACKAGE_PIN V8 [get_ports {analyzer_d[1]}]

set_property IOSTANDARD LVCMOS25 [get_ports {analyzer_d[*]}]
set_property DRIVE 12  [get_ports {analyzer_d[*]}]
set_property SLEW SLOW [get_ports {analyzer_d[*]}]

