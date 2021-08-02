
# ANALYZER Signals

# LVDS_3 [BANK13_03] (non inverted)
set_property PACKAGE_PIN T5  [get_ports analyzer_p_n[7]]
set_property PACKAGE_PIN U5  [get_ports analyzer_p_n[6]]

# LVDS_2 [JX1_23] (non inverted)
set_property PACKAGE_PIN P15 [get_ports {analyzer_p_n[5]}]
set_property PACKAGE_PIN P16 [get_ports {analyzer_p_n[4]}]

# LVDS_1 [JX1_21] (non inverted)
set_property PACKAGE_PIN W18 [get_ports {analyzer_p_n[3]}]
set_property PACKAGE_PIN W19 [get_ports {analyzer_p_n[2]}]

# LVDS_0 [JX1_19] (non inverted)
set_property PACKAGE_PIN T17 [get_ports {analyzer_p_n[1]}]
set_property PACKAGE_PIN R18 [get_ports {analyzer_p_n[0]}]

set_property IOSTANDARD LVCMOS25 [get_ports analyzer_p_n*]
set_property DRIVE 12 [get_ports {analyzer_p_n*}]
set_property SLEW SLOW [get_ports {analyzer_p_n*}]

