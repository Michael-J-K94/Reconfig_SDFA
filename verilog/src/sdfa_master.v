// This is a Master module
// Description :
// Author : Yeonsoo

module sdfa_master #(
	parameter
		BLOCK_NUM = 8,
		ADDR_WIDTH = 3,
		BLOCK_ID_WIDTH = 17,
		SETUP_WIDTH = 29
	)
	(
	input
		//default
		wire[ADDR_WIDTH-1:0]		LAYER,
		wire[SETUP_WIDTH-1:0]		SETUP_INPUT,
		//ctrl
		wire						clk,
		wire						rstn,
		wire						start, 				//start process
		wire						feature_valid,
		//data
		wire[BLOCK_NUM-1:0]			feature,
		wire[BLOCK_NUM:0]			block_front_done,
		wire[BLOCK_NUM:0]			block_back_done,
		wire[BLOCK_NUM-1:0]			block_valid,
		wire[BLOCK_NUM-1:0]			block_result_data,
	output
		//ctrl
		reg							done,
		reg[BLOCK_NUM:0]			block_en,
		reg[BLOCK_NUM:0]			block_start,
		reg[BLOCK_NUM:0]			block_result_request,

		wire[BLOCK_NUM -1:0]		block_input_data_0,
		wire[BLOCK_NUM -1:0]		block_input_data_1,
		wire[BLOCK_NUM -1:0]		block_input_data_2,
		wire[BLOCK_NUM -1:0]		block_input_data_3,
		wire[BLOCK_NUM -1:0]		block_input_data_4,
		wire[BLOCK_NUM -1:0]		block_input_data_5,
		wire[BLOCK_NUM -1:0]		block_input_data_6,
		wire[BLOCK_NUM -1:0]		block_input_data_7,

		reg[BLOCK_NUM -1:0]			last

	);

	localparam						STATE_IDLE = 3'd0,
									STATE_PROCESS = 3'd1,
									STATE_SETUP = 3'd2;

	reg[3:0]						state;
	reg[BLOCK_NUM-1:0]				counter;
	reg[BLOCK_NUM:0]				send_done;
	reg[2047:0]						RESULT_VECTOR;
	reg[ADDR_WIDTH-1:0]				group_counter[BLOCK_NUM:0];
	reg[BLOCK_NUM:0]				block_using;
	reg								request_delay;
	reg								data_delay;
	reg								layer_adjust;
	reg[BLOCK_NUM-1:0]				result_counter;
	reg[BLOCK_NUM-1:0]				block_counter[BLOCK_NUM:0];
 	reg								data_ready;
 	wire							block_result_valid;
 	reg								setup_done;
 	reg[ADDR_WIDTH:0]				setup_counter;
 	reg[BLOCK_NUM-1:0]				temp;
	reg 							setup_request;
	reg 							process_done;
	reg 							feature_delay;
	integer							i;
 	//register
 	reg[BLOCK_ID_WIDTH-1:0]			BLOCK_ID[BLOCK_NUM:0];
 	reg[ADDR_WIDTH-1:0]				BLOCK_NUM_PER_LAYER[BLOCK_NUM:0];
	reg[BLOCK_NUM-1:0]				READ_BLOCK[BLOCK_NUM:0];

	reg[BLOCK_NUM-1:0]				block_input_data[BLOCK_NUM-1:0];
	reg[ADDR_WIDTH-1:0]				acc_block_layer[BLOCK_NUM:0];

//wire outputs, buffered in internal registers
assign block_input_data_0 = block_input_data[0];
assign block_input_data_1 = block_input_data[1];
assign block_input_data_2 = block_input_data[2];
assign block_input_data_3 = block_input_data[3];
assign block_input_data_4 = block_input_data[4];
assign block_input_data_5 = block_input_data[5];
assign block_input_data_6 = block_input_data[6];
assign block_input_data_7 = block_input_data[7];

assign block_result_valid = |block_valid;

//ctrl
always @(posedge clk or negedge rstn) begin
	if (!rstn) begin
		state <= STATE_SETUP;
	end
	else begin
		if(start == 1'b1) begin
            state <= STATE_PROCESS;
        end
        else if(setup_done == 1'b1) begin
        	state <= STATE_IDLE;
        end
		else if(process_done == 1'b1) begin
			state <= STATE_IDLE;
		end
		else begin
			state <= state;
		end
	end
end

//data
always @(posedge clk or negedge rstn) begin
	if (!rstn) begin
		done <= 0;
		block_en <= 0;
		block_start <= 0;
		block_result_request <= 0;

		block_input_data[0] <= 0;
		block_input_data[1] <= 0;
		block_input_data[2] <= 0;
		block_input_data[3] <= 0;
		block_input_data[4] <= 0;
		block_input_data[5] <= 0;
		block_input_data[6] <= 0;
		block_input_data[7] <= 0;
 		last <= 0;

		counter <= 0;
		send_done <= 0;
		block_using <= 0;
		request_delay <= 0;
		data_delay <= 0;
		layer_adjust <= 0;

		temp <= 0;
		process_done <= 0;
		feature_delay <= 0;

		group_counter[0] <= 0;
		group_counter[1] <= 0;
		group_counter[2] <= 0;
		group_counter[3] <= 0;
		group_counter[4] <= 0;
		group_counter[5] <= 0;
		group_counter[6] <= 0;
		group_counter[7] <= 0;
		group_counter[8] <= 0;

		block_counter[0] <= 0;
		block_counter[1] <= 0;
		block_counter[2] <= 0;
		block_counter[3] <= 0;
		block_counter[4] <= 0;
		block_counter[5] <= 0;
		block_counter[6] <= 0;
		block_counter[7] <= 0;
		block_counter[8] <= 0;

		acc_block_layer[0] <= 0;
		acc_block_layer[1] <= 0;
		acc_block_layer[2] <= 0;
		acc_block_layer[3] <= 0;
		acc_block_layer[4] <= 0;
		acc_block_layer[5] <= 0;
		acc_block_layer[6] <= 0;
		acc_block_layer[7] <= 0;
		acc_block_layer[8] <= 0;


		setup_request <= 0;
		setup_done <= 0;
		setup_counter <= 0;
	end
	else begin
		case (state)
			STATE_SETUP: begin
				if(setup_done) begin
					setup_request <= 0;
				end
				else if(setup_counter == BLOCK_NUM) begin
					setup_done <= 1;
					setup_request <= 0;
				end
				else begin
					setup_request <= 1;
				end

				if(SETUP_INPUT[28]) begin

					BLOCK_ID[setup_counter] <= SETUP_INPUT[16:0];
					BLOCK_NUM_PER_LAYER[setup_counter] <= SETUP_INPUT[19:17];
					READ_BLOCK[setup_counter] <= SETUP_INPUT[27:20];

					setup_counter <= setup_counter + 1;
				end
				else begin

				end

			end
			STATE_IDLE: begin
				done <= 1;
				block_en <= 0;
				block_start <= 0;
				block_result_request <= 0;
				block_input_data[0] <= 0;
				block_input_data[1] <= 0;
				block_input_data[2] <= 0;
				block_input_data[3] <= 0;
				block_input_data[4] <= 0;
				block_input_data[5] <= 0;
				block_input_data[6] <= 0;
				block_input_data[7] <= 0;
		 		last <= 0;
				send_done <= 0;
				request_delay <= 0;
				data_delay <= 0;
				layer_adjust <= 0;
				temp <= 0;
				process_done <= 0;
				feature_delay <= 0;
				group_counter[0] <= 0;
				group_counter[1] <= 0;
				group_counter[2] <= 0;
				group_counter[3] <= 0;
				group_counter[4] <= 0;
				group_counter[5] <= 0;
				group_counter[6] <= 0;
				group_counter[7] <= 0;
				group_counter[8] <= 0;

				block_counter[0] <= 0;
				block_counter[1] <= 0;
				block_counter[2] <= 0;
				block_counter[3] <= 0;
				block_counter[4] <= 0;
				block_counter[5] <= 0;
				block_counter[6] <= 0;
				block_counter[7] <= 0;
				block_counter[8] <= 0;

				setup_request <= 0;
				setup_done <= 0;
				setup_counter <= 0;
			end
			STATE_PROCESS: begin
				if(&send_done) begin
					feature_delay <= 0;
					block_en <= 0;
					if(block_using == block_front_done && block_using == block_back_done) begin
						process_done <= 1'b1; //process end
					end
				end
				else begin
					done <= 0;
					if(layer_adjust) begin
						if(request_delay == 0) begin
							block_result_request <= block_using;
							request_delay <= request_delay + 1;
						end
						else if(request_delay == 1) begin
							block_result_request <= 0;
						end

						if(data_ready) begin //result vector is ready
							if(data_delay == 0) begin
								if(feature_valid) begin
									block_start <= block_using;
									data_delay <= data_delay + 1;
								end
							end
							else if(data_delay == 1) begin
								block_start <= 0;
							end

							//for the last block
							if(send_done[8]) begin
								block_en[8] <= 0;
							end
							else begin
								if(feature_valid || feature_delay) begin
									last <= ((RESULT_VECTOR[block_counter[8]*8+:8]
										& (READ_BLOCK[8] << (BLOCK_ID[8][5:3] * group_counter[8])))
										>> (BLOCK_ID[8][5:3] * group_counter[8]))
										>> acc_block_layer[BLOCK_ID[8][16:14] - 1];

									if(group_counter[8] + 1 == BLOCK_ID[8][2:0]) begin
											group_counter[8] <= 0;
											block_counter[8] <= block_counter[8] + 1;
									end
									else begin
										group_counter[8] <= group_counter[8] + 1;
									end

									if(block_counter[8] == BLOCK_ID[8][13:6] &&
												group_counter[8] + 1 == BLOCK_ID[8][2:0]) begin
										send_done[8] <= 1;
									end
									else begin //block using is on when last block has to be used
										block_en[8] <= block_using[8];
									end
								end
							end

							if(feature_valid) begin
								feature_delay <= 1;
							end

							for(i = 0; i < 8; i = i + 1) begin
								if(send_done[i]) begin
									block_en[i] <= 0;
								end
								else begin
									if(feature_valid || feature_delay) begin
										if(BLOCK_ID[i][16:14] == 0) begin // layer 0
											block_input_data[i] <= feature;
											block_counter[i] <= block_counter[i] + 1;

											if(block_counter[i] == BLOCK_ID[i][13:6]) begin
												send_done[i] <= 1;
											end
											else begin
												block_en[i] <= block_using[i];
											end
										end
										else begin // not layer 0
											block_input_data[i] <=
													((RESULT_VECTOR[block_counter[i]*8+:8]
													& (READ_BLOCK[i] << (BLOCK_ID[i][5:3] * group_counter[i])))
													>> (BLOCK_ID[i][5:3] * group_counter[i]))
													>> acc_block_layer[BLOCK_ID[i][16:14] - 1];

											if(group_counter[i] + 1 == BLOCK_ID[i][2:0]) begin
												group_counter[i] <= 0;
												block_counter[i] <= block_counter[i] + 1;

											end
											else begin
												group_counter[i] <= group_counter[i] + 1;
											end

											if(block_counter[i] == BLOCK_ID[i][13:6] &&
														group_counter[i] + 1 == BLOCK_ID[i][2:0]) begin
												send_done[i] <= 1;
											end
											else begin
												block_en[i] <= block_using[i];
											end
										end
									end
								end
							end
 						end
					end

					else begin //layer adjust
						layer_adjust <= 1;
						if(counter < LAYER + 1) begin
							counter <= counter + 1;
							case (counter)
							    3'b000: begin
							        block_using <= (1'b1 << BLOCK_NUM_PER_LAYER[0]) - 1;
							        acc_block_layer[counter + 1] <= BLOCK_NUM_PER_LAYER[0];
							    end
							    3'b001: begin
							        block_using <= (1'b1 << BLOCK_NUM_PER_LAYER[0] +
							        						BLOCK_NUM_PER_LAYER[1]) - 1;
							        acc_block_layer[counter + 1] <= BLOCK_NUM_PER_LAYER[0] +
							        							BLOCK_NUM_PER_LAYER[1];
                                end
							    3'b010: begin
    							    block_using <= (1'b1 << BLOCK_NUM_PER_LAYER[0] +
							        						BLOCK_NUM_PER_LAYER[1] +
							        						BLOCK_NUM_PER_LAYER[2]) - 1;
    							    acc_block_layer[counter + 1] <= BLOCK_NUM_PER_LAYER[0] +
    							    							BLOCK_NUM_PER_LAYER[1] +
    							    							BLOCK_NUM_PER_LAYER[2];
                                end
                                3'b011: begin
	                                block_using <= (1'b1 << BLOCK_NUM_PER_LAYER[0] +
							        						BLOCK_NUM_PER_LAYER[1] +
							        						BLOCK_NUM_PER_LAYER[2] +
							        						BLOCK_NUM_PER_LAYER[3]) - 1;
	                                acc_block_layer[counter + 1] <= BLOCK_NUM_PER_LAYER[0] +
	                                							BLOCK_NUM_PER_LAYER[1] +
	                                							BLOCK_NUM_PER_LAYER[2] +
	                                							BLOCK_NUM_PER_LAYER[3];
                                end
                                3'b100: begin
	                                block_using <= (1'b1 << BLOCK_NUM_PER_LAYER[0] +
							        						BLOCK_NUM_PER_LAYER[1] +
							        						BLOCK_NUM_PER_LAYER[2] +
							        						BLOCK_NUM_PER_LAYER[3] +
							        						BLOCK_NUM_PER_LAYER[4]) - 1;
                                	acc_block_layer[counter + 1] <= BLOCK_NUM_PER_LAYER[0] +
								        						BLOCK_NUM_PER_LAYER[1] +
								        						BLOCK_NUM_PER_LAYER[2] +
								        						BLOCK_NUM_PER_LAYER[3] +
								        						BLOCK_NUM_PER_LAYER[4];
                                end
                                3'b101: begin
                                	block_using <= (1'b1 << BLOCK_NUM_PER_LAYER[0] +
							        						BLOCK_NUM_PER_LAYER[1] +
							        						BLOCK_NUM_PER_LAYER[2] +
							        						BLOCK_NUM_PER_LAYER[3] +
							        						BLOCK_NUM_PER_LAYER[4] +
							        						BLOCK_NUM_PER_LAYER[5]) - 1;
                                	acc_block_layer[counter + 1] <= BLOCK_NUM_PER_LAYER[0] +
								        						BLOCK_NUM_PER_LAYER[1] +
								        						BLOCK_NUM_PER_LAYER[2] +
								        						BLOCK_NUM_PER_LAYER[3] +
								        						BLOCK_NUM_PER_LAYER[4] +
								        						BLOCK_NUM_PER_LAYER[5];
                                end
                                3'b110: begin
                                	block_using <= (1'b1 << BLOCK_NUM_PER_LAYER[0] +
							        						BLOCK_NUM_PER_LAYER[1] +
							        						BLOCK_NUM_PER_LAYER[2] +
							        						BLOCK_NUM_PER_LAYER[3] +
							        						BLOCK_NUM_PER_LAYER[4] +
							        						BLOCK_NUM_PER_LAYER[5] +
							        						BLOCK_NUM_PER_LAYER[6]) - 1;
                                	acc_block_layer[counter + 1] <= BLOCK_NUM_PER_LAYER[0] +
								        						BLOCK_NUM_PER_LAYER[1] +
								        						BLOCK_NUM_PER_LAYER[2] +
								        						BLOCK_NUM_PER_LAYER[3] +
								        						BLOCK_NUM_PER_LAYER[4] +
								        						BLOCK_NUM_PER_LAYER[5] +
								        						BLOCK_NUM_PER_LAYER[6];
                                end
                                3'b111: begin
                                	block_using <= (1'b1 << BLOCK_NUM_PER_LAYER[0] +
							        						BLOCK_NUM_PER_LAYER[1] +
							        						BLOCK_NUM_PER_LAYER[2] +
							        						BLOCK_NUM_PER_LAYER[3] +
							        						BLOCK_NUM_PER_LAYER[4] +
							        						BLOCK_NUM_PER_LAYER[5] +
							        						BLOCK_NUM_PER_LAYER[6] +
							        						BLOCK_NUM_PER_LAYER[7]) - 1;
                                	acc_block_layer[counter + 1] <= BLOCK_NUM_PER_LAYER[0] +
								        						BLOCK_NUM_PER_LAYER[1] +
								        						BLOCK_NUM_PER_LAYER[2] +
								        						BLOCK_NUM_PER_LAYER[3] +
								        						BLOCK_NUM_PER_LAYER[4] +
								        						BLOCK_NUM_PER_LAYER[5] +
								        						BLOCK_NUM_PER_LAYER[6] +
								        						BLOCK_NUM_PER_LAYER[7];
                                end
                                default:begin
                                	block_using <= 0;
                        			acc_block_layer[0] <= 0;
									acc_block_layer[1] <= 0;
									acc_block_layer[2] <= 0;
									acc_block_layer[3] <= 0;
									acc_block_layer[4] <= 0;
									acc_block_layer[5] <= 0;
									acc_block_layer[6] <= 0;
									acc_block_layer[7] <= 0;
									acc_block_layer[8] <= 0;
                                end
							endcase
						end
						else begin //all layers are using, and also last block too.
							block_using[7:0] <= block_using[7:0];
							block_using[8] <= 1;
						end
					end
				end
			end
			default: begin

			end
		endcase
	end
end

always @(posedge clk or negedge rstn) begin
	if (!rstn) begin
		RESULT_VECTOR <= 0;
		result_counter <= 0;
		data_ready <= 0;
	end
	else begin
		if(block_result_valid) begin //if any block has any outputs
			RESULT_VECTOR[result_counter*8+:8] <= block_result_data;
			result_counter <= result_counter + 1;
			data_ready <= 1;
		end
		else begin
			if(&send_done) begin
				data_ready <= 0;
				result_counter <= 0;
				RESULT_VECTOR <= 0;
			end
			else begin
				data_ready <= data_ready;
			end
		end
	end
end


endmodule