`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/05/17 18:57:52
// Design Name: 
// Module Name: stonet_OK
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module stonet_init_OK(
    input wire [4:0] okUH,
    output wire [2:0] okHU,
    inout wire [31:0] okUHU,
    inout wire okAA,
    input wire sys_clkn,
    input wire sys_clkp,
    input wire clk,
    output wire resetn,
    output reg [31:0] image,
    output reg [3:0] label0,
    output reg input_valid,
    output wire pause,
    output wire train,
    output wire sto_infer,
    output wire infer,
    output reg initialize,
    output reg [13:0] init_val,
    
    input wire img_request,
    input wire label_request,
    input wire [13:0] neuron_voltages,
    input wire output_valid,
    input wire init_fin
    );
    reg [31:0] image_fifo_capture;
    reg [3:0] label0_capture;
    reg input_valid_fifo_capture;
    localparam WR_BLOCK_SIZE      = 128;   // 512 bytes / 4 byte per word;
    localparam RD_BLOCK_SIZE      = 16;   // 64 bytes / 4 byte per word;
    localparam FIFO_SIZE       = 4096;
    localparam FIFO_SIZE_INIT       = 131072;
    // Front Panel wires    
    wire okClk;
    wire [112:0] okHE;
    wire [64:0] okEH;
    
    wire [31:0] ep00wire;
    wire [31:0] ep01wire;
    wire [31:0] ep02wire;
    wire [31:0] ep03wire;
    wire [31:0] ep04wire;
    wire [31:0] ep05wire;
    
    wire [31:0] img_data_in;
    wire [31:0] label_data_in;
    wire [31:0] init_data_in;
    wire [13:0] fifo_out_NV;
    wire [14:0] init_val_fifo_out;
    
    wire [11:0] pipe_in_img_rd_count;
    wire [11:0] pipe_in_label_rd_count;
    wire [11:0] pipe_in_img_wr_count;
    wire [31:0] pipe_in_label_wr_count;
    wire [16:0] pipe_in_init_wr_count;
    wire [16:0] pipe_in_init_rd_count;
    
    wire [11:0] pipe_out_rd_count;
    wire [11:0] pipe_out_wr_count;
    wire [31:0] pipe_out_wr_count_2;
     
    reg pipe_in_img_ready;
    reg pipe_in_label_ready;
    reg pipe_in_init_ready;
    reg pipe_out_ready;
    
    wire [31:0] test_data_in;
    wire [31:0] test_data_out;
    wire [31:0] test_data_out_wire;
    
    wire img_fifo_full;
    wire label_fifo_full;
    wire fifowrite1;
    wire fifowrite2;
    wire fifowrite3;
    wire fifowrite4;
    wire fiforead1;
    wire fiforead2;
    wire [3:0] label;
    wire [3:0] image_out;
    
    wire sys_clk;
        
    wire input_empty;   
    wire init_empty;
    wire init_full;
    wire start;
    wire chip_clk;
    
    
    IBUFGDS osc_clk(
         .O(sys_clk),
         .I(sys_clkp),
         .IB(sys_clkn)
    );
    
    assign chip_clk = clk;

    integer pixel;  
    integer OV_count;
    reg [31:0] LR_count;
    reg [31:0] IR_count;
    reg [31:0] TA_count;
    reg mismatch;
    reg [31:0] init_empty_count;
    reg [31:0] init_full_count;
    
    reg [3:0] label_buf;
    reg [31:0] image_buf;
    
    reg [31:0] init_count;
    reg [31:0] pixel_count;
    reg [31:0] image_test;
    reg [13:0] init_test1, init_test2, init_test3;
  //  wire label_request;
  
    reg [3:0] out_guess;
    reg [3:0] out_count;
    reg [9:0] out_buf;
    reg out_fifo_wr_en;
  
    initial begin 
        pixel = 0;
        LR_count = 0;
        IR_count = 0;
        TA_count = 0;
        OV_count = 0;
        init_empty_count = 0;
        init_count = 0;
        pixel_count = 0;
        image_test = 0;
        initialize = 0;
    end      
        
    always @ (posedge chip_clk) begin
        if (resetn == 1'b0) begin
            LR_count <= 0;
            IR_count <= 0;
            initialize <= 1'b0;
            mismatch <= 0;
       end
        
        else  begin
            input_valid_fifo_capture <= input_valid_w;
            label0_capture <= label0_w;
            image_fifo_capture <= image_w;
            input_valid <= input_valid_fifo_capture;
            label0 <= label0_capture;
            image <= image_fifo_capture;
            if (init_fin) begin
                //init_count <= init_count;
                initialize <= 1'b0;
                if(img_request & input_valid) begin
                    if(pixel_count == 6234) begin
                        image_test <= image;
                    end
                end
                //if (img_request&start) begin
                if (img_request) begin
                    pixel_count <= pixel_count + 1;
                end
          end  
                      
            else if(init_empty) begin
                if(initialize) begin
                    initialize <= 1'b0;
                end
                else begin
                    init_empty_count <= init_empty_count + 1;    
                end
            end
            
            else begin
                init_val <= init_val_fifo_out[13:0];
                initialize <= init_val_fifo_out[14];
            end
            
            if (output_valid) begin
                OV_count <= OV_count + 1;
                if($signed(neuron_voltages[9:0]) > $signed(out_buf)) begin
                    out_buf <= neuron_voltages[9:0];
                    out_guess <= out_count;
                end                    
                out_count <= out_count + 1;
                if (neuron_voltages[13:10] != out_count) begin
                    mismatch <= 1'b1;
                end                     
                if(out_count == 9) begin
                    out_fifo_wr_en <= 1'b1;
                end       
                else begin
                    out_fifo_wr_en <= 1'b0;
                end      
            end
            
            else begin
                out_fifo_wr_en <= 1'b0;
                out_count <= 4'b0000;
                out_guess <= 4'b0000;
                out_buf <= 10'b1000000000;
            end
            
            if(initialize) begin
                init_count <= init_count + 1;      
            end
            
            if (label_request == 1) begin   
                LR_count <= LR_count + 1;
            end
            if (img_request == 1) begin   
                IR_count <= IR_count + 1;
            end 
            if (input_valid_fifo_capture & img_request) begin
                TA_count <= TA_count + 1;
            end
            
            
        end
    end
    wire [3:0] label0_w;
    wire input_valid_w;
    wire [31:0] image_w;
    wire input_valid_fifo;
    assign label0_w = label[3:0];
    //assign input_valid = ~input_empty&start;
    assign input_valid_w = ~input_empty;
    assign image_w = {{8{image_out[0]}}, {8{image_out[1]}}, {8{image_out[2]}}, {8{image_out[3]}}};
    assign resetn = ep01wire[0];
    assign pause = ep02wire[0];
    assign train = ep03wire[0];
    assign infer = ep04wire[0];
    assign sto_infer= ep05wire[0];
    //assign start = ep05wire[0];
    
    fifo_32bit_init fifo_init(
        .din(init_data_in),
        .dout(init_val_fifo_out),
        .wr_en(fifowrite4),
        .rd_en(1'b1),
        .empty(init_empty),
        .almost_empty(),
        .full(init_full),
        .wr_clk(okClk),
        .rd_clk(chip_clk),
        .rst(ep00wire[0]),
        .wr_data_count(pipe_in_init_wr_count),
        .rd_data_count(pipe_in_init_rd_count)    
    );
    
    fifo_32bit fifo_in_image(
        .din(img_data_in),
        .dout(image_out),
        .wr_en(fifowrite1),
        .rd_en(img_request),
        //.rd_en(img_request&start),
        .valid(input_valid_fifo),
        .empty(input_empty),
        .full(img_fifo_full),
        .wr_clk(okClk),
        .rd_clk(chip_clk),
        .rst(ep00wire[0]),
        .wr_data_count(pipe_in_img_wr_count),
        .rd_data_count(pipe_in_img_rd_count)    
    );
    
    fifo_32bit_out fifo_in_label(
        .din(label_data_in),
        .dout(label),
        .wr_en(fifowrite2),
        //.rd_en(label_request&start),
        .rd_en(label_request),
        .full(label_fifo_full),
        .wr_clk(okClk),
        .rd_clk(chip_clk),
        .rst(ep00wire[0]),   
        .wr_data_count(pipe_in_label_wr_count)
    );
    
    
   /*
    fifo_32bit fifo_out_neuron(
        .din(neuron_voltages),
        .dout(fifo_out_NV),
        .wr_en(output_valid),
        .rd_en(fiforead1),
        .full(),
        .wr_clk(chip_clk),
        .rd_clk(okClk),
        .rst(ep00wire[0]),
        .wr_data_count(pipe_out_wr_count),
        .rd_data_count(pipe_out_rd_count)        
    );
   */
   fifo_32bit_out fifo_out(
        .din(out_guess),
        .dout(test_data_out),
        .wr_en(out_fifo_wr_en),
        .rd_en(fiforead2),
        .full(),
        .wr_clk(chip_clk),
        .rd_clk(okClk),
        .rst(ep00wire[0]),
        .wr_data_count(pipe_out_wr_count_2)
    );
   
   always @ (posedge okClk) begin
        if(pipe_in_img_wr_count <= (FIFO_SIZE-WR_BLOCK_SIZE-2) ) begin
            pipe_in_img_ready <= 1'b1;
        end
        else begin
            pipe_in_img_ready <= 1'b0;
        end
                
        if(pipe_in_label_wr_count <= (65536-16-2) ) begin
            pipe_in_label_ready <= 1'b1;
        end
        else begin
            pipe_in_label_ready <= 1'b0;
        end
        
        if(pipe_in_init_wr_count <= (FIFO_SIZE_INIT-8-2) ) begin
            pipe_in_init_ready <= 1'b1;
        end
        else begin
            pipe_in_init_ready <= 1'b0;
        end

    end
       
    wire [28*65-1:0] okEHx;    
    wire [31:0] dout_LR;
    wire [31:0] dout_IR;
    wire [31:0] dout_TA;
    wire [31:0] dout_OV;
    assign dout_OV = OV_count;
    assign dout_LR = LR_count;
    assign dout_IR = IR_count;
    assign dout_TA = TA_count;
    assign dout_mm = mismatch;
    okHost okHI(
        .okUH(okUH),
        .okHU(okHU),
        .okUHU(okUHU),
        .okAA(okAA),
        .okClk(okClk),
        .okHE(okHE), 
        .okEH(okEH)
    ); 
        
    okWireIn wire00(.okHE(okHE), .ep_addr(8'h00), .ep_dataout(ep00wire));  // fifo reset
    okWireIn wire01(.okHE(okHE), .ep_addr(8'h01), .ep_dataout(ep01wire));  // resetn 
    okWireIn wire02(.okHE(okHE), .ep_addr(8'h02), .ep_dataout(ep02wire));  // pause
    okWireIn wire03(.okHE(okHE), .ep_addr(8'h03), .ep_dataout(ep03wire));  // train
    okWireIn wire04(.okHE(okHE), .ep_addr(8'h04), .ep_dataout(ep04wire));  // infer
    okWireIn wire05(.okHE(okHE), .ep_addr(8'h05), .ep_dataout(ep05wire));  // sto_infer
    

//    assign test_data_out_wire = {test_data_out[7:0], test_data_out[15:8],test_data_out[23:16],test_data_out[31:24]};
    okWireOR # (.N(27)) wireOR (okEH, okEHx);     

    okBTPipeIn btIn80(.okHE(okHE), .okEH(okEHx[0*65 +: 65]), .ep_addr(8'h80), .ep_dataout(img_data_in), .ep_write(fifowrite1), .ep_blockstrobe(), .ep_ready(pipe_in_img_ready)); // MNIST image data
    okBTPipeIn btIn81(.okHE(okHE), .okEH(okEHx[1*65 +: 65]), .ep_addr(8'h81), .ep_dataout(label_data_in), .ep_write(fifowrite2), .ep_blockstrobe(), .ep_ready(pipe_in_label_ready));  // MNIST label data
    okBTPipeIn btIn82(.okHE(okHE), .okEH(okEHx[2*65 +: 65]), .ep_addr(8'h82), .ep_dataout(test_data_in), .ep_write(fifowrite3), .ep_blockstrobe(), .ep_ready(pipe_in_label_ready));  // TEST data
    okBTPipeIn btIn83(.okHE(okHE), .okEH(okEHx[13*65 +: 65]), .ep_addr(8'h83), .ep_dataout(init_data_in), .ep_write(fifowrite4), .ep_blockstrobe(), .ep_ready(pipe_in_init_ready));  // Memory init data
    
    okBTPipeOut btOutA0(.okHE(okHE), .okEH(okEHx[3*65 +: 65]), .ep_addr(8'ha0), .ep_datain(fifo_out_NV), .ep_read(fiforead1), .ep_blockstrobe(), .ep_ready(1'b1));
    okBTPipeOut btOutA1(.okHE(okHE), .okEH(okEHx[4*65 +: 65]), .ep_addr(8'ha1), .ep_datain(test_data_out), .ep_read(fiforead2), .ep_blockstrobe(), .ep_ready(1'b1)); // output

    okWireOut wire21(.okHE(okHE), .okEH(okEHx[5*65 +: 65]), .ep_addr(8'h21), .ep_datain(pixel));
    okWireOut wire22(.okHE(okHE), .okEH(okEHx[6*65 +: 65]), .ep_addr(8'h22), .ep_datain(dout_LR));
    okWireOut wire23(.okHE(okHE), .okEH(okEHx[7*65 +: 65]), .ep_addr(8'h23), .ep_datain(dout_IR));
    okWireOut wire24(.okHE(okHE), .okEH(okEHx[8*65 +: 65]), .ep_addr(8'h24), .ep_datain(pipe_in_img_wr_count));
    okWireOut wire25(.okHE(okHE), .okEH(okEHx[9*65 +: 65]), .ep_addr(8'h25), .ep_datain(pipe_in_label_wr_count));
    okWireOut wire26(.okHE(okHE), .okEH(okEHx[10*65 +: 65]), .ep_addr(8'h26), .ep_datain(img_request));
    //okWireOut wire27(.okHE(okHE), .okEH(okEHx[11*65 +: 65]), .ep_addr(8'h27), .ep_datain(pipe_out_wr_count));
    //okWireOut wire28(.okHE(okHE), .okEH(okEHx[12*65 +: 65]), .ep_addr(8'h28), .ep_datain(test_data_out_wire));
    
    okWireOut wire29(.okHE(okHE), .okEH(okEHx[14*65 +: 65]), .ep_addr(8'h29), .ep_datain(init_empty_count));
    okWireOut wire2a(.okHE(okHE), .okEH(okEHx[15*65 +: 65]), .ep_addr(8'h2a), .ep_datain(init_full));
    okWireOut wire2b(.okHE(okHE), .okEH(okEHx[16*65 +: 65]), .ep_addr(8'h2b), .ep_datain(pipe_in_init_wr_count));
    okWireOut wire2c(.okHE(okHE), .okEH(okEHx[17*65 +: 65]), .ep_addr(8'h2c), .ep_datain(pipe_in_init_rd_count));
    okWireOut wire2d(.okHE(okHE), .okEH(okEHx[18*65 +: 65]), .ep_addr(8'h2d), .ep_datain(pipe_out_wr_count_2));
    okWireOut wire2e(.okHE(okHE), .okEH(okEHx[19*65 +: 65]), .ep_addr(8'h2e), .ep_datain(init_fin));
    okWireOut wire2f(.okHE(okHE), .okEH(okEHx[20*65 +: 65]), .ep_addr(8'h2f), .ep_datain(init_count));
    okWireOut wire30(.okHE(okHE), .okEH(okEHx[21*65 +: 65]), .ep_addr(8'h30), .ep_datain(image_test));
    okWireOut wire31(.okHE(okHE), .okEH(okEHx[22*65 +: 65]), .ep_addr(8'h31), .ep_datain(init_test1));
    okWireOut wire32(.okHE(okHE), .okEH(okEHx[23*65 +: 65]), .ep_addr(8'h32), .ep_datain(init_test2));
    okWireOut wire33(.okHE(okHE), .okEH(okEHx[24*65 +: 65]), .ep_addr(8'h33), .ep_datain(init_test3));
    okWireOut wire34(.okHE(okHE), .okEH(okEHx[25*65 +: 65]), .ep_addr(8'h34), .ep_datain(dout_TA));
    okWireOut wire35(.okHE(okHE), .okEH(okEHx[26*65 +: 65]), .ep_addr(8'h35), .ep_datain(dout_mm));
    okWireOut wire36(.okHE(okHE), .okEH(okEHx[27*65 +: 65]), .ep_addr(8'h36), .ep_datain(dout_OV));
endmodule
