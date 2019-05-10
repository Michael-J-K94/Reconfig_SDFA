module stonet_input (clk,train, resetn, input_valid,  image , new_block, pause, ospikes, img_request, input_process_fin);
    /*
    Basic Functionality: Takes in images, translate them into spikes, and stores them.
    At the same time, 
    You should only fetch image data while img_request
    
    */
    input [31:0] image;
    input clk, resetn, train, input_valid, new_block, pause;
    
    output reg [3:0] ospikes;
    output reg input_process_fin;
    output reg img_request;
    
    wire [9:0] addr0, addr1, addr2, addr3;
    wire [9:0] waddr0, waddr1, waddr2, waddr3;
    wire [9:0] random0, random1, random2, random3;
    
    reg [7:0] cntr;
    reg [7:0] w_cntr;
    reg [783:0] spikes_;
    reg [783:0] spikes;
    

    
    assign waddr0 = (w_cntr > 'd195) ? 10'd0:{w_cntr, 2'b00};
    assign waddr1 = (w_cntr > 'd195) ? 10'd0:{w_cntr, 2'b01};
    assign waddr2 = (w_cntr > 'd195) ? 10'd0:{w_cntr, 2'b10};
    assign waddr3 = (w_cntr > 'd195) ? 10'd0:{w_cntr, 2'b11};
    
    assign addr0 = (cntr > 'd195) ? 10'd0:{cntr, 2'b00};
    assign addr1 = (cntr > 'd195) ? 10'd0:{cntr, 2'b01};
    assign addr2 = (cntr > 'd195) ? 10'd0:{cntr, 2'b10};
    assign addr3 = (cntr > 'd195) ? 10'd0:{cntr, 2'b11};
    
    LFSR_411 LFSR0(.clk(clk),.resetn(resetn), .random(random0), .newval(img_request));
    LFSR_412 LFSR1(.clk(clk),.resetn(resetn), .random(random1), .newval(img_request));
    LFSR_413 LFSR2(.clk(clk),.resetn(resetn), .random(random2), .newval(img_request));
    LFSR_410 LFSR3(.clk(clk),.resetn(resetn), .random(random3), .newval(img_request));
    
    always @(posedge clk or negedge resetn) begin
        if (resetn==1'b0) begin
            cntr <= 'd0;
            w_cntr <= 'd0;
            spikes <= 'd0;
            spikes_ <= 'd0;
            ospikes <= 'd0;
            input_process_fin <= 1'b0;
        end
        
        else begin
        
            img_request <= ((w_cntr < 'd196)&(pause==1'b0));
            if (new_block) begin
                spikes <= spikes_;
                cntr <= 'd0;
                w_cntr <= 'd0;
                input_process_fin <= 1'b0;
                ospikes[0] <= spikes[0];
                ospikes[1] <= spikes[1];
                ospikes[2] <= spikes[2];
                ospikes[3] <= spikes[3];
            end
            else begin
                if (input_valid) begin
                    if (w_cntr < 'd196) begin
                        if (train) begin
                            spikes_[waddr0] <= (image[31:24] > random0[7:0]);
                            spikes_[waddr1] <= (image[23:16] > random1[7:0]);
                            spikes_[waddr2] <= (image[15:8] > random2[7:0]);
                            spikes_[waddr3] <= (image[7:0] > random3[7:0]);
                            w_cntr <= w_cntr + 'd1;
                        end
                        else begin
                            spikes_[waddr0] <= (image[31:24] > 8'd127);
                            spikes_[waddr1] <= (image[23:16] > 8'd127);
                            spikes_[waddr2] <= (image[15:8] > 8'd127);
                            spikes_[waddr3] <= (image[7:0] > 8'd127);
                            w_cntr <= w_cntr + 'd1;
                        end
                    end
                
                    else begin
                        input_process_fin <= 1'b1;
                    end
                end
                if (cntr < 'd195) begin
                    ospikes[0] <= spikes[addr0+4];
                    ospikes[1] <= spikes[addr1+4];
                    ospikes[2] <= spikes[addr2+4];
                    ospikes[3] <= spikes[addr3+4];
                    cntr <= cntr + 'd1;
                end
            end
        end
    end

endmodule
