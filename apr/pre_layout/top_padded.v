module top_padded (
		BD_to_PAD_label0,
		BD_to_PAD_pause,
		BD_to_PAD_image,
		BD_to_PAD_clk,
		BD_to_PAD_resetn,
		BD_to_PAD_initialize,
		BD_to_PAD_train,
		BD_to_PAD_input_valid,
		BD_to_PAD_init_val,
        BD_to_PAD_infer,
        BD_to_PAD_sto_infer,

		PAD_to_BD_img_request,
		PAD_to_BD_output_valid,
		PAD_to_BD_neuron_voltages,
		PAD_to_BD_init_fin,
        PAD_to_BD_label_request);

	input [3:0] BD_to_PAD_label0;
	input BD_to_PAD_pause;
	input [31:0] BD_to_PAD_image;
	input BD_to_PAD_clk;
	input BD_to_PAD_resetn;
	input BD_to_PAD_initialize;
	input BD_to_PAD_train;
	input BD_to_PAD_input_valid;
	input [13:0] BD_to_PAD_init_val;
    input BD_to_PAD_infer;
    input BD_to_PAD_sto_infer;

	output PAD_to_BD_img_request;
	output PAD_to_BD_output_valid;
	output [13:0] PAD_to_BD_neuron_voltages;
	output PAD_to_BD_init_fin;
    output PAD_to_BD_label_request;
	//PAD_to_DUT input pad wire declaration
	wire [3:0] PAD_to_DUT_label0;
	wire PAD_to_DUT_pause;
	wire [31:0] PAD_to_DUT_image;
	wire PAD_to_DUT_clk;
	wire PAD_to_DUT_resetn;
	wire PAD_to_DUT_initialize;
	wire PAD_to_DUT_train;
	wire PAD_to_DUT_input_valid;
	wire [13:0] PAD_to_DUT_init_val;
    wire PAD_to_DUT_infer;
    wire PAD_to_DUT_sto_infer;
    
	//DUT_to_PAD output pad wire declaration
	wire DUT_to_PAD_img_request;
	wire DUT_to_PAD_output_valid;
	wire [13:0] DUT_to_PAD_neuron_voltages;
	wire DUT_to_PAD_init_fin;
    wire DUT_to_PAD_label_request;

	//Input pads
	PDDW1216CDG PAD_IN_label0_0	(.PAD(BD_to_PAD_label0[0]), .C(PAD_to_DUT_label0[0]), .OEN(1'b1), .DS(1'b0), .I(1'b0), .IE(1'b1), .PE(1'b0));
	PDDW1216CDG PAD_IN_label0_1	(.PAD(BD_to_PAD_label0[1]), .C(PAD_to_DUT_label0[1]), .OEN(1'b1), .DS(1'b0), .I(1'b0), .IE(1'b1), .PE(1'b0));
	PDDW1216CDG PAD_IN_label0_2	(.PAD(BD_to_PAD_label0[2]), .C(PAD_to_DUT_label0[2]), .OEN(1'b1), .DS(1'b0), .I(1'b0), .IE(1'b1), .PE(1'b0));
	PDDW1216CDG PAD_IN_label0_3	(.PAD(BD_to_PAD_label0[3]), .C(PAD_to_DUT_label0[3]), .OEN(1'b1), .DS(1'b0), .I(1'b0), .IE(1'b1), .PE(1'b0));
	PDDW1216CDG PAD_IN_pause	(.PAD(BD_to_PAD_pause), .C(PAD_to_DUT_pause), .OEN(1'b1), .DS(1'b0), .I(1'b0), .IE(1'b1), .PE(1'b0));
	PDDW1216CDG PAD_IN_image_0	(.PAD(BD_to_PAD_image[0]), .C(PAD_to_DUT_image[0]), .OEN(1'b1), .DS(1'b0), .I(1'b0), .IE(1'b1), .PE(1'b0));
	PDDW1216CDG PAD_IN_image_1	(.PAD(BD_to_PAD_image[1]), .C(PAD_to_DUT_image[1]), .OEN(1'b1), .DS(1'b0), .I(1'b0), .IE(1'b1), .PE(1'b0));
	PDDW1216CDG PAD_IN_image_2	(.PAD(BD_to_PAD_image[2]), .C(PAD_to_DUT_image[2]), .OEN(1'b1), .DS(1'b0), .I(1'b0), .IE(1'b1), .PE(1'b0));
	PDDW1216CDG PAD_IN_image_3	(.PAD(BD_to_PAD_image[3]), .C(PAD_to_DUT_image[3]), .OEN(1'b1), .DS(1'b0), .I(1'b0), .IE(1'b1), .PE(1'b0));
	PDDW1216CDG PAD_IN_image_4	(.PAD(BD_to_PAD_image[4]), .C(PAD_to_DUT_image[4]), .OEN(1'b1), .DS(1'b0), .I(1'b0), .IE(1'b1), .PE(1'b0));
	PDDW1216CDG PAD_IN_image_5	(.PAD(BD_to_PAD_image[5]), .C(PAD_to_DUT_image[5]), .OEN(1'b1), .DS(1'b0), .I(1'b0), .IE(1'b1), .PE(1'b0));
	PDDW1216CDG PAD_IN_image_6	(.PAD(BD_to_PAD_image[6]), .C(PAD_to_DUT_image[6]), .OEN(1'b1), .DS(1'b0), .I(1'b0), .IE(1'b1), .PE(1'b0));
	PDDW1216CDG PAD_IN_image_7	(.PAD(BD_to_PAD_image[7]), .C(PAD_to_DUT_image[7]), .OEN(1'b1), .DS(1'b0), .I(1'b0), .IE(1'b1), .PE(1'b0));
	PDDW1216CDG PAD_IN_image_8	(.PAD(BD_to_PAD_image[8]), .C(PAD_to_DUT_image[8]), .OEN(1'b1), .DS(1'b0), .I(1'b0), .IE(1'b1), .PE(1'b0));
	PDDW1216CDG PAD_IN_image_9	(.PAD(BD_to_PAD_image[9]), .C(PAD_to_DUT_image[9]), .OEN(1'b1), .DS(1'b0), .I(1'b0), .IE(1'b1), .PE(1'b0));
	PDDW1216CDG PAD_IN_image_10	(.PAD(BD_to_PAD_image[10]), .C(PAD_to_DUT_image[10]), .OEN(1'b1), .DS(1'b0), .I(1'b0), .IE(1'b1), .PE(1'b0));
	PDDW1216CDG PAD_IN_image_11	(.PAD(BD_to_PAD_image[11]), .C(PAD_to_DUT_image[11]), .OEN(1'b1), .DS(1'b0), .I(1'b0), .IE(1'b1), .PE(1'b0));
	PDDW1216CDG PAD_IN_image_12	(.PAD(BD_to_PAD_image[12]), .C(PAD_to_DUT_image[12]), .OEN(1'b1), .DS(1'b0), .I(1'b0), .IE(1'b1), .PE(1'b0));
	PDDW1216CDG PAD_IN_image_13	(.PAD(BD_to_PAD_image[13]), .C(PAD_to_DUT_image[13]), .OEN(1'b1), .DS(1'b0), .I(1'b0), .IE(1'b1), .PE(1'b0));
	PDDW1216CDG PAD_IN_image_14	(.PAD(BD_to_PAD_image[14]), .C(PAD_to_DUT_image[14]), .OEN(1'b1), .DS(1'b0), .I(1'b0), .IE(1'b1), .PE(1'b0));
	PDDW1216CDG PAD_IN_image_15	(.PAD(BD_to_PAD_image[15]), .C(PAD_to_DUT_image[15]), .OEN(1'b1), .DS(1'b0), .I(1'b0), .IE(1'b1), .PE(1'b0));
	PDDW1216CDG PAD_IN_image_16	(.PAD(BD_to_PAD_image[16]), .C(PAD_to_DUT_image[16]), .OEN(1'b1), .DS(1'b0), .I(1'b0), .IE(1'b1), .PE(1'b0));
	PDDW1216CDG PAD_IN_image_17	(.PAD(BD_to_PAD_image[17]), .C(PAD_to_DUT_image[17]), .OEN(1'b1), .DS(1'b0), .I(1'b0), .IE(1'b1), .PE(1'b0));
	PDDW1216CDG PAD_IN_image_18	(.PAD(BD_to_PAD_image[18]), .C(PAD_to_DUT_image[18]), .OEN(1'b1), .DS(1'b0), .I(1'b0), .IE(1'b1), .PE(1'b0));
	PDDW1216CDG PAD_IN_image_19	(.PAD(BD_to_PAD_image[19]), .C(PAD_to_DUT_image[19]), .OEN(1'b1), .DS(1'b0), .I(1'b0), .IE(1'b1), .PE(1'b0));
	PDDW1216CDG PAD_IN_image_20	(.PAD(BD_to_PAD_image[20]), .C(PAD_to_DUT_image[20]), .OEN(1'b1), .DS(1'b0), .I(1'b0), .IE(1'b1), .PE(1'b0));
	PDDW1216CDG PAD_IN_image_21	(.PAD(BD_to_PAD_image[21]), .C(PAD_to_DUT_image[21]), .OEN(1'b1), .DS(1'b0), .I(1'b0), .IE(1'b1), .PE(1'b0));
	PDDW1216CDG PAD_IN_image_22	(.PAD(BD_to_PAD_image[22]), .C(PAD_to_DUT_image[22]), .OEN(1'b1), .DS(1'b0), .I(1'b0), .IE(1'b1), .PE(1'b0));
	PDDW1216CDG PAD_IN_image_23	(.PAD(BD_to_PAD_image[23]), .C(PAD_to_DUT_image[23]), .OEN(1'b1), .DS(1'b0), .I(1'b0), .IE(1'b1), .PE(1'b0));
	PDDW1216CDG PAD_IN_image_24	(.PAD(BD_to_PAD_image[24]), .C(PAD_to_DUT_image[24]), .OEN(1'b1), .DS(1'b0), .I(1'b0), .IE(1'b1), .PE(1'b0));
	PDDW1216CDG PAD_IN_image_25	(.PAD(BD_to_PAD_image[25]), .C(PAD_to_DUT_image[25]), .OEN(1'b1), .DS(1'b0), .I(1'b0), .IE(1'b1), .PE(1'b0));
	PDDW1216CDG PAD_IN_image_26	(.PAD(BD_to_PAD_image[26]), .C(PAD_to_DUT_image[26]), .OEN(1'b1), .DS(1'b0), .I(1'b0), .IE(1'b1), .PE(1'b0));
	PDDW1216CDG PAD_IN_image_27	(.PAD(BD_to_PAD_image[27]), .C(PAD_to_DUT_image[27]), .OEN(1'b1), .DS(1'b0), .I(1'b0), .IE(1'b1), .PE(1'b0));
	PDDW1216CDG PAD_IN_image_28	(.PAD(BD_to_PAD_image[28]), .C(PAD_to_DUT_image[28]), .OEN(1'b1), .DS(1'b0), .I(1'b0), .IE(1'b1), .PE(1'b0));
	PDDW1216CDG PAD_IN_image_29	(.PAD(BD_to_PAD_image[29]), .C(PAD_to_DUT_image[29]), .OEN(1'b1), .DS(1'b0), .I(1'b0), .IE(1'b1), .PE(1'b0));
	PDDW1216CDG PAD_IN_image_30	(.PAD(BD_to_PAD_image[30]), .C(PAD_to_DUT_image[30]), .OEN(1'b1), .DS(1'b0), .I(1'b0), .IE(1'b1), .PE(1'b0));
	PDDW1216CDG PAD_IN_image_31	(.PAD(BD_to_PAD_image[31]), .C(PAD_to_DUT_image[31]), .OEN(1'b1), .DS(1'b0), .I(1'b0), .IE(1'b1), .PE(1'b0));
	PDDW1216CDG PAD_IN_clk	(.PAD(BD_to_PAD_clk), .C(PAD_to_DUT_clk), .OEN(1'b1), .DS(1'b0), .I(1'b0), .IE(1'b1), .PE(1'b0));
	PDDW1216CDG PAD_IN_infer	(.PAD(BD_to_PAD_infer), .C(PAD_to_DUT_infer), .OEN(1'b1), .DS(1'b0), .I(1'b0), .IE(1'b1), .PE(1'b0));
	
	PDDW1216CDG PAD_IN_resetn	(.PAD(BD_to_PAD_resetn), .C(PAD_to_DUT_resetn), .OEN(1'b1), .DS(1'b0), .I(1'b0), .IE(1'b1), .PE(1'b0));
	PDDW1216CDG PAD_IN_initialize	(.PAD(BD_to_PAD_initialize), .C(PAD_to_DUT_initialize), .OEN(1'b1), .DS(1'b0), .I(1'b0), .IE(1'b1), .PE(1'b0));
	PDDW1216CDG PAD_IN_train	(.PAD(BD_to_PAD_train), .C(PAD_to_DUT_train), .OEN(1'b1), .DS(1'b0), .I(1'b0), .IE(1'b1), .PE(1'b0));
	PDDW1216CDG PAD_IN_input_valid	(.PAD(BD_to_PAD_input_valid), .C(PAD_to_DUT_input_valid), .OEN(1'b1), .DS(1'b0), .I(1'b0), .IE(1'b1), .PE(1'b0));
	PDDW1216CDG PAD_IN_init_val_0	(.PAD(BD_to_PAD_init_val[0]), .C(PAD_to_DUT_init_val[0]), .OEN(1'b1), .DS(1'b0), .I(1'b0), .IE(1'b1), .PE(1'b0));
	PDDW1216CDG PAD_IN_init_val_1	(.PAD(BD_to_PAD_init_val[1]), .C(PAD_to_DUT_init_val[1]), .OEN(1'b1), .DS(1'b0), .I(1'b0), .IE(1'b1), .PE(1'b0));
	PDDW1216CDG PAD_IN_init_val_2	(.PAD(BD_to_PAD_init_val[2]), .C(PAD_to_DUT_init_val[2]), .OEN(1'b1), .DS(1'b0), .I(1'b0), .IE(1'b1), .PE(1'b0));
	PDDW1216CDG PAD_IN_init_val_3	(.PAD(BD_to_PAD_init_val[3]), .C(PAD_to_DUT_init_val[3]), .OEN(1'b1), .DS(1'b0), .I(1'b0), .IE(1'b1), .PE(1'b0));
	PDDW1216CDG PAD_IN_init_val_4	(.PAD(BD_to_PAD_init_val[4]), .C(PAD_to_DUT_init_val[4]), .OEN(1'b1), .DS(1'b0), .I(1'b0), .IE(1'b1), .PE(1'b0));
	PDDW1216CDG PAD_IN_init_val_5	(.PAD(BD_to_PAD_init_val[5]), .C(PAD_to_DUT_init_val[5]), .OEN(1'b1), .DS(1'b0), .I(1'b0), .IE(1'b1), .PE(1'b0));
	PDDW1216CDG PAD_IN_init_val_6	(.PAD(BD_to_PAD_init_val[6]), .C(PAD_to_DUT_init_val[6]), .OEN(1'b1), .DS(1'b0), .I(1'b0), .IE(1'b1), .PE(1'b0));
	PDDW1216CDG PAD_IN_init_val_7	(.PAD(BD_to_PAD_init_val[7]), .C(PAD_to_DUT_init_val[7]), .OEN(1'b1), .DS(1'b0), .I(1'b0), .IE(1'b1), .PE(1'b0));
	PDDW1216CDG PAD_IN_init_val_8	(.PAD(BD_to_PAD_init_val[8]), .C(PAD_to_DUT_init_val[8]), .OEN(1'b1), .DS(1'b0), .I(1'b0), .IE(1'b1), .PE(1'b0));
	PDDW1216CDG PAD_IN_init_val_9	(.PAD(BD_to_PAD_init_val[9]), .C(PAD_to_DUT_init_val[9]), .OEN(1'b1), .DS(1'b0), .I(1'b0), .IE(1'b1), .PE(1'b0));
	PDDW1216CDG PAD_IN_init_val_10	(.PAD(BD_to_PAD_init_val[10]), .C(PAD_to_DUT_init_val[10]), .OEN(1'b1), .DS(1'b0), .I(1'b0), .IE(1'b1), .PE(1'b0));
	PDDW1216CDG PAD_IN_init_val_11	(.PAD(BD_to_PAD_init_val[11]), .C(PAD_to_DUT_init_val[11]), .OEN(1'b1), .DS(1'b0), .I(1'b0), .IE(1'b1), .PE(1'b0));
	PDDW1216CDG PAD_IN_init_val_12	(.PAD(BD_to_PAD_init_val[12]), .C(PAD_to_DUT_init_val[12]), .OEN(1'b1), .DS(1'b0), .I(1'b0), .IE(1'b1), .PE(1'b0));
	PDDW1216CDG PAD_IN_init_val_13	(.PAD(BD_to_PAD_init_val[13]), .C(PAD_to_DUT_init_val[13]), .OEN(1'b1), .DS(1'b0), .I(1'b0), .IE(1'b1), .PE(1'b0));
    PDDW1216CDG PAD_IN_sto_infer    (.PAD(BD_to_PAD_sto_infer), .C(PAD_to_DUT_sto_infer), .OEN(1'b1), .DS(1'b0), .I(1'b0), .IE(1'b1), .PE(1'b0));

	//Output pads
	PDDW1216CDG PAD_OUT_img_request	(.PAD(PAD_to_BD_img_request), .I(DUT_to_PAD_img_request), .OEN(1'b0), .DS(1'b1), .IE(1'b0), .PE(1'b0));
	PDDW1216CDG PAD_OUT_output_valid	(.PAD(PAD_to_BD_output_valid), .I(DUT_to_PAD_output_valid), .OEN(1'b0), .DS(1'b1), .IE(1'b0), .PE(1'b0));
	PDDW1216CDG PAD_OUT_neuron_voltages_0	(.PAD(PAD_to_BD_neuron_voltages[0]), .I(DUT_to_PAD_neuron_voltages[0]), .OEN(1'b0), .DS(1'b1),  .IE(1'b0), .PE(1'b0));
	PDDW1216CDG PAD_OUT_neuron_voltages_1	(.PAD(PAD_to_BD_neuron_voltages[1]), .I(DUT_to_PAD_neuron_voltages[1]), .OEN(1'b0), .DS(1'b1),  .IE(1'b0), .PE(1'b0));
	PDDW1216CDG PAD_OUT_neuron_voltages_2	(.PAD(PAD_to_BD_neuron_voltages[2]), .I(DUT_to_PAD_neuron_voltages[2]), .OEN(1'b0), .DS(1'b1),  .IE(1'b0), .PE(1'b0));
	PDDW1216CDG PAD_OUT_neuron_voltages_3	(.PAD(PAD_to_BD_neuron_voltages[3]), .I(DUT_to_PAD_neuron_voltages[3]), .OEN(1'b0), .DS(1'b1),  .IE(1'b0), .PE(1'b0));
	PDDW1216CDG PAD_OUT_neuron_voltages_4	(.PAD(PAD_to_BD_neuron_voltages[4]), .I(DUT_to_PAD_neuron_voltages[4]), .OEN(1'b0), .DS(1'b1),  .IE(1'b0), .PE(1'b0));
	PDDW1216CDG PAD_OUT_neuron_voltages_5	(.PAD(PAD_to_BD_neuron_voltages[5]), .I(DUT_to_PAD_neuron_voltages[5]), .OEN(1'b0), .DS(1'b1),  .IE(1'b0), .PE(1'b0));
	PDDW1216CDG PAD_OUT_neuron_voltages_6	(.PAD(PAD_to_BD_neuron_voltages[6]), .I(DUT_to_PAD_neuron_voltages[6]), .OEN(1'b0), .DS(1'b1),  .IE(1'b0), .PE(1'b0));
	PDDW1216CDG PAD_OUT_neuron_voltages_7	(.PAD(PAD_to_BD_neuron_voltages[7]), .I(DUT_to_PAD_neuron_voltages[7]), .OEN(1'b0), .DS(1'b1),  .IE(1'b0), .PE(1'b0));
	PDDW1216CDG PAD_OUT_neuron_voltages_8	(.PAD(PAD_to_BD_neuron_voltages[8]), .I(DUT_to_PAD_neuron_voltages[8]), .OEN(1'b0), .DS(1'b1),  .IE(1'b0), .PE(1'b0));
	PDDW1216CDG PAD_OUT_neuron_voltages_9	(.PAD(PAD_to_BD_neuron_voltages[9]), .I(DUT_to_PAD_neuron_voltages[9]), .OEN(1'b0), .DS(1'b1),  .IE(1'b0), .PE(1'b0));
	PDDW1216CDG PAD_OUT_neuron_voltages_10	(.PAD(PAD_to_BD_neuron_voltages[10]), .I(DUT_to_PAD_neuron_voltages[10]), .OEN(1'b0), .DS(1'b1),  .IE(1'b0), .PE(1'b0));
	PDDW1216CDG PAD_OUT_neuron_voltages_11	(.PAD(PAD_to_BD_neuron_voltages[11]), .I(DUT_to_PAD_neuron_voltages[11]), .OEN(1'b0), .DS(1'b1),  .IE(1'b0), .PE(1'b0));
	PDDW1216CDG PAD_OUT_neuron_voltages_12	(.PAD(PAD_to_BD_neuron_voltages[12]), .I(DUT_to_PAD_neuron_voltages[12]), .OEN(1'b0), .DS(1'b1),  .IE(1'b0), .PE(1'b0));
	PDDW1216CDG PAD_OUT_neuron_voltages_13	(.PAD(PAD_to_BD_neuron_voltages[13]), .I(DUT_to_PAD_neuron_voltages[13]), .OEN(1'b0), .DS(1'b1),  .IE(1'b0), .PE(1'b0));
	PDDW1216CDG PAD_OUT_init_fin	(.PAD(PAD_to_BD_init_fin), .I(DUT_to_PAD_init_fin), .OEN(1'b0), .DS(1'b1), .IE(1'b0), .PE(1'b0));
	PDDW1216CDG PAD_OUT_label_request	(.PAD(PAD_to_BD_label_request), .I(DUT_to_PAD_label_request), .OEN(1'b0), .DS(1'b1), .IE(1'b0), .PE(1'b0));


	//Power rings and ESD protection
	//PCLAMP1ANA CORE_ESD_PROTECTION();
	//PCLAMP2ANA IO_ESD_PROTECTION();

	//Core VDD
	PVDD1ANA PAD_POWER_VDD_CORE_0 ();
	PVDD1ANA PAD_POWER_VDD_CORE_1 ();
	PVDD1ANA PAD_POWER_VDD_CORE_2 ();
	PVDD1ANA PAD_POWER_VDD_CORE_3 ();



	//Core VSS
	PVSS1ANA PAD_POWER_VSS_0 ();
	PVSS1ANA PAD_POWER_VSS_1 ();
	PVSS1ANA PAD_POWER_VSS_2 ();
	PVSS1ANA PAD_POWER_VSS_3 ();



	//clean VDD on RING
	PVDD1CDG PADRING_CVDD_0 ();
	PVDD1CDG PADRING_CVDD_1 ();
	PVDD1CDG PADRING_CVDD_2 ();
	PVDD1CDG PADRING_CVDD_3 ();



	//dirty VDD on RING
	PVDD2POC PADRING_DVDD_0 ();
	PVDD2CDG PADRING_DVDD_1 ();
	PVDD2CDG PADRING_DVDD_2 ();
	PVDD2CDG PADRING_DVDD_3 ();

	

	//PADRING VSS
	PVSS3CDG PADRING_VSS_0 ();
	PVSS3CDG PADRING_VSS_1 ();
	PVSS3CDG PADRING_VSS_2 ();
	PVSS3CDG PADRING_VSS_3 ();


    
    PCORNER PADRING_CORNER_RT ();
    PCORNER PADRING_CORNER_LT ();
    


    //Gwang-hyun block
    PVDD1ANA GH_VDD ();
    PVDD1ANA GH_VREF ();
    PVDD1ANA GH_VB ();
    PVDD1ANA GH_IBIAS ();
    PVDD1ANA GH_VOUT1 ();
    PVDD1ANA GH_VOUT2 ();
    PVDD1ANA GH_VIN1 ();
    PVDD1ANA GH_VIN2 ();
    PVDD1ANA GH_VLOAD1 ();
    PVDD1ANA GH_VLOAD2 ();
    PVDD1ANA GH_VDDH ();

    PVSS1ANA GH_VSS ();

	PDDW1216CDG GH_CLK	(.OEN(1'b1), .DS(1'b0), .I(1'b0), .IE(1'b1), .PE(1'b0));
	PDDW1216CDG GH_SWITCH	(.OEN(1'b1), .DS(1'b0), .I(1'b0), .IE(1'b1), .PE(1'b0));




    LDOBLOCK ldoblock ();     
   
    top dut(.label_request(DUT_to_PAD_label_request),.sto_infer(PAD_to_DUT_sto_infer),.infer(PAD_to_DUT_infer),.label0(PAD_to_DUT_label0), .pause(PAD_to_DUT_pause), .image(PAD_to_DUT_image), .clk(PAD_to_DUT_clk), .resetn(PAD_to_DUT_resetn), .initialize(PAD_to_DUT_initialize), .train(PAD_to_DUT_train), .input_valid(PAD_to_DUT_input_valid), .init_val(PAD_to_DUT_init_val), .img_request(DUT_to_PAD_img_request), .output_valid(DUT_to_PAD_output_valid), .neuron_voltages(DUT_to_PAD_neuron_voltages), .init_fin(DUT_to_PAD_init_fin));

endmodule
