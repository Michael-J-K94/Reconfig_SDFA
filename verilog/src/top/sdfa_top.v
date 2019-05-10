// This is a top module
// Description :
// Author : ALL

module sdfa_top (data_in_t, sys_clk, rstn, pixel_valid_t, train_t, set_number_t, set_valid_t, master_inf_valid_t, block_inf_valid_t, master_in_t, block_in_t, image_req, set_up_req, result_value, result_spike_valid, W_VALID_t, WEIGHT_IN_t, W_REQUEST, clk);



  input [63:0] data_in_t;
  // input clk_FPGA;
  //  input clk;
  input sys_clk;
//  wire clk_FPGA;
  input rstn;
  input pixel_valid_t, train_t;
  input set_number_t, set_valid_t;
  input master_inf_valid_t, block_inf_valid_t, master_in_t, block_in_t;

  output image_req, set_up_req;
  output result_spike_valid;
  output [9:0] result_value;

  input W_VALID_t;
  input [7:0] WEIGHT_IN_t;
  output reg  W_REQUEST;

  output wire clk;
  
  reg [63:0] data_in;
  // reg rstn;
  reg pixel_valid, train;
  reg set_number, set_valid;
  reg master_inf_valid, block_inf_valid, master_in, block_in;
  reg W_VALID;
  reg [7:0] WEIGHT_IN;

  

  wire [7:0] spike_out;

  wire out_valid;

  wire in_filled, master_done, ready;

  wire [23:0] block_inf_out;
  wire [28:0] SETUP_INPUT;

  wire [2:0] conv_inf;
  wire [2:0] LAYER;

  wire [8:0] block_front_done;
  wire [8:0] block_start, block_en, block_result_request;
  wire [7:0] block_input_data_0, block_input_data_1, block_input_data_2, block_input_data_3, block_input_data_4, block_input_data_5, block_input_data_6, block_input_data_7, last;
  wire [8:0] back_done;
  wire [7:0] block_result_data, block_valid;


  reg [31:0] w_set_cnt;

  reg [8:0] w_valid_blk;
  reg [7:0] weight_in_blk [8:0];
  wire [8:0] w_set_done_blk;
  wire w_set_done_all;
  wire [8:0] w_request_blk;

always @(posedge clk or negedge rstn) begin
    if (!rstn) begin
        data_in <= 0;
        // rstn <= 0;
        pixel_valid <= 0;
        train <= 0;
        set_number <= 0;
        set_valid <= 0;
        master_inf_valid <= 0;
        block_inf_valid <= 0;
        master_in <= 0;
        block_in <= 0;
        W_VALID <= 0;
        WEIGHT_IN <= 0;
    end
    else begin
        data_in <= data_in_t;
        // rstn <= rstn_t;
        pixel_valid <= pixel_valid_t;
        train <= train_t;
        set_number <= set_number_t;
        set_valid <= set_valid_t;
        master_inf_valid <= master_inf_valid_t;
        block_inf_valid <= block_inf_valid_t;
        master_in <= master_in_t;
        block_in <= block_in_t;
        W_VALID <= W_VALID_t;
        WEIGHT_IN <= WEIGHT_IN_t;
    end
end

always@(posedge clk or negedge rstn) begin
	if(!rstn) begin
		w_set_cnt <= 'd0;
	end
	else begin
		if(W_VALID) begin
			w_set_cnt <= w_set_cnt + 1;
		end
	end
end

always@(*) begin

	if(w_set_cnt <= 1*114688-1) begin
		w_valid_blk = {W_VALID,8'd0};
		weight_in_blk[0] = WEIGHT_IN;
		weight_in_blk[1] = 'd0;
		weight_in_blk[2] = 'd0;
		weight_in_blk[3] = 'd0;
		weight_in_blk[4] = 'd0;
		weight_in_blk[5] = 'd0;
		weight_in_blk[6] = 'd0;
		weight_in_blk[7] = 'd0;
		weight_in_blk[8] = 'd0;
		W_REQUEST = w_request_blk[0];
	end
	else if(w_set_cnt <= 2*114688-1) begin
		w_valid_blk = {1'd0,W_VALID,7'd0};
		weight_in_blk[0] = 'd0;
		weight_in_blk[1] = WEIGHT_IN;
		weight_in_blk[2] = 'd0;
		weight_in_blk[3] = 'd0;
		weight_in_blk[4] = 'd0;
		weight_in_blk[5] = 'd0;
		weight_in_blk[6] = 'd0;
		weight_in_blk[7] = 'd0;
		weight_in_blk[8] = 'd0;
		W_REQUEST = w_request_blk[1];
	end
	else if(w_set_cnt <= 3*114688-1) begin
		w_valid_blk = {2'd0,W_VALID,6'd0};
		weight_in_blk[0] = 'd0;
		weight_in_blk[1] = 'd0;
		weight_in_blk[2] = WEIGHT_IN;
		weight_in_blk[3] = 'd0;
		weight_in_blk[4] = 'd0;
		weight_in_blk[5] = 'd0;
		weight_in_blk[6] = 'd0;
		weight_in_blk[7] = 'd0;
		weight_in_blk[8] = 'd0;
		W_REQUEST = w_request_blk[2];
	end
	else if(w_set_cnt <= 4*114688-1) begin
		w_valid_blk = {3'd0,W_VALID,5'd0};
		weight_in_blk[0] = 'd0;
		weight_in_blk[1] = 'd0;
		weight_in_blk[2] = 'd0;
		weight_in_blk[3] = WEIGHT_IN;
		weight_in_blk[4] = 'd0;
		weight_in_blk[5] = 'd0;
		weight_in_blk[6] = 'd0;
		weight_in_blk[7] = 'd0;
		weight_in_blk[8] = 'd0;
		W_REQUEST = w_request_blk[3];
	end
	else if(w_set_cnt <= 5*114688-1) begin
		w_valid_blk = {4'd0,W_VALID,4'd0};
		weight_in_blk[0] = 'd0;
		weight_in_blk[1] = 'd0;
		weight_in_blk[2] = 'd0;
		weight_in_blk[3] = 'd0;
		weight_in_blk[4] = WEIGHT_IN;
		weight_in_blk[5] = 'd0;
		weight_in_blk[6] = 'd0;
		weight_in_blk[7] = 'd0;
		weight_in_blk[8] = 'd0;
		W_REQUEST = w_request_blk[4];
	end
	else if(w_set_cnt <= 6*114688-1) begin
		w_valid_blk = {5'd0,W_VALID,3'd0};
		weight_in_blk[0] = 'd0;
		weight_in_blk[1] = 'd0;
		weight_in_blk[2] = 'd0;
		weight_in_blk[3] = 'd0;
		weight_in_blk[4] = 'd0;
		weight_in_blk[5] = WEIGHT_IN;
		weight_in_blk[6] = 'd0;
		weight_in_blk[7] = 'd0;
		weight_in_blk[8] = 'd0;
		W_REQUEST = w_request_blk[5];
	end
	else if(w_set_cnt <= 7*114688-1) begin
		w_valid_blk = {6'd0,W_VALID,2'd0};
		weight_in_blk[0] = 'd0;
		weight_in_blk[1] = 'd0;
		weight_in_blk[2] = 'd0;
		weight_in_blk[3] = 'd0;
		weight_in_blk[4] = 'd0;
		weight_in_blk[5] = 'd0;
		weight_in_blk[6] = WEIGHT_IN;
		weight_in_blk[7] = 'd0;
		weight_in_blk[8] = 'd0;
		W_REQUEST = w_request_blk[6];
	end
	else if(w_set_cnt <= 8*114688-1) begin
		w_valid_blk = {7'd0,W_VALID,1'd0};
		weight_in_blk[0] = 'd0;
		weight_in_blk[1] = 'd0;
		weight_in_blk[2] = 'd0;
		weight_in_blk[3] = 'd0;
		weight_in_blk[4] = 'd0;
		weight_in_blk[5] = 'd0;
		weight_in_blk[6] = 'd0;
		weight_in_blk[7] = WEIGHT_IN;
		weight_in_blk[8] = 'd0;
		W_REQUEST = w_request_blk[7];
	end
	else if(w_set_cnt <= 9*114688-1) begin
		w_valid_blk = {8'd0,W_VALID};
		weight_in_blk[0] = 'd0;
		weight_in_blk[1] = 'd0;
		weight_in_blk[2] = 'd0;
		weight_in_blk[3] = 'd0;
		weight_in_blk[4] = 'd0;
		weight_in_blk[5] = 'd0;
		weight_in_blk[6] = 'd0;
		weight_in_blk[7] = 'd0;
		weight_in_blk[8] = WEIGHT_IN;
		W_REQUEST = w_request_blk[8];
	end
	else begin
		w_valid_blk = 'd0;
		weight_in_blk[0] = 'd0;
		weight_in_blk[1] = 'd0;
		weight_in_blk[2] = 'd0;
		weight_in_blk[3] = 'd0;
		weight_in_blk[4] = 'd0;
		weight_in_blk[5] = 'd0;
		weight_in_blk[6] = 'd0;
		weight_in_blk[7] = 'd0;
		weight_in_blk[8] = 'd0;
		W_REQUEST = 'd0;
	end

end

assign w_set_done_all = &w_set_done_blk;


// sdfa_input_spike_converter ISC (
//     .data_in     (data_in),
//     .spike_out   (spike_out),
//     .image_req   (image_req),
//     .clk         (clk),
//     .rstn        (rstn),
//     .pixel_valid (pixel_valid),
//     .train       (train),
//     .ready       (ready),
//     .image_ready (in_filled),
//     .out_valid   (out_valid),
//     .set_number  (set_number),
//     .set_valid   (set_valid),
//     .out_bit     (conv_inf)
//   );

// sdfa_top_controller CTRL(
//     .clk              (clk),
//     .rstn             (rstn),
//     .set_up_req       (set_up_req),
//     .master_inf_valid (master_inf_valid),
//     .block_inf_valid  (block_inf_valid),
//     .master_in        (master_in),
//     .block_in         (block_in),
//     .in_filled        (in_filled),
//     .master_done      (master_done),
//     .ready            (ready),
//     .block_inf_out    (block_inf_out),
//     .master_inf_out   (SETUP_INPUT),
//     .conv_inf         (conv_inf),
//     .LAYER            (LAYER),
//     .init_done        (w_set_done_all)
//   );


  sdfa_input_spike_converter ISC(data_in, spike_out, image_req, clk, rstn, pixel_valid, train, ready, in_filled, out_valid, set_number, set_valid, conv_inf);
  sdfa_top_controller CTRL(clk, rstn, set_up_req, master_inf_valid, block_inf_valid, master_in, block_in, in_filled, master_done, ready, block_inf_out, SETUP_INPUT, conv_inf, LAYER, w_set_done_all);

  sdfa_master inst_sdfa_master (
      .LAYER                (LAYER),
      .SETUP_INPUT          (SETUP_INPUT),
      .clk                  (clk),
      .rstn                 (rstn),
      .start                (ready),
      .block_front_done     (block_front_done),
      .block_back_done      (back_done),
      .feature_valid        (out_valid),
      .feature              (spike_out),
      .done                 (master_done),
      .block_en             (block_en),
      .block_start          (block_start),
      .block_result_request (block_result_request),
      .block_valid          (block_valid),
      .block_result_data    (block_result_data),
      .block_input_data_0   (block_input_data_0),
      .block_input_data_1   (block_input_data_1),
      .block_input_data_2   (block_input_data_2),
      .block_input_data_3   (block_input_data_3),
      .block_input_data_4   (block_input_data_4),
      .block_input_data_5   (block_input_data_5),
      .block_input_data_6   (block_input_data_6),
      .block_input_data_7   (block_input_data_7),
      .last                 (last)
   );

   sdfa_block #(.BLOCK_ID(3'd0)) BLOCK0 (
      .CLK             (clk),
      .RESET_N         (rstn),
      .START           (block_start[0]),
      .EN              (block_en[0]),
      .REQUEST         (block_result_request[0]),
      .DATA_IN         (block_input_data_0),
      .BLOCK_INFO      (block_inf_out),
      .W_VALID(w_valid_blk[8]),
   	  .WEIGHT_IN(weight_in_blk[0]),
   	  .W_SET_DONE(w_set_done_blk[0]),
   	  .W_REQUEST(w_request_blk[0]),
      .FRONT_DONE      (block_front_done[0]),
      .OUT_SPIKE_VALID (block_valid[0]),
      .BACK_DONE       (back_done[0]),
      .OUT_SPIKE       (block_result_data[0])
      );

   sdfa_block #(.BLOCK_ID(3'd1)) BLOCK1 (
         .CLK             (clk),
         .RESET_N         (rstn),
         .START           (block_start[1]),
         .EN              (block_en[1]),
         .REQUEST         (block_result_request[1]),
         .DATA_IN         (block_input_data_1),
         .BLOCK_INFO      (block_inf_out),
         .W_VALID(w_valid_blk[7]),
    		 .WEIGHT_IN(weight_in_blk[1]),
    		 .W_SET_DONE(w_set_done_blk[1]),
    		 .W_REQUEST(w_request_blk[1]),
         .FRONT_DONE      (block_front_done[1]),
         .OUT_SPIKE_VALID (block_valid[1]),
         .BACK_DONE       (back_done[1]),
         .OUT_SPIKE       (block_result_data[1])
      );

   sdfa_block #(.BLOCK_ID(3'd2)) BLOCK2 (
         .CLK             (clk),
         .RESET_N         (rstn),
         .START           (block_start[2]),
         .EN              (block_en[2]),
         .REQUEST         (block_result_request[2]),
         .DATA_IN         (block_input_data_2),
         .BLOCK_INFO      (block_inf_out),
         .W_VALID(w_valid_blk[6]),
    		 .WEIGHT_IN(weight_in_blk[2]),
    		 .W_SET_DONE(w_set_done_blk[2]),
    		 .W_REQUEST(w_request_blk[2]),
         .FRONT_DONE      (block_front_done[2]),
         .OUT_SPIKE_VALID (block_valid[2]),
         .BACK_DONE       (back_done[2]),
         .OUT_SPIKE       (block_result_data[2])
      );

   sdfa_block #(.BLOCK_ID(3'd3)) BLOCK3 (
         .CLK             (clk),
         .RESET_N         (rstn),
         .START           (block_start[3]),
         .EN              (block_en[3]),
         .REQUEST         (block_result_request[3]),
         .DATA_IN         (block_input_data_3),
         .BLOCK_INFO      (block_inf_out),
         .W_VALID(w_valid_blk[5]),
    		 .WEIGHT_IN(weight_in_blk[3]),
    		 .W_SET_DONE(w_set_done_blk[3]),
    		 .W_REQUEST(w_request_blk[3]),
         .FRONT_DONE      (block_front_done[3]),
         .OUT_SPIKE_VALID (block_valid[3]),
         .BACK_DONE       (back_done[3]),
         .OUT_SPIKE       (block_result_data[3])
      );

   sdfa_block #(.BLOCK_ID(3'd4)) BLOCK4 (
         .CLK             (clk),
         .RESET_N         (rstn),
         .START           (block_start[4]),
         .EN              (block_en[4]),
         .REQUEST         (block_result_request[4]),
         .DATA_IN         (block_input_data_4),
         .BLOCK_INFO      (block_inf_out),
         .W_VALID(w_valid_blk[4]),
    		 .WEIGHT_IN(weight_in_blk[4]),
    		 .W_SET_DONE(w_set_done_blk[4]),
    		 .W_REQUEST(w_request_blk[4]),
         .FRONT_DONE      (block_front_done[4]),
         .OUT_SPIKE_VALID (block_valid[4]),
         .BACK_DONE       (back_done[4]),
         .OUT_SPIKE       (block_result_data[4])
      );

   sdfa_block #(.BLOCK_ID(3'd5)) BLOCK5 (
         .CLK             (clk),
         .RESET_N         (rstn),
         .START           (block_start[5]),
         .EN              (block_en[5]),
         .REQUEST         (block_result_request[5]),
         .DATA_IN         (block_input_data_5),
         .BLOCK_INFO      (block_inf_out),
         .W_VALID(w_valid_blk[3]),
    		 .WEIGHT_IN(weight_in_blk[5]),
    		 .W_SET_DONE(w_set_done_blk[5]),
    		 .W_REQUEST(w_request_blk[5]),
         .FRONT_DONE      (block_front_done[5]),
         .OUT_SPIKE_VALID (block_valid[5]),
         .BACK_DONE       (back_done[5]),
         .OUT_SPIKE       (block_result_data[5])
      );

   sdfa_block #(.BLOCK_ID(3'd6)) BLOCK6 (
         .CLK             (clk),
         .RESET_N         (rstn),
         .START           (block_start[6]),
         .EN              (block_en[6]),
         .REQUEST         (block_result_request[6]),
         .DATA_IN         (block_input_data_6),
         .BLOCK_INFO      (block_inf_out),
         .W_VALID(w_valid_blk[2]),
    		 .WEIGHT_IN(weight_in_blk[6]),
    		 .W_SET_DONE(w_set_done_blk[6]),
    		 .W_REQUEST(w_request_blk[6]),
         .FRONT_DONE      (block_front_done[6]),
         .OUT_SPIKE_VALID (block_valid[6]),
         .BACK_DONE       (back_done[6]),
         .OUT_SPIKE       (block_result_data[6])
      );

   sdfa_block #(.BLOCK_ID(3'd7)) BLOCK7 (
         .CLK             (clk),
         .RESET_N         (rstn),
         .START           (block_start[7]),
         .EN              (block_en[7]),
         .REQUEST         (block_result_request[7]),
         .DATA_IN         (block_input_data_7),
         .BLOCK_INFO      (block_inf_out),
         .W_VALID(w_valid_blk[1]),
    		 .WEIGHT_IN(weight_in_blk[7]),
    		 .W_SET_DONE(w_set_done_blk[7]),
    		 .W_REQUEST(w_request_blk[7]),
         .FRONT_DONE      (block_front_done[7]),
         .OUT_SPIKE_VALID (block_valid[7]),
         .BACK_DONE       (back_done[7]),
         .OUT_SPIKE       (block_result_data[7])
      );

   sdfa_output_block #(.BLOCK_ID(4'd8)) LAST_BLOCK (
          .CLK             (clk),
          .RESET_N         (rstn),
          .START           (block_start[8]),
          .EN              (block_en[8]),
          .REQUEST         (block_result_request[8]),
          .DATA_IN         (last),
          .BLOCK_INFO      (block_inf_out),
          .W_VALID(w_valid_blk[0]),
          .WEIGHT_IN(weight_in_blk[8]),
          .W_SET_DONE(w_set_done_blk[8]),
          .W_REQUEST(w_request_blk[8]),
          .FRONT_DONE      (block_front_done[8]),
          .OUT_SPIKE_VALID (result_spike_valid),
          .BACK_DONE       (back_done[8]),
          .OUT_VALUE       (result_value)
    );

//    diffclock_to_single clock_conv(
//        .clk_in_n(sys_clkn),
//        .clk_in_p(sys_clkp),
//        .clk_out(clk_FPGA),
//        .data_in_from_pins(),
//        .io_reset(),
//        .data_in_to_device()
        
//      );

    clk_wiz_0 clock_pll(
       .clk_in1(sys_clk),
       .clk_out1(clk)
     );

endmodule
