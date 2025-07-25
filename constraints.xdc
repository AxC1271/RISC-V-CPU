
set_property PACKAGE_PIN W5 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]
create_clock -period 10.0 -name sys_clk -waveform {0 5} [get_ports clk]


set_property PACKAGE_PIN R2 [get_ports rst]
set_property IOSTANDARD LVCMOS33 [get_ports rst]

foreach i {0 1 2 3 4 5 6} {
  set_property IOSTANDARD LVCMOS [get_ports{seg[$i]}]
}


set_property IOSTANDARD LVCMOS33 [get_ports{seg[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports{seg[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports{seg[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports{seg[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports{seg[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports{seg[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports{seg[6]}]


set_property PACKAGE_PIN U2 [get_ports {ade[0]}]
set_property PACKAGE_PIN U4 [get_ports {ade[1]}]
set_property PACKAGE_PIN V4 [get_ports {ade[2]}]
set_property PACKAGE_PIN W4 [get_ports {ade[3]}]

foreach i {0 1 2 3} {
  set_property IOSTANDARD LVCMOS33 [get_ports {ade[$i]}]
}


set_property PACKAGE_PIN L1 [get_ports {led[0]}]
set_property PACKAGE_PIN P1 [get_ports {led[1]}]
set_property PACKAGE_PIN N3 [get_ports {led[2]}]
set_property PACKAGE_PIN P3 [get_ports {led[3]}]
set_property PACKAGE_PIN U3 [get_ports {led[4]}]
set_property PACKAGE_PIN W3 [get_ports {led[5]}]
set_property PACKAGE_PIN V3 [get_ports {led[6]}]
set_property PACKAGE_PIN V13 [get_ports {led[7]}]
set_property PACKAGE_PIN V14 [get_ports {led[8]}]
set_property PACKAGE_PIN U14 [get_ports {led[9]}]
set_property PACKAGE_PIN U15 [get_ports {led[10]}]
set_property PACKAGE_PIN W18 [get_ports {led[11]}]
set_property PACKAGE_PIN V19 [get_ports {led[12]}]
set_property PACKAGE_PIN U19 [get_ports {led[13]}]
set_property PACKAGE_PIN E19 [get_ports {led[14]}]
set_property PACKAGE_PIN U16 [get_ports {led[15]}]

foreach i {0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15} {
    set_property IOSTANDARD LVCMOS33 [get_ports {led[$i]}]
}
