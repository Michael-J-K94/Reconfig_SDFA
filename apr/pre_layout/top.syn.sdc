###################################################################

# Created by write_sdc on Mon Apr 30 12:57:41 2018

###################################################################
set sdc_version 2.0

set_units -time ns -resistance kOhm -capacitance pF -voltage V -current mA
set_operating_conditions NCCOM -library tcbn65lptc
set_wire_load_mode segmented
set_max_fanout 16 [current_design]
set_max_transition 0.49 [current_design]
set_wire_load_selection_group WireAreaLowkCon -library tcbn65lptc

#set_input_transition 0.2 BD_to_PAD_clk
#set_drive 0 BD_to_PAD_clk

set_input_transition 0.2 BD_to_PAD_resetn
set_input_transition 0.2 BD_to_PAD_init_val[13]
set_input_transition 0.2 BD_to_PAD_init_val[12]
set_input_transition 0.2 BD_to_PAD_init_val[11]
set_input_transition 0.2 BD_to_PAD_init_val[10]
set_input_transition 0.2 BD_to_PAD_init_val[9]
set_input_transition 0.2 BD_to_PAD_init_val[8]
set_input_transition 0.2 BD_to_PAD_init_val[7]
set_input_transition 0.2 BD_to_PAD_init_val[6]
set_input_transition 0.2 BD_to_PAD_init_val[5]
set_input_transition 0.2 BD_to_PAD_init_val[4]
set_input_transition 0.2 BD_to_PAD_init_val[3]
set_input_transition 0.2 BD_to_PAD_init_val[2]
set_input_transition 0.2 BD_to_PAD_init_val[1]
set_input_transition 0.2 BD_to_PAD_init_val[0]
set_input_transition 0.2 BD_to_PAD_input_valid
set_input_transition 0.2 BD_to_PAD_image[31]
set_input_transition 0.2 BD_to_PAD_image[30]
set_input_transition 0.2 BD_to_PAD_image[29]
set_input_transition 0.2 BD_to_PAD_image[28]
set_input_transition 0.2 BD_to_PAD_image[27]
set_input_transition 0.2 BD_to_PAD_image[26]
set_input_transition 0.2 BD_to_PAD_image[25]
set_input_transition 0.2 BD_to_PAD_image[24]
set_input_transition 0.2 BD_to_PAD_image[23]
set_input_transition 0.2 BD_to_PAD_image[22]
set_input_transition 0.2 BD_to_PAD_image[21]
set_input_transition 0.2 BD_to_PAD_image[20]
set_input_transition 0.2 BD_to_PAD_image[19]
set_input_transition 0.2 BD_to_PAD_image[18]
set_input_transition 0.2 BD_to_PAD_image[17]
set_input_transition 0.2 BD_to_PAD_image[16]
set_input_transition 0.2 BD_to_PAD_image[15]
set_input_transition 0.2 BD_to_PAD_image[14]
set_input_transition 0.2 BD_to_PAD_image[13]
set_input_transition 0.2 BD_to_PAD_image[12]
set_input_transition 0.2 BD_to_PAD_image[11]
set_input_transition 0.2 BD_to_PAD_image[10]
set_input_transition 0.2 BD_to_PAD_image[9]
set_input_transition 0.2 BD_to_PAD_image[8]
set_input_transition 0.2 BD_to_PAD_image[7]
set_input_transition 0.2 BD_to_PAD_image[6]
set_input_transition 0.2 BD_to_PAD_image[5]
set_input_transition 0.2 BD_to_PAD_image[4]
set_input_transition 0.2 BD_to_PAD_image[3]
set_input_transition 0.2 BD_to_PAD_image[2]
set_input_transition 0.2 BD_to_PAD_image[1]
set_input_transition 0.2 BD_to_PAD_image[0]
set_input_transition 0.2 BD_to_PAD_label0[3]
set_input_transition 0.2 BD_to_PAD_label0[2]
set_input_transition 0.2 BD_to_PAD_label0[1]
set_input_transition 0.2 BD_to_PAD_label0[0]
set_input_transition 0.2 BD_to_PAD_pause
set_input_transition 0.2 BD_to_PAD_train
set_input_transition 0.2 BD_to_PAD_infer
set_input_transition 0.2 BD_to_PAD_sto_infer
set_input_transition 0.2 BD_to_PAD_initialize
set_input_transition 0.2 BD_to_PAD_clk



set_load -pin_load 1 [get_ports PAD_to_BD_output_valid]
set_load -pin_load 1 [get_ports {PAD_to_BD_neuron_voltages[13]}]
set_load -pin_load 1 [get_ports {PAD_to_BD_neuron_voltages[12]}]
set_load -pin_load 1 [get_ports {PAD_to_BD_neuron_voltages[11]}]
set_load -pin_load 1 [get_ports {PAD_to_BD_neuron_voltages[10]}]
set_load -pin_load 1 [get_ports {PAD_to_BD_neuron_voltages[9]}]
set_load -pin_load 1 [get_ports {PAD_to_BD_neuron_voltages[8]}]
set_load -pin_load 1 [get_ports {PAD_to_BD_neuron_voltages[7]}]
set_load -pin_load 1 [get_ports {PAD_to_BD_neuron_voltages[6]}]
set_load -pin_load 1 [get_ports {PAD_to_BD_neuron_voltages[5]}]
set_load -pin_load 1 [get_ports {PAD_to_BD_neuron_voltages[4]}]
set_load -pin_load 1 [get_ports {PAD_to_BD_neuron_voltages[3]}]
set_load -pin_load 1 [get_ports {PAD_to_BD_neuron_voltages[2]}]
set_load -pin_load 1 [get_ports {PAD_to_BD_neuron_voltages[1]}]
set_load -pin_load 1 [get_ports {PAD_to_BD_neuron_voltages[0]}]
set_load -pin_load 1 [get_ports PAD_to_BD_img_request]
set_load -pin_load 1 [get_ports PAD_to_BD_label_request]
set_load -pin_load 1 [get_ports PAD_to_BD_init_fin]

create_clock [get_ports BD_to_PAD_clk]  -period 6  -waveform {0 3}
set_max_delay 7 -from BD_to_PAD_resetn

set_clock_uncertainty 0.1  [get_clocks BD_to_PAD_clk]
set_clock_transition -max -rise 0.1 [get_clocks BD_to_PAD_clk]
set_clock_transition -max -fall 0.1 [get_clocks BD_to_PAD_clk]
set_clock_transition -min -rise 0.1 [get_clocks BD_to_PAD_clk]
set_clock_transition -min -fall 0.1 [get_clocks BD_to_PAD_clk]

set_input_delay -min -clock BD_to_PAD_clk  2  [get_ports {BD_to_PAD_resetn}]
set_input_delay -min -clock BD_to_PAD_clk  2  [get_ports {BD_to_PAD_init_val[13]}]
set_input_delay -min -clock BD_to_PAD_clk  2  [get_ports {BD_to_PAD_init_val[12]}]
set_input_delay -min -clock BD_to_PAD_clk  2  [get_ports {BD_to_PAD_init_val[11]}]
set_input_delay -min -clock BD_to_PAD_clk  2  [get_ports {BD_to_PAD_init_val[10]}]
set_input_delay -min -clock BD_to_PAD_clk  2  [get_ports {BD_to_PAD_init_val[9]}]
set_input_delay -min -clock BD_to_PAD_clk  2  [get_ports {BD_to_PAD_init_val[8]}]
set_input_delay -min -clock BD_to_PAD_clk  2  [get_ports {BD_to_PAD_init_val[7]}]
set_input_delay -min -clock BD_to_PAD_clk  2  [get_ports {BD_to_PAD_init_val[6]}]
set_input_delay -min -clock BD_to_PAD_clk  2  [get_ports {BD_to_PAD_init_val[5]}]
set_input_delay -min -clock BD_to_PAD_clk  2  [get_ports {BD_to_PAD_init_val[4]}]
set_input_delay -min -clock BD_to_PAD_clk  2  [get_ports {BD_to_PAD_init_val[3]}]
set_input_delay -min -clock BD_to_PAD_clk  2  [get_ports {BD_to_PAD_init_val[2]}]
set_input_delay -min -clock BD_to_PAD_clk  2  [get_ports {BD_to_PAD_init_val[1]}]
set_input_delay -min -clock BD_to_PAD_clk  2  [get_ports {BD_to_PAD_init_val[0]}]
set_input_delay -min -clock BD_to_PAD_clk  2  [get_ports BD_to_PAD_input_valid]
set_input_delay -min -clock BD_to_PAD_clk  2  [get_ports {BD_to_PAD_image[31]}]
set_input_delay -min -clock BD_to_PAD_clk  2  [get_ports {BD_to_PAD_image[30]}]
set_input_delay -min -clock BD_to_PAD_clk  2  [get_ports {BD_to_PAD_image[29]}]
set_input_delay -min -clock BD_to_PAD_clk  2  [get_ports {BD_to_PAD_image[28]}]
set_input_delay -min -clock BD_to_PAD_clk  2  [get_ports {BD_to_PAD_image[27]}]
set_input_delay -min -clock BD_to_PAD_clk  2  [get_ports {BD_to_PAD_image[26]}]
set_input_delay -min -clock BD_to_PAD_clk  2  [get_ports {BD_to_PAD_image[25]}]
set_input_delay -min -clock BD_to_PAD_clk  2  [get_ports {BD_to_PAD_image[24]}]
set_input_delay -min -clock BD_to_PAD_clk  2  [get_ports {BD_to_PAD_image[23]}]
set_input_delay -min -clock BD_to_PAD_clk  2  [get_ports {BD_to_PAD_image[22]}]
set_input_delay -min -clock BD_to_PAD_clk  2  [get_ports {BD_to_PAD_image[21]}]
set_input_delay -min -clock BD_to_PAD_clk  2  [get_ports {BD_to_PAD_image[20]}]
set_input_delay -min -clock BD_to_PAD_clk  2  [get_ports {BD_to_PAD_image[19]}]
set_input_delay -min -clock BD_to_PAD_clk  2  [get_ports {BD_to_PAD_image[18]}]
set_input_delay -min -clock BD_to_PAD_clk  2  [get_ports {BD_to_PAD_image[17]}]
set_input_delay -min -clock BD_to_PAD_clk  2  [get_ports {BD_to_PAD_image[16]}]
set_input_delay -min -clock BD_to_PAD_clk  2  [get_ports {BD_to_PAD_image[15]}]
set_input_delay -min -clock BD_to_PAD_clk  2  [get_ports {BD_to_PAD_image[14]}]
set_input_delay -min -clock BD_to_PAD_clk  2  [get_ports {BD_to_PAD_image[13]}]
set_input_delay -min -clock BD_to_PAD_clk  2  [get_ports {BD_to_PAD_image[12]}]
set_input_delay -min -clock BD_to_PAD_clk  2  [get_ports {BD_to_PAD_image[11]}]
set_input_delay -min -clock BD_to_PAD_clk  2  [get_ports {BD_to_PAD_image[10]}]
set_input_delay -min -clock BD_to_PAD_clk  2  [get_ports {BD_to_PAD_image[9]}]
set_input_delay -min -clock BD_to_PAD_clk  2  [get_ports {BD_to_PAD_image[8]}]
set_input_delay -min -clock BD_to_PAD_clk  2  [get_ports {BD_to_PAD_image[7]}]
set_input_delay -min -clock BD_to_PAD_clk  2  [get_ports {BD_to_PAD_image[6]}]
set_input_delay -min -clock BD_to_PAD_clk  2  [get_ports {BD_to_PAD_image[5]}]
set_input_delay -min -clock BD_to_PAD_clk  2  [get_ports {BD_to_PAD_image[4]}]
set_input_delay -min -clock BD_to_PAD_clk  2  [get_ports {BD_to_PAD_image[3]}]
set_input_delay -min -clock BD_to_PAD_clk  2  [get_ports {BD_to_PAD_image[2]}]
set_input_delay -min -clock BD_to_PAD_clk  2  [get_ports {BD_to_PAD_image[1]}]
set_input_delay -min -clock BD_to_PAD_clk  2  [get_ports {BD_to_PAD_image[0]}]
set_input_delay -min -clock BD_to_PAD_clk  2  [get_ports {BD_to_PAD_label0[3]}]
set_input_delay -min -clock BD_to_PAD_clk  2  [get_ports {BD_to_PAD_label0[2]}]
set_input_delay -min -clock BD_to_PAD_clk  2  [get_ports {BD_to_PAD_label0[1]}]
set_input_delay -min -clock BD_to_PAD_clk  2  [get_ports {BD_to_PAD_label0[0]}]
set_input_delay -min -clock BD_to_PAD_clk  2  [get_ports BD_to_PAD_pause]
set_input_delay -min -clock BD_to_PAD_clk  2  [get_ports BD_to_PAD_train]
set_input_delay -min -clock BD_to_PAD_clk  2  [get_ports BD_to_PAD_infer]
set_input_delay -min -clock BD_to_PAD_clk  2  [get_ports BD_to_PAD_sto_infer]
set_input_delay -min -clock BD_to_PAD_clk  2  [get_ports BD_to_PAD_initialize]

set_input_delay -max -clock BD_to_PAD_clk 3 [get_ports {BD_to_PAD_resetn}]
set_input_delay -max -clock BD_to_PAD_clk 3 [get_ports {BD_to_PAD_init_val[13]}]
set_input_delay -max -clock BD_to_PAD_clk 3 [get_ports {BD_to_PAD_init_val[12]}]
set_input_delay -max -clock BD_to_PAD_clk 3 [get_ports {BD_to_PAD_init_val[11]}]
set_input_delay -max -clock BD_to_PAD_clk 3 [get_ports {BD_to_PAD_init_val[10]}]
set_input_delay -max -clock BD_to_PAD_clk 3 [get_ports {BD_to_PAD_init_val[9]}]
set_input_delay -max -clock BD_to_PAD_clk 3 [get_ports {BD_to_PAD_init_val[8]}]
set_input_delay -max -clock BD_to_PAD_clk 3 [get_ports {BD_to_PAD_init_val[7]}]
set_input_delay -max -clock BD_to_PAD_clk 3 [get_ports {BD_to_PAD_init_val[6]}]
set_input_delay -max -clock BD_to_PAD_clk 3 [get_ports {BD_to_PAD_init_val[5]}]
set_input_delay -max -clock BD_to_PAD_clk 3 [get_ports {BD_to_PAD_init_val[4]}]
set_input_delay -max -clock BD_to_PAD_clk 3 [get_ports {BD_to_PAD_init_val[3]}]
set_input_delay -max -clock BD_to_PAD_clk 3 [get_ports {BD_to_PAD_init_val[2]}]
set_input_delay -max -clock BD_to_PAD_clk 3 [get_ports {BD_to_PAD_init_val[1]}]
set_input_delay -max -clock BD_to_PAD_clk 3 [get_ports {BD_to_PAD_init_val[0]}]
set_input_delay -max -clock BD_to_PAD_clk 3 [get_ports BD_to_PAD_input_valid]
set_input_delay -max -clock BD_to_PAD_clk 3 [get_ports {BD_to_PAD_image[31]}]
set_input_delay -max -clock BD_to_PAD_clk 3 [get_ports {BD_to_PAD_image[30]}]
set_input_delay -max -clock BD_to_PAD_clk 3 [get_ports {BD_to_PAD_image[29]}]
set_input_delay -max -clock BD_to_PAD_clk 3 [get_ports {BD_to_PAD_image[28]}]
set_input_delay -max -clock BD_to_PAD_clk 3 [get_ports {BD_to_PAD_image[27]}]
set_input_delay -max -clock BD_to_PAD_clk 3 [get_ports {BD_to_PAD_image[26]}]
set_input_delay -max -clock BD_to_PAD_clk 3 [get_ports {BD_to_PAD_image[25]}]
set_input_delay -max -clock BD_to_PAD_clk 3 [get_ports {BD_to_PAD_image[24]}]
set_input_delay -max -clock BD_to_PAD_clk 3 [get_ports {BD_to_PAD_image[23]}]
set_input_delay -max -clock BD_to_PAD_clk 3 [get_ports {BD_to_PAD_image[22]}]
set_input_delay -max -clock BD_to_PAD_clk 3 [get_ports {BD_to_PAD_image[21]}]
set_input_delay -max -clock BD_to_PAD_clk 3 [get_ports {BD_to_PAD_image[20]}]
set_input_delay -max -clock BD_to_PAD_clk 3 [get_ports {BD_to_PAD_image[19]}]
set_input_delay -max -clock BD_to_PAD_clk 3 [get_ports {BD_to_PAD_image[18]}]
set_input_delay -max -clock BD_to_PAD_clk 3 [get_ports {BD_to_PAD_image[17]}]
set_input_delay -max -clock BD_to_PAD_clk 3 [get_ports {BD_to_PAD_image[16]}]
set_input_delay -max -clock BD_to_PAD_clk 3 [get_ports {BD_to_PAD_image[15]}]
set_input_delay -max -clock BD_to_PAD_clk 3 [get_ports {BD_to_PAD_image[14]}]
set_input_delay -max -clock BD_to_PAD_clk 3 [get_ports {BD_to_PAD_image[13]}]
set_input_delay -max -clock BD_to_PAD_clk 3 [get_ports {BD_to_PAD_image[12]}]
set_input_delay -max -clock BD_to_PAD_clk 3 [get_ports {BD_to_PAD_image[11]}]
set_input_delay -max -clock BD_to_PAD_clk 3 [get_ports {BD_to_PAD_image[10]}]
set_input_delay -max -clock BD_to_PAD_clk 3 [get_ports {BD_to_PAD_image[9]}]
set_input_delay -max -clock BD_to_PAD_clk 3 [get_ports {BD_to_PAD_image[8]}]
set_input_delay -max -clock BD_to_PAD_clk 3 [get_ports {BD_to_PAD_image[7]}]
set_input_delay -max -clock BD_to_PAD_clk 3 [get_ports {BD_to_PAD_image[6]}]
set_input_delay -max -clock BD_to_PAD_clk 3 [get_ports {BD_to_PAD_image[5]}]
set_input_delay -max -clock BD_to_PAD_clk 3 [get_ports {BD_to_PAD_image[4]}]
set_input_delay -max -clock BD_to_PAD_clk 3 [get_ports {BD_to_PAD_image[3]}]
set_input_delay -max -clock BD_to_PAD_clk 3 [get_ports {BD_to_PAD_image[2]}]
set_input_delay -max -clock BD_to_PAD_clk 3 [get_ports {BD_to_PAD_image[1]}]
set_input_delay -max -clock BD_to_PAD_clk 3 [get_ports {BD_to_PAD_image[0]}]
set_input_delay -max -clock BD_to_PAD_clk 3 [get_ports {BD_to_PAD_label0[3]}]
set_input_delay -max -clock BD_to_PAD_clk 3 [get_ports {BD_to_PAD_label0[2]}]
set_input_delay -max -clock BD_to_PAD_clk 3 [get_ports {BD_to_PAD_label0[1]}]
set_input_delay -max -clock BD_to_PAD_clk 3 [get_ports {BD_to_PAD_label0[0]}]
set_input_delay -max -clock BD_to_PAD_clk 3 [get_ports BD_to_PAD_pause]
set_input_delay -max -clock BD_to_PAD_clk 3 [get_ports BD_to_PAD_train]
set_input_delay -max -clock BD_to_PAD_clk 3 [get_ports BD_to_PAD_infer]
set_input_delay -max -clock BD_to_PAD_clk 3 [get_ports BD_to_PAD_sto_infer]
set_input_delay -max -clock BD_to_PAD_clk 3 [get_ports BD_to_PAD_initialize]


set_output_delay -clock BD_to_PAD_clk 2  [get_ports PAD_to_BD_output_valid]
set_output_delay -clock BD_to_PAD_clk 2  [get_ports {PAD_to_BD_neuron_voltages[13]}]
set_output_delay -clock BD_to_PAD_clk 2  [get_ports {PAD_to_BD_neuron_voltages[12]}]
set_output_delay -clock BD_to_PAD_clk 2  [get_ports {PAD_to_BD_neuron_voltages[11]}]
set_output_delay -clock BD_to_PAD_clk 2  [get_ports {PAD_to_BD_neuron_voltages[10]}]
set_output_delay -clock BD_to_PAD_clk 2  [get_ports {PAD_to_BD_neuron_voltages[9]}]
set_output_delay -clock BD_to_PAD_clk 2  [get_ports {PAD_to_BD_neuron_voltages[8]}]
set_output_delay -clock BD_to_PAD_clk 2  [get_ports {PAD_to_BD_neuron_voltages[7]}]
set_output_delay -clock BD_to_PAD_clk 2  [get_ports {PAD_to_BD_neuron_voltages[6]}]
set_output_delay -clock BD_to_PAD_clk 2  [get_ports {PAD_to_BD_neuron_voltages[5]}]
set_output_delay -clock BD_to_PAD_clk 2  [get_ports {PAD_to_BD_neuron_voltages[4]}]
set_output_delay -clock BD_to_PAD_clk 2  [get_ports {PAD_to_BD_neuron_voltages[3]}]
set_output_delay -clock BD_to_PAD_clk 2  [get_ports {PAD_to_BD_neuron_voltages[2]}]
set_output_delay -clock BD_to_PAD_clk 2  [get_ports {PAD_to_BD_neuron_voltages[1]}]
set_output_delay -clock BD_to_PAD_clk 2  [get_ports {PAD_to_BD_neuron_voltages[0]}]
set_output_delay -clock BD_to_PAD_clk 2  [get_ports PAD_to_BD_img_request]
set_output_delay -clock BD_to_PAD_clk 2  [get_ports PAD_to_BD_label_request] 
set_output_delay -clock BD_to_PAD_clk 2  [get_ports PAD_to_BD_init_fin]
