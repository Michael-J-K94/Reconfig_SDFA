// This is a Output Block module
// Description : This is Top module of Output Block module
// Author : Wonjae based by Jaemin

module sdfa_output_block#(

parameter integer BLOCK_ID = 4'd8,

parameter integer DATA_IN_MAX_SIZE = 8,
parameter integer DATA_KEEP_SIZE = 3,

parameter integer W_SIZE_BIT = 14,

parameter integer CAL_BIT = 10,

parameter integer NUMBER_OF_NEURONS = 80,
parameter integer NEURON_SIZE_BIT = 8

)
(
input CLK,
input RESET_N,

// FROM MASTER
input START,	// TURNED ON FOR ONLY ONE CYCLE EACH
input EN,		// TURNED ON FOREVER
input REQUEST,	// TURNED ON FOR ONLY ONE CYCLE EACH
input [DATA_IN_MAX_SIZE-1:0] DATA_IN,

// FROM CTRL
input [23:0] BLOCK_INFO,

// WEIGHT SETUP
input W_VALID,
input [7:0] WEIGHT_IN,
output reg W_SET_DONE,
output reg W_REQUEST,

output reg FRONT_DONE,
output reg OUT_SPIKE_VALID,
output reg BACK_DONE,
// output reg OUT_SPIKE,
output reg [CAL_BIT-1:0] OUT_VALUE
);

reg OUT_SPIKE;

/////////////////////////
//// SETUP VARIABLES ////
/////////////////////////

reg [DATA_KEEP_SIZE-1:0] DATA_IN_KEEP;
reg [NEURON_SIZE_BIT-1:0] NUMBER_OF_MEMROW_USED;
reg [NEURON_SIZE_BIT-1:0] NUMBER_OF_OUTPUT;

reg w_set_start;
reg [3:0] column_idx_cnt;
reg [3:0] bank_idx_cnt;
reg [3:0] bank_idx_cnt_buff;
reg [8:0] row_idx_cnt;

reg [111:0] bank_buff;

//////////////////////////
//// MEMORY VARIABLES ////
//////////////////////////
reg [9:0] we;
reg [NUMBER_OF_NEURONS*W_SIZE_BIT-1:0] din;
reg bank_buff_full;

wire [7:0] addr;
wire [7:0] addr_write;

/////////////////////////
//// FRONT VARIABLES ////
/////////////////////////
reg [NEURON_SIZE_BIT:0] front_counter;

reg en_buff1;
reg en_buff2;

reg memory_read_done;

reg [DATA_IN_MAX_SIZE-1:0] data_in_buff1;
reg [DATA_IN_MAX_SIZE-1:0] data_in_buff2;
reg [NUMBER_OF_NEURONS-1:0] input_spike;

reg read_en;
wire [NUMBER_OF_NEURONS*W_SIZE_BIT-1:0] memory_one_row;
wire [CAL_BIT-2:0] weight_to_neuron [NUMBER_OF_NEURONS-1:0];	// 9bit size (for neuron weight size)

reg [NUMBER_OF_NEURONS-1:0] input_spike_passed;
reg [CAL_BIT-2:0] weight_to_neuron_passed [NUMBER_OF_NEURONS-1:0];

wire [NUMBER_OF_NEURONS-1:0] neuron_done;

wire [CAL_BIT-1:0] weight_sum_out [NUMBER_OF_NEURONS-1:0];
reg [CAL_BIT-1:0] weight_sum_out_captured [NUMBER_OF_NEURONS-1:0];

////////////////////////
//// BACK VARIABLES ////
////////////////////////

reg [1:0] is_new_block;

reg back_en;
reg [NEURON_SIZE_BIT:0] back_counter;
reg [CAL_BIT-1:0] adder1_in1_temp [39:0];
reg [CAL_BIT-1:0] adder1_in2_temp [39:0];
reg [CAL_BIT-1:0] adder1_in1_passed [39:0];
reg [CAL_BIT-1:0] adder1_in2_passed [39:0];

reg [CAL_BIT-1:0] adder2_in1 [38:0];
reg [CAL_BIT-1:0] adder2_in2 [38:0];
reg [CAL_BIT-1:0] adder3_in1 [37:0];
reg [CAL_BIT-1:0] adder3_in2 [37:0];

wire [CAL_BIT-1:0] adder1_out [39:0];
wire [CAL_BIT-1:0] adder2_out [38:0];
wire [CAL_BIT-1:0] adder3_out [37:0];
reg [CAL_BIT-1:0] adder_tree_result [9:0];
reg [CAL_BIT-1:0] adder_tree_result_buff;

wire [19:0] mulval;
wire [CAL_BIT-1:0] sigmoid_output;
reg [CAL_BIT-1:0] sigmoid_output_buff;
//wire [CAL_BIT-1:0] lfsr_out;

reg out_spike_valid_buff1;
reg out_spike_valid_buff2;

genvar i;
integer q;
integer p;


////////////////////////
// MEMORY GENERATION  //
////////////////////////
	sdfa_sram_80 u_sdfa_sram_80
	(
	   .CLK(CLK),
        .EN_M(read_en),	// ACTIVE LOW READ_ENABLE
        .WE(we),
        .ADDR(addr),
        .ADDR_WRITE(addr_write),
        .DIN(din),
        .DOUT(memory_one_row)
	);

assign addr = front_counter[7:0];
assign addr_write = w_set_start ? row_idx_cnt : 'd0;

always@(posedge CLK or negedge RESET_N) begin
	if(!RESET_N) begin
		we <= 10'h3ff;
		din <= 'd0;
	end
	else begin
		if(w_set_start) begin
			if(bank_buff_full) begin
				we[bank_idx_cnt] <= 1'd0;
				din[1008-112*bank_idx_cnt+:112] <= bank_buff;
			end
			else begin
				we <= 32'h3ff;
				din <= 'd0;
			end
		end
		else begin
			we <= 32'h3ff;
			din <= 'd0;
		end
	end
end


///////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////                SET UP                 ////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////

///////////////////////////
// BLOCK_INFO ALLOCATION //
///////////////////////////
always@(posedge CLK or negedge RESET_N) begin
	if(!RESET_N) begin
		DATA_IN_KEEP <= 'd0;
		NUMBER_OF_MEMROW_USED <= 'd0;
		NUMBER_OF_OUTPUT <= 'd0;
	end
	else begin
		if(BLOCK_INFO[23]) begin
			if(BLOCK_INFO[22:19] == BLOCK_ID) begin
				DATA_IN_KEEP <= BLOCK_INFO[18:16];
				NUMBER_OF_MEMROW_USED <= BLOCK_INFO[15:8];
				NUMBER_OF_OUTPUT <= BLOCK_INFO[7:0];
			end
		end
	end
end

////////////////////
// WEIGHT SETTING //
////////////////////
always@(posedge CLK or negedge RESET_N) begin
	if(!RESET_N) begin
		w_set_start <= 'd0;
		W_SET_DONE <= 'd0;
		W_REQUEST <= 'd0;
		
		column_idx_cnt <= 'd0;
		bank_idx_cnt <= 'd0;
		bank_idx_cnt_buff <= 'd0;
		row_idx_cnt <= 'd0;
		
		bank_buff <= 'd0;
		bank_buff_full <= 'd0;
	end
	else begin
		
		if(W_SET_DONE) begin
			w_set_start <= 1'd0;
			W_REQUEST <= 1'd0;
		end
		else begin
			w_set_start <= 1'd1;
			W_REQUEST <= 1'd1;
		end
		
		
		if(W_VALID) begin
			if(!(column_idx_cnt == 13)) begin
				column_idx_cnt <= column_idx_cnt + 1;
				bank_buff[104-8*column_idx_cnt+:8] <= WEIGHT_IN;
				
				bank_buff_full <= 1'd0;
			end
			else begin
				column_idx_cnt <= 'd0;
				bank_buff[104-8*column_idx_cnt+:8] <= WEIGHT_IN;
	
				bank_buff_full <= 1'd1;
			end 
		end
		
		if(W_VALID && (column_idx_cnt == 13) ) begin
			bank_idx_cnt_buff <= bank_idx_cnt_buff + 1;
			bank_idx_cnt <= bank_idx_cnt_buff;
		end
		else if(bank_idx_cnt == 10) begin
			bank_idx_cnt_buff <= 'd0;
			bank_idx_cnt <= 'd0;
			row_idx_cnt <= row_idx_cnt + 1;
		end
		else begin
			bank_idx_cnt <= bank_idx_cnt_buff;
		end
		
		if(row_idx_cnt == 256) begin
			W_SET_DONE <= 1'd1;
		end
	end
end


///////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////                FRONT                  ////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////
// NEURONS GENERATION //
////////////////////////
generate
for(i=0; i<NUMBER_OF_NEURONS; i=i+1) begin : OUTPUT_NEURON
	sdfa_neuron u_sdfa_neuron
	(
    .clk(CLK),
    .rstn(RESET_N),
    .cal_en(en_buff2),	// USE 2 CYCLE-DELAYED "EN" for "cal_en"
	.read_done(memory_read_done),
	.new_block(START),
    .input_spike(input_spike_passed[i]),
    .weight(weight_to_neuron_passed[i]),

	.cal_done(neuron_done[i]),
    .sum(weight_sum_out[i])
    );
end
endgenerate

////////////////////////////////////////////////////
// input_spike / weight_to_neuron BLOCKING / Pass //
////////////////////////////////////////////////////
always@(*) begin
	if(en_buff2) begin
		for(q=0; q<NUMBER_OF_NEURONS; q=q+1) begin
			weight_to_neuron_passed[q] = weight_to_neuron[q];
			input_spike_passed[q] = input_spike[q];
		end
	end
	else begin
		for(q=0; q<NUMBER_OF_NEURONS; q=q+1) begin
			weight_to_neuron_passed[q] = 'd0;
			input_spike_passed[q] = 'd0;
		end
	end
end

////////////////////////////////
// FRONT CONTROL SIGNAL LOGIC //
////////////////////////////////
always@(posedge CLK or negedge RESET_N) begin
	if(!RESET_N) begin
		data_in_buff1 <= 'd0;
		data_in_buff2 <= 'd0;
		en_buff1 <= 'd0;
		en_buff2 <= 'd0;

		read_en	<= 'd1; // ACITVE LOW
		front_counter <= 'd0;
		memory_read_done <= 'd0;

		FRONT_DONE <= 'd0;
	end
	else begin
		en_buff1 <= EN;
		en_buff2 <= en_buff1;
		data_in_buff2 <= data_in_buff1;

		if(START) begin
			read_en <= 1'd0;	// "START" 가 1cycle 동안 올라오게 되면, "read_en"은 켜주고(0으로), "memory_read_done"은 꺼준다(0으로).
			memory_read_done <= 1'd0;

			data_in_buff1 <= DATA_IN;
		end
		else begin

			if(EN) begin
				data_in_buff1 <= DATA_IN;		// "EN"이 on 일때만 "data_in_buff1"를 update.

				if(!memory_read_done) begin
					front_counter <= front_counter + 1;		// "EN"이 on이고 "memory_read_done"이 off일때만 "front_counter"를 update.
				end
				else begin
					front_counter <= front_counter;
				end
			end

			if(front_counter == NUMBER_OF_MEMROW_USED) begin
				if(!(NUMBER_OF_MEMROW_USED == 'd0)) begin
					memory_read_done <= 1'd1;
				end
			end

			if(memory_read_done) begin
				read_en <= 1'd1;
			end

			if(REQUEST) begin
				FRONT_DONE <= 1'd0;
				front_counter <= 'd0;
			end
			else begin
				if(memory_read_done) begin
					if(front_counter == NUMBER_OF_MEMROW_USED) begin
						FRONT_DONE <= 1'd1;
					end
				end
			end

		end
	end
end

/////////////////////////////////
// weight_to_neuron ALLOCATION //
/////////////////////////////////
generate
for(i=0; i<NUMBER_OF_NEURONS; i=i+1) begin : weight_buff_allocating
	assign weight_to_neuron[i] = memory_one_row[(NUMBER_OF_NEURONS-i)*14-1:(NUMBER_OF_NEURONS-(i+1))*14+5];	// use 9bits of 14bits for each weight
end
endgenerate

////////////////////////
// data_in_buff2 ALLOCATION //
////////////////////////
always@(*) begin
	if(DATA_IN_KEEP == 3'd0) begin
		for(q=0; q < 10; q=q+1) begin
			input_spike[q] = data_in_buff2[0];
		end
        for(p=10; p < NUMBER_OF_NEURONS; p=p+1) begin
            input_spike[p] = 'd0;
        end
	end
	else if(DATA_IN_KEEP == 3'd1) begin
		for(q=0; q < 10; q=q+1) begin
			input_spike[2*q] = data_in_buff2[0];
			input_spike[2*q+1] = data_in_buff2[1];
		end
        for(p=20; p < NUMBER_OF_NEURONS; p=p+1) begin
            input_spike[p] = 'd0;
        end
	end
	else if(DATA_IN_KEEP == 3'd2) begin
		for(q=0; q < 10; q=q+1) begin
			input_spike[3*q] = data_in_buff2[0];
			input_spike[3*q+1] = data_in_buff2[1];
			input_spike[3*q+2] = data_in_buff2[2];
		end
        for(p=30; p < NUMBER_OF_NEURONS; p=p+1) begin
            input_spike[p] = 'd0;
        end
	end
	else if(DATA_IN_KEEP == 3'd3) begin
		for(q=0; q < 10; q=q+1) begin
			input_spike[4*q] = data_in_buff2[0];
			input_spike[4*q+1] = data_in_buff2[1];
			input_spike[4*q+2] = data_in_buff2[2];
			input_spike[4*q+3] = data_in_buff2[3];
		end
        for (p=40; p < NUMBER_OF_NEURONS; p=p+1) begin
            input_spike[p] = 'd0;
        end
	end
	else if(DATA_IN_KEEP == 3'd4) begin
		for(q=0; q < 10; q=q+1) begin
			input_spike[5*q] = data_in_buff2[0];
			input_spike[5*q+1] = data_in_buff2[1];
			input_spike[5*q+2] = data_in_buff2[2];
			input_spike[5*q+3] = data_in_buff2[3];
			input_spike[5*q+4] = data_in_buff2[4];
		end
        for(p=50; p < NUMBER_OF_NEURONS; p=p+1) begin
            input_spike[p] = 'd0;
        end
	end
	else if(DATA_IN_KEEP == 3'd5) begin
		for(q=0; q < 10; q=q+1) begin
			input_spike[6*q] = data_in_buff2[0];
			input_spike[6*q+1] = data_in_buff2[1];
			input_spike[6*q+2] = data_in_buff2[2];
			input_spike[6*q+3] = data_in_buff2[3];
			input_spike[6*q+4] = data_in_buff2[4];
			input_spike[6*q+5] = data_in_buff2[5];
		end
        for(p=60; p < NUMBER_OF_NEURONS; p=p+1) begin
            input_spike[p] = 'd0;
        end
	end
	else if(DATA_IN_KEEP == 3'd6) begin
		for(q=0; q < 10; q=q+1) begin
			input_spike[7*q] = data_in_buff2[0];
			input_spike[7*q+1] = data_in_buff2[1];
			input_spike[7*q+2] = data_in_buff2[2];
			input_spike[7*q+3] = data_in_buff2[3];
			input_spike[7*q+4] = data_in_buff2[4];
			input_spike[7*q+5] = data_in_buff2[5];
			input_spike[7*q+6] = data_in_buff2[6];
		end
        for(p=70; p < NUMBER_OF_NEURONS; p=p+1) begin
            input_spike[p] = 'd0;
        end
	end
	else if(DATA_IN_KEEP == 3'd7) begin
		for(q=0; q < 10; q=q+1) begin
			input_spike[8*q] = data_in_buff2[0];
			input_spike[8*q+1] = data_in_buff2[1];
			input_spike[8*q+2] = data_in_buff2[2];
			input_spike[8*q+3] = data_in_buff2[3];
			input_spike[8*q+4] = data_in_buff2[4];
			input_spike[8*q+5] = data_in_buff2[5];
			input_spike[8*q+6] = data_in_buff2[6];
			input_spike[8*q+7] = data_in_buff2[7];
		end
	end
	else begin
		for(q=0; q < 80; q=q+1) begin
			input_spike[q] = 'd0;
		end
	end
end


///////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////                 BACK                  ////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////


////////////////////////
// ADDERS GENERATION  //
////////////////////////
generate
for(i=0; i<40; i=i+1) begin : Adder_Generation_L1
	sdfa_adder_module u_adder
	(
		.EN(back_en),
		.ADD_IN1(adder1_in1_passed[i]),
		.ADD_IN2(adder1_in2_passed[i]),
		.ADDER_RESULT(adder1_out[i])
	);
end
endgenerate

generate
for(i=0; i<39; i=i+1) begin : Adder_Generation_L2
	sdfa_adder_module u_adder
	(
		.EN(back_en),
		.ADD_IN1(adder2_in1[i]),
		.ADD_IN2(adder2_in2[i]),
		.ADDER_RESULT(adder2_out[i])
	);
end
endgenerate

generate
for(i=0; i<38; i=i+1) begin : Adder_Generation_L3
	sdfa_adder_module u_adder
	(
		.EN(back_en),
		.ADD_IN1(adder3_in1[i]),
		.ADD_IN2(adder3_in2[i]),
		.ADDER_RESULT(adder3_out[i])
	);
end
endgenerate

////////////////////////////////////
// adder_in1_passed BLOCK / PASS //
////////////////////////////////////
always@(*) begin
	if(back_en) begin
		for(q=0; q<40; q=q+1) begin
			adder1_in1_passed[q] = adder1_in1_temp[q];
			adder1_in2_passed[q] = adder1_in2_temp[q];
		end
	end
	else begin
		for(q=0; q<40; q=q+1) begin
			adder1_in1_passed[q] = 'd0;
			adder1_in2_passed[q] = 'd0;
		end
	end
end

///////////////////////////////
// BACK CONTROL SIGNAL LOGIC //
///////////////////////////////
always@(posedge CLK or negedge RESET_N) begin
	if(!RESET_N) begin
		back_en <= 'd0;
		back_counter <= 'd0;

		OUT_SPIKE <= 'd0;
		OUT_VALUE <= 'd0;
		OUT_SPIKE_VALID <= 'd0;
		out_spike_valid_buff1 <= 'd0;
		out_spike_valid_buff2 <= 'd0;
		BACK_DONE <= 'd0;

		for(q=0; q<NUMBER_OF_NEURONS; q=q+1) begin
			weight_sum_out_captured[q] <= 'd0;
		end
		is_new_block <= 2'd0;
		
		adder_tree_result_buff <= 'd0;
		sigmoid_output_buff <= 'd0;
	end
	else begin
		if(back_counter<10) begin
			adder_tree_result_buff <= adder_tree_result[back_counter];
		end
		OUT_SPIKE_VALID <= out_spike_valid_buff1;	

		if( (is_new_block == 2'd0) || (is_new_block == 2'd1)) begin			// 완전히 새 Block일 경우에는, 참고할 "BACK_DONE"이 없으므로, 혹은 capture 전에 Back이 끝나는 것을 안기다려도 되므로, "FRONT_DONE"만 check.
			if(FRONT_DONE) begin
				for(q=0; q<NUMBER_OF_NEURONS; q=q+1) begin
					weight_sum_out_captured[q] <= weight_sum_out[q];
				end
			end
		end
		else if(is_new_block == 2'd2) begin	// "REQUEST"를 2번 만남
			if(FRONT_DONE&&BACK_DONE) begin		// "FRONT DONE"과 "BACK_DONE"이 동시에 뜨게 되면, 즉 새로운 Front가 끝이 나고, 기존의 Back도 끝이 나면, weight_sum_out을 캡처한다.
				for(q=0; q<NUMBER_OF_NEURONS; q=q+1) begin
					weight_sum_out_captured[q] <= weight_sum_out[q];
				end
			end
		end

		if(REQUEST) begin
			back_en <= 1'd1;
			BACK_DONE <= 1'd0;

			if(is_new_block == 2'd0) begin
				is_new_block <= 2'd1;				// "REQUEST" 1번 만남. 즉 첫번째 Front가 시작된 상태.
			end
			else if(is_new_block == 2'd1) begin
				is_new_block <= 2'd2;				// "REQUEST" 2번 만남. 즉 첫번째 Block 까지 다 끝남.
			end
		end
		else begin

			if(is_new_block == 2'd2) begin
				if(adder_tree_result_buff[9] == 0) begin // >= 512 /*lfsr_out*/) begin
					if(!(back_counter == 0)) begin
						OUT_SPIKE <= 1'd1;
					end
					else begin
						OUT_SPIKE <= 1'd0;
					end
				end
				else begin
					OUT_SPIKE <= 1'd0;
				end
				OUT_VALUE <= adder_tree_result_buff;
			end
			else begin
				OUT_SPIKE <= 1'd0;
				OUT_VALUE <= 'd0;
			end		
		
			if(back_en) begin
				back_counter <= back_counter + 1;

				out_spike_valid_buff1 <= 1'd1;

			end
			else begin
				back_counter <= 'd0;

				out_spike_valid_buff1 <= 1'd0;
				//OUT_SPIKE <= 1'd0;

				if(is_new_block == 2'd1) begin
					if(out_spike_valid_buff1) begin
						BACK_DONE <= 1'd1;
					end
				end
				if(back_counter == NUMBER_OF_OUTPUT+1) begin
					if(!(NUMBER_OF_OUTPUT=='d0)) begin
						BACK_DONE <= 1'd1;
					end
				end

			end

			if((is_new_block==2'd1)||(back_counter == NUMBER_OF_OUTPUT)) begin
				back_en <= 1'd0;
			end

		end
	end
end


///////////////////////
// ADDER TREE MUXING //
///////////////////////
always@(*) begin

	if(DATA_IN_KEEP == 3'd0) begin		//// COMBINE 1 ////
		for(q=0; q<40; q=q+1) begin	// L1
			adder1_in1_temp[q] = 'd0;
			adder1_in2_temp[q] = 'd0;
		end
		for(q=0; q<39; q=q+1) begin  // L2
			adder2_in1[q] = 'd0;
			adder2_in2[q] = 'd0;
		end
		for(q=0; q<38; q=q+1) begin	// L3
			adder3_in1[q] = 'd0;
			adder3_in2[q] = 'd0;
		end
		
		for(q=0; q<10; q=q+1) begin	// Result
			adder_tree_result[q] = weight_sum_out_captured[q]; 
		end
	end
	
	else if(DATA_IN_KEEP == 3'd1) begin	//// COMBINE 2 ////
		for(q=0; q<10; q=q+1) begin	// L1
			adder1_in1_temp[q] = weight_sum_out_captured[2*q];
			adder1_in2_temp[q] = weight_sum_out_captured[2*q+1];
		end
		for(q=10; q<40; q=q+1) begin
			adder1_in1_temp[q] = 'd0;
			adder1_in2_temp[q] = 'd0;
		end
		
		for(q=0; q<39; q=q+1) begin  // L2
			adder2_in1[q] = 'd0;
			adder2_in2[q] = 'd0;
		end
		for(q=0; q<38; q=q+1) begin	// L3
			adder3_in1[q] = 'd0;
			adder3_in2[q] = 'd0;
		end	
		
		for(q=0; q<10; q=q+1) begin	// Result
			adder_tree_result[q] = adder1_out[q];
		end
	end
	
	else if(DATA_IN_KEEP == 3'd2) begin	//// COMBINT 3 ////
		
		for(q=0; q<5; q=q+1) begin		// L1
			adder1_in1_temp[3*q] = weight_sum_out_captured[6*q];
			adder1_in2_temp[3*q] = weight_sum_out_captured[6*q+1];

			adder1_in1_temp[3*q+1] = 'd0;
			adder1_in2_temp[3*q+1] = 'd0;			
			
			adder1_in1_temp[3*q+2] = weight_sum_out_captured[6*q+4];
			adder1_in2_temp[3*q+2] = weight_sum_out_captured[6*q+5];			
		end
		for(q=15; q<40; q=q+1) begin
			adder1_in1_temp[q] = 'd0;
			adder1_in2_temp[q] = 'd0;			
		end

		for(q=0; q<5; q=q+1) begin		// L2
			adder2_in1[3*q] = adder1_out[3*q];
			adder2_in2[3*q] = weight_sum_out_captured[6*q+2];
			
			adder2_in1[3*q+1] = weight_sum_out_captured[6*q+3];
			adder2_in2[3*q+1] = adder1_out[3*q+2];
			
			adder2_in1[3*q+2] = 'd0;
			adder2_in2[3*q+2] = 'd0;
		end
		for(q=15; q<39; q=q+1) begin
			adder2_in1[q] = 'd0;
			adder2_in2[q] = 'd0;			
		end
		
		for(q=0; q<38; q=q+1) begin	// L3
			adder3_in1[q] = 'd0;
			adder3_in2[q] = 'd0;
		end
		
		for(q=0; q<5; q=q+1) begin	// Result
			adder_tree_result[2*q] = adder2_out[3*q];
			adder_tree_result[2*q+1] = adder2_out[3*q+1];
		end	
	end
	
	else if(DATA_IN_KEEP == 3'd3) begin	//// COMBINE 4 ////

		for(q=0; q<20; q=q+1) begin	// L1
			adder1_in1_temp[q] = weight_sum_out_captured[2*q];
			adder1_in2_temp[q] = weight_sum_out_captured[2*q+1];		
		end
		for(q=20; q<40; q=q+1) begin
			adder1_in1_temp[q] = 'd0;
			adder1_in2_temp[q] = 'd0;					
		end

		for(q=0; q<10; q=q+1) begin		// L2	
			adder2_in1[2*q] = adder1_out[2*q];
			adder2_in2[2*q] = adder1_out[2*q+1];

			adder2_in1[2*q+1] = 'd0;
			adder2_in2[2*q+1] = 'd0;
		end
		for(q=20; q<39; q=q+1) begin
			adder2_in1[q] = 'd0;
			adder2_in2[q] = 'd0;		
		end
		
		for(q=0; q<38; q=q+1) begin	// L3
			adder3_in1[q] = 'd0;
			adder3_in2[q] = 'd0;
		end
		
		for(q=0; q<10; q=q+1) begin	// Result
			adder_tree_result[q] = adder2_out[2*q];
		end
	end	
	
	else if(DATA_IN_KEEP == 3'd4) begin	//// COMBINE 5 ////

		for(q=0; q<5; q=q+1) begin		// L1
			adder1_in1_temp[5*q] = weight_sum_out_captured[10*q];
			adder1_in2_temp[5*q] = weight_sum_out_captured[10*q+1];
			
			adder1_in1_temp[5*q+1] = weight_sum_out_captured[10*q+2];
			adder1_in2_temp[5*q+1] = weight_sum_out_captured[10*q+3];			
			
			adder1_in1_temp[5*q+2] = 'd0;
			adder1_in2_temp[5*q+2] = 'd0;

			adder1_in1_temp[5*q+3] = weight_sum_out_captured[10*q+6];
			adder1_in2_temp[5*q+3] = weight_sum_out_captured[10*q+7];		

			adder1_in1_temp[5*q+4] = weight_sum_out_captured[10*q+8];
			adder1_in2_temp[5*q+4] = weight_sum_out_captured[10*q+9];				
		end
		for(q=25; q<40; q=q+1) begin
			adder1_in1_temp[q] = 'd0;
			adder1_in2_temp[q] = 'd0;			
		end
		
		for(q=0; q<5; q=q+1) begin		// L2
			adder2_in1[5*q] = adder1_out[5*q];
			adder2_in2[5*q] = adder1_out[5*q+1];
			
			adder2_in1[5*q+1] = 'd0;
			adder2_in2[5*q+1] = 'd0;
			adder2_in1[5*q+2] = 'd0;
			adder2_in2[5*q+2] = 'd0;
			
			adder2_in1[5*q+3] = adder1_out[5*q+3];
			adder2_in2[5*q+3] = adder1_out[5*q+4];			
			
			adder2_in1[5*q+4] = 'd0;
			adder2_in2[5*q+4] = 'd0;			
		end
		for(q=25; q<39; q=q+1) begin
			adder2_in1[q] = 'd0;
			adder2_in2[q] = 'd0;		
		end
		
		for(q=0; q<5; q=q+1) begin		// L3
			adder3_in1[5*q] = adder2_out[5*q];
			adder3_in2[5*q] = weight_sum_out_captured[10*q+4];
			
			adder3_in1[5*q+1] = 'd0;
			adder3_in2[5*q+1] = 'd0;
			
			adder3_in1[5*q+2] = weight_sum_out_captured[10*q+5];
			adder3_in2[5*q+2] = adder2_out[5*q+3];

			adder3_in1[5*q+3] = 'd0;
			adder3_in2[5*q+3] = 'd0;		
			adder3_in1[5*q+4] = 'd0;
			adder3_in2[5*q+4] = 'd0;			
		end
		for(q=25; q<38; q=q+1) begin
			adder3_in1[q] = 'd0;
			adder3_in2[q] = 'd0;			
		end

		for(q=0; q<5; q=q+1) begin	// Result
			adder_tree_result[2*q] = adder3_out[5*q];
			adder_tree_result[2*q+1] = adder3_out[5*q+2];
		end
	end		
	
	else if(DATA_IN_KEEP == 3'd5) begin	//// COMBINE 6 ////

		for(q=0; q<10; q=q+1) begin		// L1
			adder1_in1_temp[3*q] = weight_sum_out_captured[6*q];
			adder1_in2_temp[3*q] = weight_sum_out_captured[6*q+1];			

			adder1_in1_temp[3*q+1] = weight_sum_out_captured[6*q+2];
			adder1_in2_temp[3*q+1] = weight_sum_out_captured[6*q+3];						

			adder1_in1_temp[3*q+2] = weight_sum_out_captured[6*q+4];
			adder1_in2_temp[3*q+2] = weight_sum_out_captured[6*q+5];			
		end
		for(q=30; q<40; q=q+1) begin
			adder1_in1_temp[q] = 'd0;
			adder1_in2_temp[q] = 'd0;		
		end
		
		for(q=0; q<10; q=q+1) begin		// L2
			adder2_in1[3*q] = adder1_out[3*q];
			adder2_in2[3*q] = adder1_out[3*q+1];

			adder2_in1[3*q+1] = 'd0;
			adder2_in2[3*q+1] = 'd0;			
			adder2_in1[3*q+2] = 'd0;
			adder2_in2[3*q+2] = 'd0;			
		end
		for(q=30; q<39; q=q+1) begin
			adder2_in1[q] = 'd0;
			adder2_in2[q] = 'd0;				
		end
		
		for(q=0; q<10; q=q+1) begin		// L3
			adder3_in1[3*q] = adder2_out[3*q];
			adder3_in2[3*q] = adder1_out[3*q+2];		

			adder3_in1[3*q+1] = 'd0;
			adder3_in2[3*q+1] = 'd0;
			adder3_in1[3*q+2] = 'd0;
			adder3_in2[3*q+2] =	'd0;	
		end
		for(q=30; q<38; q=q+1) begin
			adder3_in1[q] = 'd0;
			adder3_in2[q] = 'd0;			
		end
		
		for(q=0; q<10; q=q+1) begin		// Result
			adder_tree_result[q] = adder3_out[3*q];
		end
	end		
	
	else if(DATA_IN_KEEP == 3'd6) begin	//// COMBINE 7 ////

		for(q=0; q<5; q=q+1) begin		// L1
			adder1_in1_temp[7*q] = weight_sum_out_captured[14*q];
			adder1_in2_temp[7*q] = weight_sum_out_captured[14*q+1];
			adder1_in1_temp[7*q+1] = weight_sum_out_captured[14*q+2];
			adder1_in2_temp[7*q+1] = weight_sum_out_captured[14*q+3];
			adder1_in1_temp[7*q+2] = weight_sum_out_captured[14*q+4];
			adder1_in2_temp[7*q+2] = weight_sum_out_captured[14*q+5];

			adder1_in1_temp[7*q+3] = 'd0;
			adder1_in2_temp[7*q+3] = 'd0;
			
			adder1_in1_temp[7*q+4] = weight_sum_out_captured[14*q+8];
			adder1_in2_temp[7*q+4] = weight_sum_out_captured[14*q+9];
			adder1_in1_temp[7*q+5] = weight_sum_out_captured[14*q+10];
			adder1_in2_temp[7*q+5] = weight_sum_out_captured[14*q+11];
			adder1_in1_temp[7*q+6] = weight_sum_out_captured[14*q+12];
			adder1_in2_temp[7*q+6] = weight_sum_out_captured[14*q+13];		
		end
		for(q=35; q<40; q=q+1) begin
			adder1_in1_temp[q] = 'd0;
			adder1_in2_temp[q] = 'd0;						
		end

		for(q=0; q<5; q=q+1) begin		// L2
			adder2_in1[7*q] = adder1_out[7*q];
			adder2_in2[7*q] = adder1_out[7*q+1];

			adder2_in1[7*q+1] = 'd0;
			adder2_in2[7*q+1] = 'd0;

			adder2_in1[7*q+2] = adder1_out[7*q+2];
			adder2_in2[7*q+2] = weight_sum_out_captured[14*q+6];

			adder2_in1[7*q+3] = weight_sum_out_captured[14*q+7];
			adder2_in2[7*q+3] = adder1_out[7*q+4];			

			adder2_in1[7*q+4] = 'd0;
			adder2_in2[7*q+4] = 'd0;

			adder2_in1[7*q+5] = adder1_out[7*q+5];
			adder2_in2[7*q+5] = adder1_out[7*q+6];			

			adder2_in1[7*q+6] = 'd0;
			adder2_in2[7*q+6] = 'd0;			
		end
		for(q=35; q<39; q=q+1) begin
			adder2_in1[q] = 'd0;
			adder2_in2[q] = 'd0;						
		end

		for(q=0; q<5; q=q+1) begin		// L3
			adder3_in1[7*q] = adder2_out[7*q];
			adder3_in2[7*q] = adder2_out[7*q+2];
			
			adder3_in1[7*q+1] = 'd0;
			adder3_in2[7*q+1] = 'd0;
			adder3_in1[7*q+2] = 'd0;
			adder3_in2[7*q+2] = 'd0;			
			adder3_in1[7*q+3] = 'd0;
			adder3_in2[7*q+3] = 'd0;		

			adder3_in1[7*q+4] = adder2_out[7*q+3];
			adder3_in2[7*q+4] = adder2_out[7*q+5];			

			adder3_in1[7*q+5] = 'd0;
			adder3_in2[7*q+5] = 'd0;			
			adder3_in1[7*q+6] = 'd0;
			adder3_in2[7*q+6] = 'd0;		
		end
		for(q=35; q<38; q=q+1) begin
			adder3_in1[q] = 'd0;
			adder3_in2[q] = 'd0;		
		end
			
		for(q=0; q<5; q=q+1) begin		// Result
			adder_tree_result[2*q] = adder3_out[7*q];
			adder_tree_result[2*q+1] = adder3_out[7*q+4];
		end
	end		
	
	else if(DATA_IN_KEEP == 3'd7) begin	//// COMBINE 8 ////

		for(q=0; q<40; q=q+1) begin	// L1
			adder1_in1_temp[q] = weight_sum_out_captured[2*q];
			adder1_in2_temp[q] = weight_sum_out_captured[2*q+1];				
		end
		
		for(q=0; q<19; q=q+1) begin		// L2
			adder2_in1[2*q] = adder1_out[2*q];
			adder2_in2[2*q] = adder1_out[2*q+1];
			
			adder2_in1[2*q+1] = 'd0;
			adder2_in2[2*q+1] = 'd0;			
		end
			adder2_in1[38] = adder1_out[38];
			adder2_in2[38] = adder1_out[39];
		
		for(q=0; q<9; q=q+1) begin		// L3
			adder3_in1[4*q] = adder2_out[4*q];
			adder3_in2[4*q] = adder2_out[4*q+2];

			adder3_in1[4*q+1] = 'd0;
			adder3_in2[4*q+1] = 'd0;
			adder3_in1[4*q+2] = 'd0;
			adder3_in2[4*q+2] = 'd0;
			adder3_in1[4*q+3] = 'd0;
			adder3_in2[4*q+3] = 'd0;			
		end
			adder3_in1[36] = adder2_out[36];
			adder3_in2[36] = adder2_out[38];
			adder3_in1[37] = 'd0;
			adder3_in2[37] = 'd0;
			
		for(q=0; q<10; q=q+1) begin		// Result
			adder_tree_result[q] = adder3_out[4*q];
		end
	end		
	
	else begin							//// DEFAULT ////
		for(q=0; q<40; q=q+1) begin	// L1
			adder1_in1_temp[q] = 'd0;
			adder1_in2_temp[q] = 'd0;
		end
		for(q=0; q<39; q=q+1) begin  // L2
			adder2_in1[q] = 'd0;
			adder2_in2[q] = 'd0;
		end
		for(q=0; q<38; q=q+1) begin	// L3
			adder3_in1[q] = 'd0;
			adder3_in2[q] = 'd0;
		end
		
		for(q=0; q<10; q=q+1) begin	// Result
			adder_tree_result[q] = 'd0;
		end
	end
	
end

endmodule
