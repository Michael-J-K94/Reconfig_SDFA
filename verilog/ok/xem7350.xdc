############################################################################
# XEM7350 - Xilinx constraints file
#
# Pin mappings for the XEM7350.  Use this as a template and comment out 
# the pins that are not used in your design.  (By default, map will fail
# if this file contains constraints for signals not in your design).
#
# Copyright (c) 2004-2014 Opal Kelly Incorporated
############################################################################

set_property CFGBVS GND [current_design]
set_property CONFIG_VOLTAGE 1.8 [current_design]
set_property BITSTREAM.GENERAL.COMPRESS True [current_design]

############################################################################
## FrontPanel Host Interface
############################################################################
set_property PACKAGE_PIN F23 [get_ports {okHU[0]}]
set_property PACKAGE_PIN H23 [get_ports {okHU[1]}]
set_property PACKAGE_PIN J25 [get_ports {okHU[2]}]
set_property SLEW FAST [get_ports {okHU[*]}]
set_property IOSTANDARD LVCMOS18 [get_ports {okHU[*]}]

set_property PACKAGE_PIN F22 [get_ports {okUH[0]}]
set_property PACKAGE_PIN G24 [get_ports {okUH[1]}]
set_property PACKAGE_PIN J26 [get_ports {okUH[2]}]
set_property PACKAGE_PIN G26 [get_ports {okUH[3]}]
set_property PACKAGE_PIN C23 [get_ports {okUH[4]}]
set_property IOSTANDARD LVCMOS18 [get_ports {okUH[*]}]

set_property PACKAGE_PIN B21 [get_ports {okUHU[0]}]
set_property PACKAGE_PIN C21 [get_ports {okUHU[1]}]
set_property PACKAGE_PIN E22 [get_ports {okUHU[2]}]
set_property PACKAGE_PIN A20 [get_ports {okUHU[3]}]
set_property PACKAGE_PIN B20 [get_ports {okUHU[4]}]
set_property PACKAGE_PIN C22 [get_ports {okUHU[5]}]
set_property PACKAGE_PIN D21 [get_ports {okUHU[6]}]
set_property PACKAGE_PIN C24 [get_ports {okUHU[7]}]
set_property PACKAGE_PIN C26 [get_ports {okUHU[8]}]
set_property PACKAGE_PIN D26 [get_ports {okUHU[9]}]
set_property PACKAGE_PIN A24 [get_ports {okUHU[10]}]
set_property PACKAGE_PIN A23 [get_ports {okUHU[11]}]
set_property PACKAGE_PIN A22 [get_ports {okUHU[12]}]
set_property PACKAGE_PIN B22 [get_ports {okUHU[13]}]
set_property PACKAGE_PIN A25 [get_ports {okUHU[14]}]
set_property PACKAGE_PIN B24 [get_ports {okUHU[15]}]
set_property PACKAGE_PIN G21 [get_ports {okUHU[16]}]
set_property PACKAGE_PIN E23 [get_ports {okUHU[17]}]
set_property PACKAGE_PIN E21 [get_ports {okUHU[18]}]
set_property PACKAGE_PIN H22 [get_ports {okUHU[19]}]
set_property PACKAGE_PIN D23 [get_ports {okUHU[20]}]
set_property PACKAGE_PIN J21 [get_ports {okUHU[21]}]
set_property PACKAGE_PIN K22 [get_ports {okUHU[22]}]
set_property PACKAGE_PIN D24 [get_ports {okUHU[23]}]
set_property PACKAGE_PIN K23 [get_ports {okUHU[24]}]
set_property PACKAGE_PIN H24 [get_ports {okUHU[25]}]
set_property PACKAGE_PIN F24 [get_ports {okUHU[26]}]
set_property PACKAGE_PIN D25 [get_ports {okUHU[27]}]
set_property PACKAGE_PIN J24 [get_ports {okUHU[28]}]
set_property PACKAGE_PIN B26 [get_ports {okUHU[29]}]
set_property PACKAGE_PIN H26 [get_ports {okUHU[30]}]
set_property PACKAGE_PIN E26 [get_ports {okUHU[31]}]
set_property SLEW FAST [get_ports {okUHU[*]}]
set_property IOSTANDARD LVCMOS18 [get_ports {okUHU[*]}]

set_property PACKAGE_PIN R26 [get_ports {okAA}]
set_property IOSTANDARD LVCMOS33 [get_ports {okAA}]


create_clock -name okUH0 -period 9.920 [get_ports {okUH[0]}]
create_clock -name virt_okUH0 -period 9.920

set_clock_groups -name async-mmcm-user-virt -asynchronous -group {mmcm0_clk0} -group {virt_okUH0}

set_input_delay -add_delay -max -clock [get_clocks {virt_okUH0}]  8.000 [get_ports {okUH[*]}]
set_input_delay -add_delay -min -clock [get_clocks {virt_okUH0}]  0.000 [get_ports {okUH[*]}]

set_input_delay -add_delay -max -clock [get_clocks {virt_okUH0}]  8.000 [get_ports {okUHU[*]}]
set_input_delay -add_delay -min -clock [get_clocks {virt_okUH0}]  2.000 [get_ports {okUHU[*]}]

set_output_delay -add_delay -max -clock [get_clocks {okUH0}]  2.000 [get_ports {okHU[*]}]
set_output_delay -add_delay -min -clock [get_clocks {okUH0}]  -0.500 [get_ports {okHU[*]}]

set_output_delay -add_delay -max -clock [get_clocks {okUH0}]  2.000 [get_ports {okUHU[*]}]
set_output_delay -add_delay -min -clock [get_clocks {okUH0}]  -0.500 [get_ports {okUHU[*]}]


############################################################################
## System Clock
############################################################################
set_property IOSTANDARD LVDS [get_ports {sys_clkp}]
set_property PACKAGE_PIN AC4 [get_ports {sys_clkp}]

set_property IOSTANDARD LVDS [get_ports {sys_clkn}]
set_property PACKAGE_PIN AC3 [get_ports {sys_clkn}]

create_clock -name sys_clk -period 5 [get_ports sys_clkp]

############################################################################
## User Reset
############################################################################
set_property PACKAGE_PIN G22 [get_ports {reset}]
set_property IOSTANDARD LVCMOS18 [get_ports {reset}]
set_property SLEW FAST [get_ports {reset}]


# FMC-D11 
set_property PACKAGE_PIN C17 [get_ports {result_value[0]}]
# FMC-D12 
set_property PACKAGE_PIN C18 [get_ports {result_value[1]}]
# FMC-D14 
set_property PACKAGE_PIN L19 [get_ports {result_value[2]}]
# FMC-D15 
set_property PACKAGE_PIN L20 [get_ports {result_value[3]}]
# FMC-D17 
set_property PACKAGE_PIN E15 [get_ports {result_value[4]}]
# FMC-D18 
set_property PACKAGE_PIN E16 [get_ports {result_value[5]}]
# FMC-D23 
set_property PACKAGE_PIN F14 [get_ports {result_value[6]}]
# FMC-D24 
set_property PACKAGE_PIN F13 [get_ports {result_value[7]}]
# FMC-D26 
set_property PACKAGE_PIN C9 [get_ports {result_value[8]}]
# FMC-D27 
set_property PACKAGE_PIN B9 [get_ports {result_value[9]}]
# FMC-E10 
set_property PACKAGE_PIN AE26 [get_ports {data_in_t[3]}]
# FMC-E12 
set_property PACKAGE_PIN Y25 [get_ports {data_in_t[4]}]
# FMC-E13 
set_property PACKAGE_PIN Y26 [get_ports {data_in_t[5]}]
# FMC-E15 
set_property PACKAGE_PIN U26 [get_ports {data_in_t[6]}]
# FMC-E16 
set_property PACKAGE_PIN V26 [get_ports {data_in_t[7]}]
# FMC-E18 
set_property PACKAGE_PIN U22 [get_ports {data_in_t[8]}]
# FMC-E19 
set_property PACKAGE_PIN V22 [get_ports {data_in_t[9]}]
# FMC-E6 
set_property PACKAGE_PIN W23 [get_ports {data_in_t[0]}]
# FMC-E7 
set_property PACKAGE_PIN W24 [get_ports {data_in_t[1]}]
# FMC-E9 
set_property PACKAGE_PIN AD26 [get_ports {data_in_t[2]}]
# FMC-F10 
set_property PACKAGE_PIN AB26 [get_ports {data_in_t[24]}]
# FMC-F11 
set_property PACKAGE_PIN AC26 [get_ports {data_in_t[25]}]
# FMC-F13 
set_property PACKAGE_PIN W25 [get_ports {data_in_t[26]}]
# FMC-F14 
set_property PACKAGE_PIN W26 [get_ports {data_in_t[27]}]
# FMC-F16 
set_property PACKAGE_PIN U24 [get_ports {data_in_t[28]}]
# FMC-F17 
set_property PACKAGE_PIN U25 [get_ports {data_in_t[29]}]
# FMC-F19 
set_property PACKAGE_PIN AB21 [get_ports {data_in_t[30]}]
# FMC-F20 
set_property PACKAGE_PIN AC21 [get_ports {data_in_t[31]}]
# FMC-F4 
set_property PACKAGE_PIN Y22 [get_ports {clk}]
# FMC-F7 
set_property PACKAGE_PIN AF24 [get_ports {data_in_t[22]}]
# FMC-F8 
set_property PACKAGE_PIN AF25 [get_ports {data_in_t[23]}]
# FMC-G10 
set_property PACKAGE_PIN A19 [get_ports {data_in_t[10]}]
# FMC-G12 
set_property PACKAGE_PIN F19 [get_ports {data_in_t[11]}]
# FMC-G13 
set_property PACKAGE_PIN E20 [get_ports {data_in_t[12]}]
# FMC-G15 
set_property PACKAGE_PIN H19 [get_ports {data_in_t[13]}]
# FMC-G16 
set_property PACKAGE_PIN G20 [get_ports {data_in_t[14]}]
# FMC-G18 
set_property PACKAGE_PIN A9 [get_ports {data_in_t[15]}]
# FMC-G19 
set_property PACKAGE_PIN A8 [get_ports {data_in_t[16]}]
# FMC-G21 
set_property PACKAGE_PIN L17 [get_ports {data_in_t[17]}]
# FMC-G22 
set_property PACKAGE_PIN K18 [get_ports {data_in_t[18]}]
# FMC-G27 
set_property PACKAGE_PIN J15 [get_ports {data_in_t[19]}]
# FMC-G28 
set_property PACKAGE_PIN J16 [get_ports {data_in_t[20]}]
# FMC-G30 
set_property PACKAGE_PIN J13 [get_ports {data_in_t[21]}]
# FMC-G9 
set_property PACKAGE_PIN A18 [get_ports {rstn}]
# FMC-H10 
set_property PACKAGE_PIN D19 [get_ports {data_in_t[34]}]
# FMC-H11 
set_property PACKAGE_PIN D20 [get_ports {data_in_t[35]}]
# FMC-H13 
set_property PACKAGE_PIN J18 [get_ports {data_in_t[36]}]
# FMC-H14 
set_property PACKAGE_PIN J19 [get_ports {data_in_t[37]}]
# FMC-H16 
set_property PACKAGE_PIN C16 [get_ports {data_in_t[38]}]
# FMC-H17 
set_property PACKAGE_PIN B16 [get_ports {data_in_t[39]}]
# FMC-H19 
set_property PACKAGE_PIN K16 [get_ports {data_in_t[40]}]
# FMC-H20 
set_property PACKAGE_PIN K17 [get_ports {data_in_t[41]}]
# FMC-H22 
set_property PACKAGE_PIN M17 [get_ports {WEIGHT_IN_t[0]}]
# FMC-H23 
set_property PACKAGE_PIN L18 [get_ports {WEIGHT_IN_t[1]}]
# FMC-H25 
set_property PACKAGE_PIN G15 [get_ports {WEIGHT_IN_t[2]}]
# FMC-H26 
set_property PACKAGE_PIN F15 [get_ports {WEIGHT_IN_t[3]}]
# FMC-H28 
set_property PACKAGE_PIN H14 [get_ports {WEIGHT_IN_t[4]}]
# FMC-H29 
set_property PACKAGE_PIN G14 [get_ports {WEIGHT_IN_t[5]}]
# FMC-H31 
set_property PACKAGE_PIN G12 [get_ports {WEIGHT_IN_t[6]}]
# FMC-H32 
set_property PACKAGE_PIN F12 [get_ports {WEIGHT_IN_t[7]}]
# FMC-H34 
set_property PACKAGE_PIN G10 [get_ports {result_spike_valid}]
# FMC-H35 
set_property PACKAGE_PIN G9 [get_ports {image_req}]
# FMC-H37 
set_property PACKAGE_PIN H9 [get_ports {set_up_req}]
# FMC-H38 
set_property PACKAGE_PIN H8 [get_ports {W_REQUEST}]
# FMC-H7 
set_property PACKAGE_PIN G19 [get_ports {data_in_t[32]}]
# FMC-H8 
set_property PACKAGE_PIN F20 [get_ports {data_in_t[33]}]
# FMC-J10 
set_property PACKAGE_PIN AE25 [get_ports {data_in_t[45]}]
# FMC-J12 
set_property PACKAGE_PIN AA25 [get_ports {data_in_t[46]}]
# FMC-J13 
set_property PACKAGE_PIN AB25 [get_ports {data_in_t[47]}]
# FMC-J15 
set_property PACKAGE_PIN V23 [get_ports {data_in_t[48]}]
# FMC-J16 
set_property PACKAGE_PIN V24 [get_ports {data_in_t[49]}]
# FMC-J18 
set_property PACKAGE_PIN AD21 [get_ports {data_in_t[50]}]
# FMC-J19 
set_property PACKAGE_PIN AE21 [get_ports {data_in_t[51]}]
# FMC-J21 
set_property PACKAGE_PIN V21 [get_ports {data_in_t[52]}]
# FMC-J22 
set_property PACKAGE_PIN W21 [get_ports {data_in_t[53]}]
# FMC-J24 
set_property PACKAGE_PIN Y17 [get_ports {block_in_t}]
# FMC-J25 
set_property PACKAGE_PIN Y18 [get_ports {block_inf_valid_t}]
# FMC-J27 
set_property PACKAGE_PIN W15 [get_ports {master_in_t}]
# FMC-J28 
set_property PACKAGE_PIN W16 [get_ports {master_inf_valid_t}]
# FMC-J30 
set_property PACKAGE_PIN AA14 [get_ports {set_number_t}]
# FMC-J31 
set_property PACKAGE_PIN AA15 [get_ports {set_valid_t}]
# FMC-J33 
set_property PACKAGE_PIN AB19 [get_ports {train_t}]
# FMC-J34 
set_property PACKAGE_PIN AB20 [get_ports {W_VALID_t}]
# FMC-J36 
set_property PACKAGE_PIN AD20 [get_ports {pixel_valid_t}]
# FMC-J6 
set_property PACKAGE_PIN AD23 [get_ports {data_in_t[42]}]
# FMC-J7 
set_property PACKAGE_PIN AD24 [get_ports {data_in_t[43]}]
# FMC-J9 
set_property PACKAGE_PIN AD25 [get_ports {data_in_t[44]}]
# FMC-K10 
set_property PACKAGE_PIN AB22 [get_ports {data_in_t[56]}]
# FMC-K11 
set_property PACKAGE_PIN AC22 [get_ports {data_in_t[57]}]
# FMC-K13 
set_property PACKAGE_PIN AA23 [get_ports {data_in_t[58]}]
# FMC-K14 
set_property PACKAGE_PIN AB24 [get_ports {data_in_t[59]}]
# FMC-K19 
set_property PACKAGE_PIN AE22 [get_ports {data_in_t[60]}]
# FMC-K20 
set_property PACKAGE_PIN AF22 [get_ports {data_in_t[61]}]
# FMC-K22 
set_property PACKAGE_PIN W20 [get_ports {data_in_t[62]}]
# FMC-K23 
set_property PACKAGE_PIN Y21 [get_ports {data_in_t[63]}]
# FMC-K7 
set_property PACKAGE_PIN AE23 [get_ports {data_in_t[54]}]
# FMC-K8 
set_property PACKAGE_PIN AF23 [get_ports {data_in_t[55]}]
# LEDs #####################################################################
set_property PACKAGE_PIN T24 [get_ports {led[0]}]
set_property PACKAGE_PIN T25 [get_ports {led[1]}]
set_property PACKAGE_PIN R25 [get_ports {led[2]}]
set_property PACKAGE_PIN P26 [get_ports {led[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[*]}]

# Flash ####################################################################
set_property PACKAGE_PIN N17 [get_ports {spi_dq0}]
set_property PACKAGE_PIN N16 [get_ports {spi_c}]
set_property PACKAGE_PIN R16 [get_ports {spi_s}]
set_property PACKAGE_PIN U17 [get_ports {spi_dq1}]
set_property PACKAGE_PIN U16 [get_ports {spi_w_dq2}]
set_property PACKAGE_PIN T17 [get_ports {spi_hold_dq3}]
set_property IOSTANDARD LVCMOS33 [get_ports {spi_dq0}]
set_property IOSTANDARD LVCMOS33 [get_ports {spi_c}]
set_property IOSTANDARD LVCMOS33 [get_ports {spi_s}]
set_property IOSTANDARD LVCMOS33 [get_ports {spi_dq1}]
set_property IOSTANDARD LVCMOS33 [get_ports {spi_w_dq2}]
set_property IOSTANDARD LVCMOS33 [get_ports {spi_hold_dq3}]

# DRAM #####################################################################
set_property PACKAGE_PIN AD1 [get_ports {ddr3_dq[0]}]
set_property PACKAGE_PIN AE1 [get_ports {ddr3_dq[1]}]
set_property PACKAGE_PIN AE3 [get_ports {ddr3_dq[2]}]
set_property PACKAGE_PIN AE2 [get_ports {ddr3_dq[3]}]
set_property PACKAGE_PIN AE6 [get_ports {ddr3_dq[4]}]
set_property PACKAGE_PIN AE5 [get_ports {ddr3_dq[5]}]
set_property PACKAGE_PIN AF3 [get_ports {ddr3_dq[6]}]
set_property PACKAGE_PIN AF2 [get_ports {ddr3_dq[7]}]
set_property PACKAGE_PIN W11 [get_ports {ddr3_dq[8]}]
set_property PACKAGE_PIN V8  [get_ports {ddr3_dq[9]}]
set_property PACKAGE_PIN V7  [get_ports {ddr3_dq[10]}]
set_property PACKAGE_PIN Y8 [get_ports {ddr3_dq[11]}]
set_property PACKAGE_PIN Y7 [get_ports {ddr3_dq[12]}]
set_property PACKAGE_PIN Y11 [get_ports {ddr3_dq[13]}]
set_property PACKAGE_PIN Y10 [get_ports {ddr3_dq[14]}]
set_property PACKAGE_PIN V9 [get_ports {ddr3_dq[15]}]
set_property SLEW FAST [get_ports {ddr3_dq[*]}]
set_property IOSTANDARD SSTL15_T_DCI [get_ports {ddr3_dq[*]}]

set_property PACKAGE_PIN AC1 [get_ports {ddr3_addr[0]}]
set_property PACKAGE_PIN AB1 [get_ports {ddr3_addr[1]}]
set_property PACKAGE_PIN V1 [get_ports {ddr3_addr[2]}]
set_property PACKAGE_PIN V2 [get_ports {ddr3_addr[3]}]
set_property PACKAGE_PIN Y2 [get_ports {ddr3_addr[4]}]
set_property PACKAGE_PIN Y3 [get_ports {ddr3_addr[5]}]
set_property PACKAGE_PIN V4 [get_ports {ddr3_addr[6]}]
set_property PACKAGE_PIN V6 [get_ports {ddr3_addr[7]}]
set_property PACKAGE_PIN U7 [get_ports {ddr3_addr[8]}]
set_property PACKAGE_PIN W3 [get_ports {ddr3_addr[9]}]
set_property PACKAGE_PIN V3 [get_ports {ddr3_addr[10]}]
set_property PACKAGE_PIN U1 [get_ports {ddr3_addr[11]}]
set_property PACKAGE_PIN U2 [get_ports {ddr3_addr[12]}]
set_property PACKAGE_PIN U5 [get_ports {ddr3_addr[13]}]
set_property PACKAGE_PIN U6 [get_ports {ddr3_addr[14]}]
set_property SLEW FAST [get_ports {ddr3_addr[*]}]
set_property IOSTANDARD SSTL15 [get_ports {ddr3_addr[*]}]

set_property PACKAGE_PIN AB2 [get_ports {ddr3_ba[0]}]
set_property PACKAGE_PIN Y1 [get_ports {ddr3_ba[1]}]
set_property PACKAGE_PIN W1 [get_ports {ddr3_ba[2]}]
set_property SLEW FAST [get_ports {ddr3_ba[*]}]
set_property IOSTANDARD SSTL15 [get_ports {ddr3_ba[*]}]

set_property PACKAGE_PIN AC2 [get_ports {ddr3_ras_n}]
set_property SLEW FAST [get_ports {ddr3_ras_n}]
set_property IOSTANDARD SSTL15 [get_ports {ddr3_ras_n}]

set_property PACKAGE_PIN AA3 [get_ports {ddr3_cas_n}]
set_property SLEW FAST [get_ports {ddr3_cas_n}]
set_property IOSTANDARD SSTL15 [get_ports {ddr3_cas_n}]

set_property PACKAGE_PIN AA2 [get_ports {ddr3_we_n}]
set_property SLEW FAST [get_ports {ddr3_we_n}]
set_property IOSTANDARD SSTL15 [get_ports {ddr3_we_n}]

set_property PACKAGE_PIN AA4 [get_ports {ddr3_reset_n}]
set_property SLEW FAST [get_ports {ddr3_reset_n}]
set_property IOSTANDARD LVCMOS15 [get_ports {ddr3_reset_n}]

set_property PACKAGE_PIN AB5 [get_ports {ddr3_cke[0]}]
set_property SLEW FAST [get_ports {ddr3_cke[0]}]
set_property IOSTANDARD SSTL15 [get_ports {ddr3_cke[0]}]

set_property PACKAGE_PIN AB6 [get_ports {ddr3_odt[0]}]
set_property SLEW FAST [get_ports {ddr3_odt[0]}]
set_property IOSTANDARD SSTL15 [get_ports {ddr3_odt[0]}]

set_property PACKAGE_PIN AA5 [get_ports {ddr3_cs_n[0]}]
set_property SLEW FAST [get_ports {ddr3_cs_n[0]}]
set_property IOSTANDARD SSTL15 [get_ports {ddr3_cs_n[0]}]

set_property PACKAGE_PIN AD4 [get_ports {ddr3_dm[0]}]
set_property PACKAGE_PIN V11 [get_ports {ddr3_dm[1]}]
set_property SLEW FAST [get_ports {ddr3_dm[*]}]
set_property IOSTANDARD SSTL15 [get_ports {ddr3_dm[*]}]

set_property PACKAGE_PIN AF5 [get_ports {ddr3_dqs_p[0]}]
set_property PACKAGE_PIN AF4 [get_ports {ddr3_dqs_n[0]}]
set_property PACKAGE_PIN W10 [get_ports {ddr3_dqs_p[1]}]
set_property PACKAGE_PIN W9 [get_ports {ddr3_dqs_n[1]}]
set_property SLEW FAST [get_ports {ddr3_dqs*}]
set_property IOSTANDARD DIFF_SSTL15_T_DCI [get_ports {ddr3_dqs*}]

set_property PACKAGE_PIN W6 [get_ports {ddr3_ck_p[0]}]
set_property PACKAGE_PIN W5 [get_ports {ddr3_ck_n[0]}]
set_property SLEW FAST [get_ports {ddr3_ck*}]
set_property IOSTANDARD DIFF_SSTL15 [get_ports {ddr3_ck_*}]

# OnBoard 100Mhz MGTREFCLK #################################################
set_property PACKAGE_PIN K6 [get_ports {mgtrefclk_p}]
set_property PACKAGE_PIN K5 [get_ports {mgtrefclk_n}]

