// Testbench file for top
// Author : Wonjae

module stimulus_top;

parameter CLK_PERIOD = 10;
parameter TOTAL_NUM = 10003;
parameter TEST_NUM = 10003;
//reg [1023:0] vcdfile = "tb_top_init.vcd";

reg clk, rstn;

wire set_up_req, image_req;
wire [9:0] result_value;
wire result_spike_valid;

reg master_inf_valid, block_inf_valid;
reg pixel_valid, train;

reg master_in, block_in;
reg [63:0] data_in;
reg set_number, set_valid;

reg MASTER_INPUT [0:254];
reg BLOCK_INPUT [0:170];
reg [63:0] Coded_Input [0:TOTAL_NUM*98-1];
reg Set_Input [0:11];

reg [256*14-1:0] weight_0 [255:0];
reg [256*14-1:0] weight_1 [255:0];
reg [256*14-1:0] weight_2 [255:0];
reg [256*14-1:0] weight_3 [255:0];
reg [256*14-1:0] weight_4 [255:0];
reg [256*14-1:0] weight_5 [255:0];
//reg [256*14-1:0] weight_6 [255:0];
//reg [256*14-1:0] weight_7 [255:0];
reg [80*14-1:0] weight_8 [255:0];
reg mem_write_done;

reg W_VALID;
reg [7:0] WEIGHT_IN;
wire W_REQUEST;

integer wr;
integer wc;

integer w;

integer i = 0;
integer j = 0;
integer k = 0;
integer l = 0;
integer z = 0;

integer q = 0;

integer valid_counter = 0;
integer image_counter = 0;
integer correct_counter = 0;

reg [3:0] label[0:TOTAL_NUM-1];
reg [3:0] pred[0:TEST_NUM-1];
reg [9:0] max_value;

sdfa_top_sim TOP(data_in, clk, rstn, pixel_valid, train, set_number, set_valid, master_inf_valid, block_inf_valid, master_in, block_in, image_req, set_up_req, result_value, result_spike_valid, W_VALID, WEIGHT_IN, W_REQUEST);

always #5 clk = ~clk;

always @(posedge result_spike_valid) begin
    image_counter <= image_counter + 1;
end

always @(posedge clk) begin
    if (image_counter > 0) begin
        if (result_spike_valid) begin
            valid_counter <= valid_counter + 1;
            if ($signed(result_value) > $signed(max_value)) begin
            	if (valid_counter == 10) begin
		    pred[image_counter-2] <= 0;
		end
		else begin
		    pred[image_counter-2] <= valid_counter;
		end
		max_value <= result_value;
            end
            // pred[image_counter-2][valid_counter] <= result_spike;
        end
        else begin
            valid_counter <= 0;
            max_value <= 10'b1000000000;
        end
    end
end

initial begin
    $readmemb("verilog/tb/BLOCK_0_Weights.txt", weight_0);
    $readmemb("verilog/tb/BLOCK_1_Weights.txt", weight_1);
    $readmemb("verilog/tb/BLOCK_2_Weights.txt", weight_2);
    $readmemb("verilog/tb/BLOCK_3_Weights.txt", weight_3);
    $readmemb("verilog/tb/BLOCK_4_Weights.txt", weight_4);
    $readmemb("verilog/tb/BLOCK_5_Weights.txt", weight_5);
    $readmemb("verilog/tb/BLOCK_8_Weights.txt", weight_8);

    mem_write_done = 0;
    #CLK_PERIOD
    	wait(W_REQUEST);
	#(0.01)
	    for (wr = 0; wr<256; wr=wr+1) begin
	            for (wc = 0; wc<448; wc=wc+1) begin
	                    W_VALID = 1'd1;
	                    WEIGHT_IN = weight_0[wr][3576-8*wc+:8];
	                    #CLK_PERIOD;
	            end
	    end
	    $display("***** weight_set blk 0 done *****\n\n");
		W_VALID = 1'd0;

    #CLK_PERIOD
    	wait(W_REQUEST);
	#(0.01)
	    for (wr = 0; wr<256; wr=wr+1) begin
	            for (wc = 0; wc<448; wc=wc+1) begin
	                    W_VALID = 1'd1;
	                    WEIGHT_IN = weight_1[wr][3576-8*wc+:8];
	                    #CLK_PERIOD;
	            end
	    end
	    $display("***** weight_set blk 1 done *****\n\n");
		W_VALID = 1'd0;
    
    #CLK_PERIOD
    	wait(W_REQUEST);
	#(0.01)
	    for (wr = 0; wr<256; wr=wr+1) begin
	            for (wc = 0; wc<448; wc=wc+1) begin
	                    W_VALID = 1'd1;
	                    WEIGHT_IN = weight_2[wr][3576-8*wc+:8];
	                    #CLK_PERIOD;
	            end
	    end
	    $display("***** weight_set blk 2 done *****\n\n");
		W_VALID = 1'd0;

    #CLK_PERIOD
    	wait(W_REQUEST);
	#(0.01)
	    for (wr = 0; wr<256; wr=wr+1) begin
	            for (wc = 0; wc<448; wc=wc+1) begin
	                    W_VALID = 1'd1;
	                    WEIGHT_IN = weight_3[wr][3576-8*wc+:8];
	                    #CLK_PERIOD;
	            end
	    end
	    $display("***** weight_set blk 3 done *****\n\n");
		W_VALID = 1'd0;

    #CLK_PERIOD
    	wait(W_REQUEST);
	#(0.01)
	    for (wr = 0; wr<256; wr=wr+1) begin
	            for (wc = 0; wc<448; wc=wc+1) begin
	                    W_VALID = 1'd1;
	                    WEIGHT_IN = weight_4[wr][3576-8*wc+:8];
	                    #CLK_PERIOD;
	            end
	    end
	    $display("***** weight_set blk 4 done *****\n\n");
		W_VALID = 1'd0;

    #CLK_PERIOD
    	wait(W_REQUEST);
	#(0.01)
	    for (wr = 0; wr<256; wr=wr+1) begin
	            for (wc = 0; wc<448; wc=wc+1) begin
	                    W_VALID = 1'd1;
	                    WEIGHT_IN = weight_5[wr][3576-8*wc+:8];
	                    #CLK_PERIOD;
	            end
	    end
	    $display("***** weight_set blk 5 done *****\n\n");
		W_VALID = 1'd0;
    
    #CLK_PERIOD
    	wait(W_REQUEST);
	#(0.01)
	    for (wr = 0; wr<256; wr=wr+1) begin
	            for (wc = 0; wc<448; wc=wc+1) begin
	                    W_VALID = 1'd1;
	                    WEIGHT_IN = 'd0;
	                    #CLK_PERIOD;
	            end
	    end
	    $display("***** weight_set blk 6 done *****\n\n");
		W_VALID = 1'd0;

    #CLK_PERIOD
    	wait(W_REQUEST);
	#(0.01)
	    for (wr = 0; wr<256; wr=wr+1) begin
	            for (wc = 0; wc<448; wc=wc+1) begin
	                    W_VALID = 1'd1;
	                    WEIGHT_IN = 'd0;
	                    #CLK_PERIOD;
	            end
	    end
	    $display("***** weight_set blk 7 done *****\n\n");
		W_VALID = 1'd0;

    #CLK_PERIOD;
        wait(W_REQUEST);
    #(0.01)
        for (wr = 0; wr<256; wr=wr+1) begin
                for (wc = 0; wc<140; wc=wc+1) begin
                        W_VALID = 1'd1;
                        WEIGHT_IN = weight_8[wr][1112-8*wc+:8];
                        #CLK_PERIOD;
                        //$display("Last BLK: current wc: %d , wr: %d",wc,wr);
                end
        end
        $display("***** weight_set blk 8 done *****\n\n");
        W_VALID = 1'd0;

    #CLK_PERIOD
        mem_write_done = 1;
        $display("***** Weight write is done *****\n");
end

initial begin
    $readmemb("verilog/tb/master_inform.txt", MASTER_INPUT);
    $readmemb("verilog/tb/block_inform.txt", BLOCK_INPUT);
    $readmemb("verilog/tb/setup_inform.txt", Set_Input);
    $readmemh("verilog/tb/MNIST_TEST_converted.txt", Coded_Input); /////
    $readmemb("verilog/tb/MNIST_TEST_labels.txt", label); /////

    //$vcdplusfile(vcdfile);
    //$vcdpluson();
    //$vcdplusmemon();
    clk = 1;
    rstn = 0;
    block_inf_valid = 0;
    master_inf_valid = 0;
    set_valid = 0;
    master_in = 0;
    block_in = 0;
    set_number = 0;
    pixel_valid=0;
    data_in = 0;
    
    wc = 0;
    wr = 0;
    W_VALID = 0;
    WEIGHT_IN = 0;

    #CLK_PERIOD
        rstn = 1;
        train = 0;

    #CLK_PERIOD;

    wait(mem_write_done);
    #(CLK_PERIOD+0.01)
        master_inf_valid = 1;
        for(i = 0; i < 255; i = i + 1) begin
          master_in <= MASTER_INPUT[i];
          #CLK_PERIOD;
        end
        master_inf_valid = 0;
    
    #CLK_PERIOD
        block_inf_valid = 1;
        for(j = 0; j < 171; j = j + 1) begin
          block_in <= BLOCK_INPUT[j];
          #CLK_PERIOD;
        end
        block_inf_valid = 0;
    
    #CLK_PERIOD
        set_valid = 1;
        for(l = 0; l < 12; l = l + 1) begin
          set_number <= Set_Input[l];
          #CLK_PERIOD;
        end
        set_valid = 0;
    
    #(100*CLK_PERIOD);

    for(z = 0; z < TEST_NUM; z = z + 1) begin /////
        pixel_valid=1;
		if (z % 100 == 0) begin
		    $display("CURRENT IMAGE : %d", z);
		end
        for(k = 0; k < 98; k = k + 1) begin
            data_in = Coded_Input[98*z+k];
            #CLK_PERIOD;
        end
        pixel_valid=0;
        #(200*CLK_PERIOD);
    end
    #(300*CLK_PERIOD);
    
    
    for (q = 0; q < TEST_NUM; q = q + 1) begin /////
        if (label[q] == pred[q]) begin
           correct_counter = correct_counter + 1; 
        end
        else begin
            $display("INPUT %d WRONG!! ", q);
            $display("true label :  %d ", label[q]);
            $display("pred label :  %d\n", pred[q]);
        end
        #CLK_PERIOD;
    end
    #CLK_PERIOD;
    $display("correct : %d \n\n", correct_counter);
    
    $finish;
end
endmodule
