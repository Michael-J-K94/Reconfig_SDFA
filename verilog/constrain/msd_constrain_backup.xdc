#create_clock -period 10.000 -name clk -waveform {0.000 5.000} [get_ports clk]

########################################################################################
#                                                                                      #
#                                                                                      #
#                                 Signal Inputs                                        #
#                                                                                      #
#                                                                                      #
########################################################################################

#Resetn mapping
set_property PACKAGE_PIN M20 [get_ports resetn] # G9
set_property IOSTANDARD LVCMOS18 [get_ports resetn]

#LED mapping
#set_property PACKAGE_PIN L2 [get_ports {led[0]}]
#set_property PACKAGE_PIN K2 [get_ports {led[1]}]
#set_property PACKAGE_PIN J5 [get_ports {led[2]}]
#set_property PACKAGE_PIN L4 [get_ports {led[3]}]
#set_property PACKAGE_PIN K1 [get_ports {led[4]}]
#set_property PACKAGE_PIN J1 [get_ports {led[5]}]
#set_property PACKAGE_PIN K3 [get_ports {led[6]}]
#set_property PACKAGE_PIN J3 [get_ports {led[7]}]
#set_property IOSTANDARD LVCMOS18 [get_ports {led[*]}]

#data_in mapping
set_property PACKAGE_PIN E36 [get_ports {data_in[0]}] # E6
set_property PACKAGE_PIN E37 [get_ports {data_in[1]}] # E7
set_property PACKAGE_PIN A37 [get_ports {data_in[2]}] # E19
set_property PACKAGE_PIN A38 [get_ports {data_in[3]}] # E10
set_property PACKAGE_PIN F38 [get_ports {data_in[4]}] # E12
set_property PACKAGE_PIN F39 [get_ports {data_in[5]}] # E13
set_property PACKAGE_PIN C37 [get_ports {data_in[6]}] # E15
set_property PACKAGE_PIN B37 [get_ports {data_in[7]}] # E16
set_property PACKAGE_PIN B41 [get_ports {data_in[8]}] # E18
set_property PACKAGE_PIN A42 [get_ports {data_in[9]}] # E19
set_property PACKAGE_PIN L20 [get_ports {data_in[10]}] # G10
set_property PACKAGE_PIN P19 [get_ports {data_in[11]}] # G12
set_property PACKAGE_PIN N19 [get_ports {data_in[12]}] # G13
set_property PACKAGE_PIN M19 [get_ports {data_in[13]}] # G15
set_property PACKAGE_PIN L19 [get_ports {data_in[14]}] # G16
set_property PACKAGE_PIN L18 [get_ports {data_in[15]}] # G18
set_property PACKAGE_PIN K18 [get_ports {data_in[16]}] # G19
set_property PACKAGE_PIN L17 [get_ports {data_in[17]}] # G21
set_property PACKAGE_PIN K17 [get_ports {data_in[18]}] # G22
set_property PACKAGE_PIN K16 [get_ports {data_in[19]}] # G27
set_property PACKAGE_PIN J16 [get_ports {data_in[20]}] # G28
set_property PACKAGE_PIN K15 [get_ports {data_in[21]}] # G30
set_property PACKAGE_PIN B39 [get_ports {data_in[22]}] # F7
set_property PACKAGE_PIN B40 [get_ports {data_in[23]}] # F8
set_property PACKAGE_PIN C42 [get_ports {data_in[24]}] # F10
set_property PACKAGE_PIN B42 [get_ports {data_in[25]}] # F11
set_property PACKAGE_PIN A39 [get_ports {data_in[26]}] # F13
set_property PACKAGE_PIN A40 [get_ports {data_in[27]}] # F14
set_property PACKAGE_PIN F40 [get_ports {data_in[28]}] # F16
set_property PACKAGE_PIN E40 [get_ports {data_in[29]}] # F17
set_property PACKAGE_PIN E41 [get_ports {data_in[30]}] # F19
set_property PACKAGE_PIN E42 [get_ports {data_in[31]}] # F20
set_property PACKAGE_PIN G21 [get_ports {data_in[32]}] # H7
set_property PACKAGE_PIN G20 [get_ports {data_in[33]}] # H8
set_property PACKAGE_PIN K20 [get_ports {data_in[34]}] # H10
set_property PACKAGE_PIN J20 [get_ports {data_in[35]}] # H11
set_property PACKAGE_PIN J19 [get_ports {data_in[36]}] # H13
set_property PACKAGE_PIN H19 [get_ports {data_in[37]}] # H14
set_property PACKAGE_PIN J18 [get_ports {data_in[38]}] # H16
set_property PACKAGE_PIN H18 [get_ports {data_in[39]}] # H17
set_property PACKAGE_PIN F18 [get_ports {data_in[40]}] # H19
set_property PACKAGE_PIN E18 [get_ports {data_in[41]}] # H20
set_property PACKAGE_PIN E21 [get_ports {data_in[42]}] # J6
set_property PACKAGE_PIN D21 [get_ports {data_in[43]}] # J7
set_property PACKAGE_PIN C21 [get_ports {data_in[44]}] # J9
set_property PACKAGE_PIN B21 [get_ports {data_in[45]}] # J10
set_property PACKAGE_PIN C19 [get_ports {data_in[46]}] # J12
set_property PACKAGE_PIN B19 [get_ports {data_in[47]}] # J13
set_property PACKAGE_PIN D18 [get_ports {data_in[48]}] # J15
set_property PACKAGE_PIN C18 [get_ports {data_in[49]}] # J16
set_property PACKAGE_PIN C17 [get_ports {data_in[50]}] # J18
set_property PACKAGE_PIN C16 [get_ports {data_in[51]}] # J19
set_property PACKAGE_PIN B16 [get_ports {data_in[52]}] # J21
set_property PACKAGE_PIN B15 [get_ports {data_in[53]}] # J22
set_property PACKAGE_PIN B20 [get_ports {data_in[54]}] # K7
set_property PACKAGE_PIN A20 [get_ports {data_in[55]}] # K8
set_property PACKAGE_PIN A19 [get_ports {data_in[56]}] # K10
set_property PACKAGE_PIN A18 [get_ports {data_in[57]}] # K11
set_property PACKAGE_PIN B17 [get_ports {data_in[58]}] # K13
set_property PACKAGE_PIN A17 [get_ports {data_in[59]}] # K14
set_property PACKAGE_PIN A15 [get_ports {data_in[60]}] # K19
set_property PACKAGE_PIN A14 [get_ports {data_in[61]}] # K20
set_property PACKAGE_PIN B14 [get_ports {data_in[62]}] # K22
set_property PACKAGE_PIN A13 [get_ports {data_in[63]}] # K23

set_property IOSTANDARD LVCMOS18 [get_ports {data_in[*]}]

set_property PACKAGE_PIN B12 [get_ports {block_in}] # J24
set_property IOSTANDARD LVCMOS18 [get_ports {block_in}]

set_property PACKAGE_PIN A12 [get_ports {block_inf_valid}] # J25
set_property IOSTANDARD LVCMOS18 [get_ports {block_inf_valid}]

set_property PACKAGE_PIN B11 [get_ports {master_in}] # J27
set_property IOSTANDARD LVCMOS18 [get_ports {master_in}]

set_property PACKAGE_PIN B10 [get_ports {master_inf_valid}] # J28
set_property IOSTANDARD LVCMOS18 [get_ports {master_inf_valid}]


#set_property PACKAGE_PIN M15 [get_ports {label0[0]}] # G33
#set_property PACKAGE_PIN L14 [get_ports {label0[1]}] # G34
#set_property PACKAGE_PIN N14 [get_ports {label0[2]}] # G36
#set_property PACKAGE_PIN M14 [get_ports {label0[3]}] # G37
#set_property IOSTANDARD LVCMOS18 [get_ports {label0[*]}]

set_property PACKAGE_PIN G9 [get_ports {pixel_valid}] # J36
set_property IOSTANDARD LVCMOS18 [get_ports {pixel_valid}]

set_property PACKAGE_PIN E10 [get_ports {set_number}] # J30
set_property IOSTANDARD LVCMOS18 [get_ports {set_number}]

set_property PACKAGE_PIN D10 [get_ports {set_valid}] # J31
set_property IOSTANDARD LVCMOS18 [get_ports {set_valid}]

set_property PACKAGE_PIN F12 [get_ports {train}] # J33
set_property IOSTANDARD LVCMOS18 [get_ports {train}]

set_property PACKAGE_PIN H17 [get_ports {WEIGHT_IN[0]}] # H22
set_property PACKAGE_PIN G17 [get_ports {WEIGHT_IN[1]}] # H23
set_property PACKAGE_PIN H16 [get_ports {WEIGHT_IN[2]}] # H25
set_property PACKAGE_PIN G16 [get_ports {WEIGHT_IN[3]}] # H26
set_property PACKAGE_PIN G15 [get_ports {WEIGHT_IN[4]}] # H28
set_property PACKAGE_PIN G14 [get_ports {WEIGHT_IN[5]}] # H29
set_property PACKAGE_PIN J14 [get_ports {WEIGHT_IN[6]}] # H31
set_property PACKAGE_PIN H14 [get_ports {WEIGHT_IN[7]}] # H32
set_property IOSTANDARD LVCMOS18 [get_ports {WEIGHT_IN[*]}]

set_property PACKAGE_PIN E12 [get_ports {W_VALID}] # J34
set_property IOSTANDARD LVCMOS18 [get_ports {W_VALID}]


########################################################################################
#                                                                                      #
#                                                                                      #
#                                 Signal Outputs                                       #
#                                                                                      #
#                                                                                      #
########################################################################################


set_property PACKAGE_PIN F13 [get_ports {image_req}] # H35
set_property IOSTANDARD LVCMOS18 [get_ports {image_req}]

set_property PACKAGE_PIN B34 [get_ports {result_value[0]}] # D11
set_property PACKAGE_PIN A34 [get_ports {result_value[1]}] # D12
set_property PACKAGE_PIN C36 [get_ports {result_value[2]}] # D14
set_property PACKAGE_PIN B36 [get_ports {result_value[3]}] # D15
set_property PACKAGE_PIN F35 [get_ports {result_value[4]}] # D17
set_property PACKAGE_PIN E35 [get_ports {result_value[5]}] # D18
set_property PACKAGE_PIN P18 [get_ports {result_value[6]}] # D23
set_property PACKAGE_PIN N18 [get_ports {result_value[7]}] # D24
set_property PACKAGE_PIN P15 [get_ports {result_value[8]}] # D26
set_property PACKAGE_PIN P14 [get_ports {result_value[9]}] # D27
set_property IOSTANDARD LVCMOS18 [get_ports {result_value[*]}]

set_property PACKAGE_PIN F14 [get_ports {result_spike_valid}] # H34
set_property IOSTANDARD LVCMOS18 [get_ports {result_spike_valid}]

set_property PACKAGE_PIN E13 [get_ports {set_up_req}] # H37
set_property IOSTANDARD LVCMOS18 [get_ports {set_up_req}]

set_property PACKAGE_PIN D13 [get_ports {W_REQUEST}] # H38
set_property IOSTANDARD LVCMOS18 [get_ports {W_REQUEST}]

#set_property PACKAGE_PIN A15 [get_ports {result_value[10]}] # K19
#set_property PACKAGE_PIN A14 [get_ports {result_value[11]}] # K20
#set_property PACKAGE_PIN B14 [get_ports {result_value[12]}] # K22
#set_property PACKAGE_PIN B20 [get_ports {result_value[13]}] # K7

#Clock Mapping
#set_property IOSTANDARD LVDS [get_ports {sys_clkp}]
#set_property PACKAGE_PIN AB40 [get_ports {sys_clkp}]

#set_property IOSTANDARD LVDS [get_ports {sys_clkn}]
#set_property PACKAGE_PIN AA40 [get_ports {sys_clkn}]

#To Opal Kelly
create_clock -name clk_FPGA -period 10 [get_ports clk_FPGA]

set_property PACKAGE_PIN D39 [get_ports clk] # F4
set_property IOSTANDARD LVCMOS18 [get_ports clk]
