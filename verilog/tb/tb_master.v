// Testbench file for master
// Author : Yeonsoo

`timescale 1ns/1ps

module tb_sdfa_master;

//	reg [1023:0] vcdfile = "tb_top.vcd";

	//parameters
	localparam BLOCK_NUM      = 8;
	localparam ADDR_WIDTH     = 3;
	localparam BLOCK_ID_WIDTH = 33;

// input
	//default
	reg[ADDR_WIDTH-1:0]			LAYER;									//전체 레이어 개수
	// reg[BLOCK_NUM-1:0]			BLOCK_ID[BLOCK_NUM-1:0];				//layer-다음block-priority-이전block개수


	// reg[BLOCK_NUM-1:0]			BLOCK_NUM_PER_LAYER[BLOCK_NUM-1:0];		//레이어 별 블락의 개수


	// reg[BLOCK_NUM-1:0]			NEURON_NUM_PER_BLOCK[BLOCK_NUM-1:0];	//블락 별 뉴런의 개수
	// reg[BLOCK_NUM-1:0]			NEURON_OUT_NUM_PER_BLOCK[BLOCK_NUM-1:0];//블락의 뉴런 출력 개수
	// BLOCK_ID 추가

	reg[BLOCK_NUM-1:0]			LAST_LAYER_BLOCK;
	//ctrl
	reg							clk;
	reg							rstn;
	reg							start; 				//start process
	reg[BLOCK_NUM-1:0]			block_back_done; 		//one-hot enconding, which block finished
	reg[BLOCK_NUM-1:0]			block_front_done; 		//one-hot enconding, which block finished

	reg[BLOCK_NUM-1:0]			block_valid;
	reg 						feature_valid;

	//data
	reg[BLOCK_NUM-1:0]			feature;
	reg[ADDR_WIDTH-1:0]			feature_keep;
	reg[BLOCK_NUM-1:0]			block_result_data;	//block 계산 결과
// output
	//ctrl
	wire						done;
	wire						block_en;
	wire[BLOCK_NUM-1:0]			block_using;
	wire[ADDR_WIDTH -1:0]		block_keep[BLOCK_NUM-1:0];
	wire 						setup_request;
	//data
	wire[BLOCK_NUM -1:0]		neuron_use[BLOCK_NUM-1:0];
	wire[BLOCK_NUM -1:0]		neuron_out[BLOCK_NUM-1:0];
	wire[BLOCK_NUM -1:0]		block_input_data[ADDR_WIDTH-1:0];	//block 계산 결과를 다음 레이어에 모두 전송
	wire[BLOCK_NUM -1:0]		last; 								//모든 레이어에는 같은 결과 들어감
	wire[ADDR_WIDTH-1:0]		last_keep;



////////for tb only/////////

	reg 						data_send;
	reg[BLOCK_NUM-1:0] 			counter;
	wire[BLOCK_NUM-1:0]			block_result_request;
	integer i;
    reg [256*14-1:0] weight [255:0];
    reg[BLOCK_ID_WIDTH-1:0]	 	BLOCK_ID_INPUT;
    reg[ADDR_WIDTH-1:0]			BLOCK_NUM_PER_LAYER_INPUT;
    reg[BLOCK_NUM-1:0]			READ_BLOCK_INPUT;
    reg 						setup_valid;
///////////////////////////





	// clock
	initial begin
		clk = 1'b0;
		forever #(0.5) clk = ~clk;
	end

	// initialize parameters
	// 800 * 256 * 200 * 10
//        $vcdplusfile(vcdfile);
//        $vcdpluson();

	sdfa_master #(
		.BLOCK_NUM(BLOCK_NUM), 								//전체 블락의 개수
		.ADDR_WIDTH(ADDR_WIDTH)
	)
		u_sdfa_master
	(
	//input
		//default
		.LAYER(LAYER), 										//전체 레이어 개수
		.BLOCK_ID_INPUT(BLOCK_ID_INPUT),
		// .BLOCK_ID_0(BLOCK_ID_0),
		// .BLOCK_ID_1(BLOCK_ID_1),
		// .BLOCK_ID_2(BLOCK_ID_2),
		// .BLOCK_ID_3(BLOCK_ID_3),
		// .BLOCK_ID_4(BLOCK_ID_4),
		// .BLOCK_ID_5(BLOCK_ID_5),
		// .BLOCK_ID_6(BLOCK_ID_6),
		// .BLOCK_ID_7(BLOCK_ID_7),

		.BLOCK_NUM_PER_LAYER_INPUT(BLOCK_NUM_PER_LAYER_INPUT), 			//레이어 별 블락의 개수
		// .BLOCK_NUM_PER_LAYER_0(BLOCK_NUM_PER_LAYER_0),
		// .BLOCK_NUM_PER_LAYER_1(BLOCK_NUM_PER_LAYER_1),
		// .BLOCK_NUM_PER_LAYER_2(BLOCK_NUM_PER_LAYER_2),
		// .BLOCK_NUM_PER_LAYER_3(BLOCK_NUM_PER_LAYER_3),
		// .BLOCK_NUM_PER_LAYER_4(BLOCK_NUM_PER_LAYER_4),
		// .BLOCK_NUM_PER_LAYER_5(BLOCK_NUM_PER_LAYER_5),
		// .BLOCK_NUM_PER_LAYER_6(BLOCK_NUM_PER_LAYER_6),
		// .BLOCK_NUM_PER_LAYER_7(BLOCK_NUM_PER_LAYER_7),


		// .NEURON_NUM_PER_BLOCK(NEURON_NUM_PER_BLOCK),		//블락 별 뉴런의 개수
		// .NEURON_OUT_NUM_PER_BLOCK(NEURON_OUT_NUM_PER_BLOCK),//블락의 뉴런 출력 개수
		.READ_BLOCK_INPUT(READ_BLOCK_INPUT),
		// .READ_BLOCK_0(READ_BLOCK_0),
		// .READ_BLOCK_1(READ_BLOCK_1),
		// .READ_BLOCK_2(READ_BLOCK_2),
		// .READ_BLOCK_3(READ_BLOCK_3),
		// .READ_BLOCK_4(READ_BLOCK_4),
		// .READ_BLOCK_5(READ_BLOCK_5),
		// .READ_BLOCK_6(READ_BLOCK_6),
		// .READ_BLOCK_7(READ_BLOCK_7),

		//ctrl
		.clk(clk),
		.rstn(rstn),
		.start(start), 										//start process
		.block_back_done(block_back_done), 							//one-hot enconding, which block finished
		// .block_front_done(block_front_done),
		.feature_valid(feature_valid),
		.setup_request(setup_request),
		.setup_valid(setup_valid),
		//data
		.feature(feature),
		// .block_valid(block_valid),
		// .block_result_data(block_result_data),
//		.block_in_data(block_in_data),
	//output
		//ctrl
		.done(done),
		.block_result_request(block_result_request),
		//data
//		.block_out_data(block_out_data),					//모든 layer에 같은 데이터 들어감
		.last(last)

	);

    always@(posedge clk) begin
    	if(data_send) begin
        	// block_result_data <= block_result_data + 1;
    		// block_valid <= 8'b1111_1111;
    		if(counter == 0) begin
    			feature <= 8'b1111_1111;
    		end
    		else begin
    			feature <= 0;
    		end
    		feature_valid <= 1;
    		counter <= counter + 1;
    		if(done == 1) begin
    			data_send <= 0;
    			block_valid <= 0;
    			feature_valid <= 0;
    		end
    	end
    	else if(block_result_request) begin
    		data_send <= 1;
    	end
    	else begin
    		// block_result_data <= 0;
    		// block_valid <= 0;
    		feature_valid <= 0;
    		feature <= 0;
    		counter <= 0;
    	end
    end

    initial begin
 	    // BLOCK_ID_0 = 33'b_11111111_11111111_000_11111111_111_001;
		// BLOCK_ID_1 = 33'b_11111111_11111111_000_11111111_111_001;
		// BLOCK_ID_2 = 33'b_11111111_11111111_000_11111111_111_001;
		// BLOCK_ID_3 = 33'b_11111111_11111111_000_11111111_111_001;
		// BLOCK_ID_4 = 33'b_11111111_11111111_000_11111111_111_001;
		// BLOCK_ID_5 = 33'b_11111111_11111111_000_11111111_111_001;
		// BLOCK_ID_6 = 33'b_11111111_11111111_001_11111111_011_010; //3개씩 2세트
		// BLOCK_ID_7 = 0;

		// BLOCK_NUM_PER_LAYER_0 = 6;
		// BLOCK_NUM_PER_LAYER_1 = 1;
		// BLOCK_NUM_PER_LAYER_2 = 0;
		// BLOCK_NUM_PER_LAYER_3 = 0;
		// BLOCK_NUM_PER_LAYER_4 = 0;
		// BLOCK_NUM_PER_LAYER_5 = 0;
		// BLOCK_NUM_PER_LAYER_6 = 0;
		// BLOCK_NUM_PER_LAYER_7 = 0;

		// READ_BLOCK_0 = 0;
		// READ_BLOCK_1 = 0;
		// READ_BLOCK_2 = 0;
		// READ_BLOCK_3 = 0;
		// READ_BLOCK_4 = 0;
		// READ_BLOCK_5 = 0;
		// READ_BLOCK_6 = 8'b0000_0111;
		// READ_BLOCK_7 = 0;


		wait(setup_request);
		#0.1;
		setup_valid <= 1;
		// {layer, block counter max, 한번에 읽을 비트 수, group counter max}
		// BLOCK_ID_INPUT <= 33'b_11111111_11111111_000_11111111_111_001;
		// BLOCK_NUM_PER_LAYER_INPUT <= 6;
		BLOCK_ID_INPUT <= 33'b_00111111_11000011_000_11000011_100_001;
		BLOCK_NUM_PER_LAYER_INPUT <= 4;
		READ_BLOCK_INPUT <= 0;
		#1

		// BLOCK_ID_INPUT = 33'b_11111111_11111111_000_11111111_111_001;
		// BLOCK_NUM_PER_LAYER_INPUT = 1;
		BLOCK_ID_INPUT <= 33'b_00111111_11000011_000_11000011_100_001;
		BLOCK_NUM_PER_LAYER_INPUT <= 2;
		READ_BLOCK_INPUT = 0;
		#1

		// BLOCK_ID_INPUT <= 33'b_11111111_11111111_000_11111111_111_001;
		// BLOCK_NUM_PER_LAYER_INPUT <= 0;
		BLOCK_ID_INPUT <= 33'b_00111111_11000011_000_11000011_100_001;
		BLOCK_NUM_PER_LAYER_INPUT <= 1;
		READ_BLOCK_INPUT <= 0;
		#1

		// BLOCK_ID_INPUT <= 33'b_11111111_11111111_000_11111111_111_001;
		// BLOCK_NUM_PER_LAYER_INPUT <= 0;
		BLOCK_ID_INPUT <= 33'b_00111111_11000011_000_11000011_100_001;
		BLOCK_NUM_PER_LAYER_INPUT <= 0;
		READ_BLOCK_INPUT <= 0;
		#1

		// BLOCK_ID_INPUT <= 33'b_11111111_11111111_000_11111111_111_001;

		BLOCK_ID_INPUT <= 33'b_01111111_01111111_001_11111111_010_010;
		BLOCK_NUM_PER_LAYER_INPUT <= 0;
		READ_BLOCK_INPUT <= 8'b0000_0011;
		#1

		// BLOCK_ID_INPUT <= 33'b_11111111_11111111_000_11111111_111_001;
		BLOCK_ID_INPUT <= 33'b_01111111_01111111_001_11111111_010_010;
		BLOCK_NUM_PER_LAYER_INPUT <= 0;
		READ_BLOCK_INPUT <= 8'b0000_0011;
		#1

		// BLOCK_ID_INPUT <= 33'b_11111111_11111111_001_11111111_011_010; //3개씩 2세트
		BLOCK_ID_INPUT <= 0;
		BLOCK_NUM_PER_LAYER_INPUT <= 0;
		READ_BLOCK_INPUT <= 0;
		#1

		BLOCK_ID_INPUT = 0;
		BLOCK_NUM_PER_LAYER_INPUT <= 0;
		READ_BLOCK_INPUT <= 0;
		#1
		setup_valid <= 0;

    end

	initial begin
		LAYER = 2;
		feature_valid <= 0;
		feature <= 0;
        start <= 0;
		rstn <= 1'b1;
		block_result_data <= 0;
		counter <= 0;
		data_send <= 0;
		#20
		rstn <= 1'b0;
        #0.1
		repeat (100)
          @(posedge clk);
        rstn <= 1'b1;

//////////////////////////

        $readmemb("weight_value.txt", weight);

        for (i = 0; i < 256; i = i + 1) begin
            #1
                force tb_sdfa_master.u_sdfa_master.sdfa_block_0.u_sdfa_sram_256.ADDR = i;
                force tb_sdfa_master.u_sdfa_master.sdfa_block_0.u_sdfa_sram_256.EN_M = 1'b1;
                force tb_sdfa_master.u_sdfa_master.sdfa_block_0.u_sdfa_sram_256.WE = 32'h0;
            #1
                force tb_sdfa_master.u_sdfa_master.sdfa_block_0.u_sdfa_sram_256.DIN = weight[i];
        end

        release tb_sdfa_master.u_sdfa_master.sdfa_block_0.u_sdfa_sram_256.ADDR;
        release tb_sdfa_master.u_sdfa_master.sdfa_block_0.u_sdfa_sram_256.EN_M;
        release tb_sdfa_master.u_sdfa_master.sdfa_block_0.u_sdfa_sram_256.WE;
        release tb_sdfa_master.u_sdfa_master.sdfa_block_0.u_sdfa_sram_256.DIN;
        #1

        for (i = 0; i < 256; i = i + 1) begin
            #1
                force tb_sdfa_master.u_sdfa_master.sdfa_block_1.u_sdfa_sram_256.ADDR = i;
                force tb_sdfa_master.u_sdfa_master.sdfa_block_1.u_sdfa_sram_256.EN_M = 1'b1;
                force tb_sdfa_master.u_sdfa_master.sdfa_block_1.u_sdfa_sram_256.WE = 32'h0;
            #1
                force tb_sdfa_master.u_sdfa_master.sdfa_block_1.u_sdfa_sram_256.DIN = weight[i];
        end

        release tb_sdfa_master.u_sdfa_master.sdfa_block_1.u_sdfa_sram_256.ADDR;
        release tb_sdfa_master.u_sdfa_master.sdfa_block_1.u_sdfa_sram_256.EN_M;
        release tb_sdfa_master.u_sdfa_master.sdfa_block_1.u_sdfa_sram_256.WE;
        release tb_sdfa_master.u_sdfa_master.sdfa_block_1.u_sdfa_sram_256.DIN;
        #1

        for (i = 0; i < 256; i = i + 1) begin
            #1
                force tb_sdfa_master.u_sdfa_master.sdfa_block_2.u_sdfa_sram_256.ADDR = i;
                force tb_sdfa_master.u_sdfa_master.sdfa_block_2.u_sdfa_sram_256.EN_M = 1'b1;
                force tb_sdfa_master.u_sdfa_master.sdfa_block_2.u_sdfa_sram_256.WE = 32'h0;
            #1
                force tb_sdfa_master.u_sdfa_master.sdfa_block_2.u_sdfa_sram_256.DIN = weight[i];
        end

        release tb_sdfa_master.u_sdfa_master.sdfa_block_2.u_sdfa_sram_256.ADDR;
        release tb_sdfa_master.u_sdfa_master.sdfa_block_2.u_sdfa_sram_256.EN_M;
        release tb_sdfa_master.u_sdfa_master.sdfa_block_2.u_sdfa_sram_256.WE;
        release tb_sdfa_master.u_sdfa_master.sdfa_block_2.u_sdfa_sram_256.DIN;
        #1

        for (i = 0; i < 256; i = i + 1) begin
            #1
                force tb_sdfa_master.u_sdfa_master.sdfa_block_3.u_sdfa_sram_256.ADDR = i;
                force tb_sdfa_master.u_sdfa_master.sdfa_block_3.u_sdfa_sram_256.EN_M = 1'b1;
                force tb_sdfa_master.u_sdfa_master.sdfa_block_3.u_sdfa_sram_256.WE = 32'h0;
            #1
                force tb_sdfa_master.u_sdfa_master.sdfa_block_3.u_sdfa_sram_256.DIN = weight[i];
        end

        release tb_sdfa_master.u_sdfa_master.sdfa_block_3.u_sdfa_sram_256.ADDR;
        release tb_sdfa_master.u_sdfa_master.sdfa_block_3.u_sdfa_sram_256.EN_M;
        release tb_sdfa_master.u_sdfa_master.sdfa_block_3.u_sdfa_sram_256.WE;
        release tb_sdfa_master.u_sdfa_master.sdfa_block_3.u_sdfa_sram_256.DIN;
        #1

        for (i = 0; i < 256; i = i + 1) begin
            #1
                force tb_sdfa_master.u_sdfa_master.sdfa_block_4.u_sdfa_sram_256.ADDR = i;
                force tb_sdfa_master.u_sdfa_master.sdfa_block_4.u_sdfa_sram_256.EN_M = 1'b1;
                force tb_sdfa_master.u_sdfa_master.sdfa_block_4.u_sdfa_sram_256.WE = 32'h0;
            #1
                force tb_sdfa_master.u_sdfa_master.sdfa_block_4.u_sdfa_sram_256.DIN = weight[i];
        end

        release tb_sdfa_master.u_sdfa_master.sdfa_block_4.u_sdfa_sram_256.ADDR;
        release tb_sdfa_master.u_sdfa_master.sdfa_block_4.u_sdfa_sram_256.EN_M;
        release tb_sdfa_master.u_sdfa_master.sdfa_block_4.u_sdfa_sram_256.WE;
        release tb_sdfa_master.u_sdfa_master.sdfa_block_4.u_sdfa_sram_256.DIN;
        #1

        for (i = 0; i < 256; i = i + 1) begin
            #1
                force tb_sdfa_master.u_sdfa_master.sdfa_block_5.u_sdfa_sram_256.ADDR = i;
                force tb_sdfa_master.u_sdfa_master.sdfa_block_5.u_sdfa_sram_256.EN_M = 1'b1;
                force tb_sdfa_master.u_sdfa_master.sdfa_block_5.u_sdfa_sram_256.WE = 32'h0;
            #1
                force tb_sdfa_master.u_sdfa_master.sdfa_block_5.u_sdfa_sram_256.DIN = weight[i];
        end

        release tb_sdfa_master.u_sdfa_master.sdfa_block_5.u_sdfa_sram_256.ADDR;
        release tb_sdfa_master.u_sdfa_master.sdfa_block_5.u_sdfa_sram_256.EN_M;
        release tb_sdfa_master.u_sdfa_master.sdfa_block_5.u_sdfa_sram_256.WE;
        release tb_sdfa_master.u_sdfa_master.sdfa_block_5.u_sdfa_sram_256.DIN;
        #1

        for (i = 0; i < 256; i = i + 1) begin
            #1
                force tb_sdfa_master.u_sdfa_master.sdfa_block_6.u_sdfa_sram_256.ADDR = i;
                force tb_sdfa_master.u_sdfa_master.sdfa_block_6.u_sdfa_sram_256.EN_M = 1'b1;
                force tb_sdfa_master.u_sdfa_master.sdfa_block_6.u_sdfa_sram_256.WE = 32'h0;
            #1
                force tb_sdfa_master.u_sdfa_master.sdfa_block_6.u_sdfa_sram_256.DIN = weight[i];
        end

        release tb_sdfa_master.u_sdfa_master.sdfa_block_6.u_sdfa_sram_256.ADDR;
        release tb_sdfa_master.u_sdfa_master.sdfa_block_6.u_sdfa_sram_256.EN_M;
        release tb_sdfa_master.u_sdfa_master.sdfa_block_6.u_sdfa_sram_256.WE;
        release tb_sdfa_master.u_sdfa_master.sdfa_block_6.u_sdfa_sram_256.DIN;
        #1

        for (i = 0; i < 256; i = i + 1) begin
            #1
                force tb_sdfa_master.u_sdfa_master.sdfa_block_7.u_sdfa_sram_256.ADDR = i;
                force tb_sdfa_master.u_sdfa_master.sdfa_block_7.u_sdfa_sram_256.EN_M = 1'b1;
                force tb_sdfa_master.u_sdfa_master.sdfa_block_7.u_sdfa_sram_256.WE = 32'h0;
            #1
                force tb_sdfa_master.u_sdfa_master.sdfa_block_7.u_sdfa_sram_256.DIN = weight[i];
        end

        release tb_sdfa_master.u_sdfa_master.sdfa_block_7.u_sdfa_sram_256.ADDR;
        release tb_sdfa_master.u_sdfa_master.sdfa_block_7.u_sdfa_sram_256.EN_M;
        release tb_sdfa_master.u_sdfa_master.sdfa_block_7.u_sdfa_sram_256.WE;
        release tb_sdfa_master.u_sdfa_master.sdfa_block_7.u_sdfa_sram_256.DIN;
        #20

        $display("***** Force write is done *****\n\n");




//////////////////////////
        start <= 1'b1;
		repeat (5)
          @(posedge clk);
        start <= 0;

        wait(done);
		repeat (100)
          @(posedge clk);

//////////////////////////
        start <= 1;
        repeat (5)
          @(posedge clk);
        start <= 0;

        wait(done);
        repeat (100)
          @(posedge clk);

/////////////////////////
        start <= 1;
        repeat (5)
          @(posedge clk);
        start <= 0;

        wait(done);

     	// $vcdplusclose;
		$finish;
	end

endmodule

