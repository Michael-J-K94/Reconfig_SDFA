`timescale 1ns / 1ps

module Framework(
    input wire [4:0] okUH,
    output wire [2:0] okHU,
    inout wire [31:0] okUHU,
    inout wire okAA,
    input wire sys_clkn,
    input wire sys_clkp,

    input wire clk,
    output wire rstn,
    output wire train,
    output reg [63:0] image, //data_in
    output reg pixel_valid,
    output reg set_number,
    output reg set_valid,
    output reg master_in,
    output reg master_inf_valid,
    output reg block_in,
    output reg block_inf_valid,
    output reg [7:0] weight_in,
    output reg weight_valid,

    input wire image_request,
    input wire set_up_request,
    input wire weight_request,
    input wire result_spike_valid,
    input wire result_spike,
    input wire [9:0] neuron_voltages
    );

    localparam N = 6; // outgoing wire number YOU MUST CHANGE THIS.
    localparam WR_BLOCK_SIZE                 = 128;   // 512 bytes / 4 byte per word;
    localparam RD_BLOCK_SIZE                 = 16;   // 64 bytes / 4 byte per word;
    localparam FIFO_SIZE_IMAGE               = 4096;
    localparam FIFO_SIZE_MASTER_SETUP        = 256;
    localparam FIFO_SIZE_BLOCK_SETUP         = 256;
    localparam FIFO_SIZE_CONVERTER_SETUP     = 256;
    localparam FIFO_SIZE_meminit                = 131072;
    localparam PIXEL_NUM                     = 784;

    wire chip_clk;
    assign chip_clk = clk;

    reg [63:0]              image_w;
    reg [63:0]              image_fifo_capture;
    reg                     input_valid_w;
    reg                     input_valid_fifo_capture;
    reg                     master_setup_request;
	reg						meminit_setup_request;

    integer                 master_count;
    reg                     image_en;
    integer                 pixel_count;
    integer                 block_count;
    integer                 converter_count;
    reg                     block_setup_request;
    reg                     converter_setup_request;

    reg [9:0]               out_temp;
    reg [3:0]               out_data_in;
    reg [3:0]               out_count;

    reg                     pipe_in_image_ready;
    reg                     pipe_in_meminit_ready;
    reg                     pipe_in_master_ready;
    reg                     pipe_in_block_ready;
    reg                     pipe_in_converter_ready;

    reg                     out_fifo_wr_en;
    wire [9:0]              out_data_out;

    wire [11:0]             pipe_in_image_wr_count;
    wire [11:0]             pipe_in_image_rd_count;
    wire [16:0]             pipe_in_meminit_wr_count;
    wire [16:0]             pipe_in_meminit_rd_count;
    wire [7:0]              pipe_in_master_wr_count;
    wire [7:0]              pipe_in_master_rd_count;
    wire [7:0]              pipe_in_block_wr_count;
    wire [7:0]              pipe_in_block_rd_count;
    wire [7:0]              pipe_in_converter_wr_count;
    wire [7:0]              pipe_in_converter_rd_count;

    wire                    meminit_valid;
    wire                    master_valid;
    wire                    block_valid;
    wire                    converter_valid;
    wire                    out_valid;

    wire [31:0]             meminit_data_in;
    wire [14:0]             meminit_data_out;

    wire                    meminit_empty;
    wire                    meminit_full;
    wire [31:0]             image_data_in;
    wire [63:0]             image_out;
    wire                    input_valid_fifo;
    wire                    input_empty;
    wire                    image_fifo_full;

    wire [31:0]             block_data_in;
    wire                    block_data_out;
    wire [31:0]             converter_data_in;
    wire                    converter_data_out;
    wire [31:0]             master_data_in;
    wire                    master_data_out;
    wire                    master_fifo_full;

    wire [31:0]             pipe_out_wr_count;

    wire                    image_almost_full;
    wire                    image_almost_empty;
    wire                    meminit_almost_full;
    wire                    meminit_almost_empty;
    wire                    master_almost_full;
    wire                    master_almost_empty;
    wire                    block_almost_full;
    wire                    block_almost_empty;
    wire                    converter_almost_full;
    wire                    converter_almost_empty;

    wire sys_clk;

    IBUFGDS osc_clk(
         .O(sys_clk),
         .I(sys_clkp),
         .IB(sys_clkn)
    );


    // Front Panel wires
    wire okClk;
    wire [112:0] okHE;
    wire [64:0] okEH;
    wire [N*65-1:0] okEHx;

    okHost okHI(
        .okUH(okUH),
        .okHU(okHU),
        .okUHU(okUHU),
        .okAA(okAA),
        .okClk(okClk),
        .okHE(okHE),
        .okEH(okEH)
    );

    okWireOR # (.N(N)) wireOR (okEH, okEHx);


    wire [31:0] ep00wire;
    wire [31:0] ep01wire;
    wire [31:0] ep02wire;
    assign rstn = ep01wire[0];
    assign train = ep02wire[0];

    // chip으로 넣을 input signal wire use
    okWireIn wire00(.okHE(okHE), .ep_addr(8'h00), .ep_dataout(ep00wire));  // fifo reset
    okWireIn wire01(.okHE(okHE), .ep_addr(8'h01), .ep_dataout(ep01wire));  // rstn
    okWireIn wire02(.okHE(okHE), .ep_addr(8'h02), .ep_dataout(ep02wire));  // train


    wire image_fifo_write;
    wire meminit_fifo_write;
    wire master_fifo_write;
    wire block_fifo_write;
    wire converter_fifo_write;

    wire out_fifo_read;
    // wire fiforead2;

    // ep_dataout = from pc to FIFO
    /*ep_ready = pipe_in_image_ready, ep_dataout = image_data_in*/
    /*
        ep_addr         content
        00              fifo reset
        01              rstn
        02              train

        80              image
        81              meminit
        82              master
        83              block
        84              converter

        a0              output

    */
    okBTPipeIn btIn80(.okHE(okHE), .okEH(okEHx[0*65 +: 65]), .ep_addr(8'h80), .ep_dataout(image_data_in), .ep_write(image_fifo_write), .ep_blockstrobe(), .ep_ready(pipe_in_image_ready));
    okBTPipeIn btIn81(.okHE(okHE), .okEH(okEHx[1*65 +: 65]), .ep_addr(8'h81), .ep_dataout(meminit_data_in), .ep_write(meminit_fifo_write), .ep_blockstrobe(), .ep_ready(pipe_in_meminit_ready));
    okBTPipeIn btIn82(.okHE(okHE), .okEH(okEHx[2*65 +: 65]), .ep_addr(8'h82), .ep_dataout(master_data_in), .ep_write(master_fifo_write), .ep_blockstrobe(), .ep_ready(pipe_in_master_ready));
    okBTPipeIn btIn83(.okHE(okHE), .okEH(okEHx[3*65 +: 65]), .ep_addr(8'h83), .ep_dataout(block_data_in), .ep_write(block_fifo_write), .ep_blockstrobe(), .ep_ready(pipe_in_block_ready));
    okBTPipeIn btIn84(.okHE(okHE), .okEH(okEHx[4*65 +: 65]), .ep_addr(8'h84), .ep_dataout(converter_data_in), .ep_write(converter_fifo_write), .ep_blockstrobe(), .ep_ready(pipe_in_converter_ready));

    // ep_datain = from mychip to FIFO
    // okBTPipeOut btOutA0(.okHE(okHE), .okEH(okEHx[5*65 +: 65]), .ep_addr(8'ha0), .ep_datain(/*fifo_out_NV*/), .ep_read(fiforead1), .ep_blockstrobe(), .ep_ready(1'b1));
    okBTPipeOut btOutA0(.okHE(okHE), .okEH(okEHx[5*65 +: 65]), .ep_addr(8'ha0), .ep_datain(out_data_out), .ep_read(out_fifo_read), .ep_blockstrobe(), .ep_ready(1'b1));

    always @(posedge chip_clk or negedge rstn) begin
        if (!rstn) begin
            master_count <= 0;
            master_setup_request <= 0;
            block_count <= 0;
            block_setup_request <= 0;
            converter_count <= 0;
            converter_setup_request <= 0;
            meminit_setup_request <= 0;

            out_data_in <= 0;
            out_count <= 0;
            out_fifo_wr_en <= 0;
            out_temp <= 10'b1000000000;

            image_en <= 0;
            pixel_count <= 0;

            image <= 0;
            pixel_valid <= 0;
            set_number <= 0;
            set_valid <= 0;
            master_in <= 0;
            master_inf_valid <= 0;
            block_in <= 0;
            block_inf_valid <= 0;
            weight_in <= 0;
            weight_valid <= 0;
        end
        else begin
            // input_valid_fifo_capture <= input_valid_w;
            // image_fifo_capture <= image_out;
            pixel_valid <= input_valid_fifo;
            image <= image_out;

            if(set_up_request) begin

                weight_valid <= meminit_valid;
                weight_in <= meminit_data_out;
                master_inf_valid <= master_valid;
                master_in <= master_data_out;
                block_inf_valid <= block_valid;
                block_in <= block_data_out;
                set_number <= converter_data_out;
                set_valid <= converter_valid;

                //memory meminitialize
                if(master_count == 255) begin
                    master_setup_request <= 0;
                end
                else begin
                    master_setup_request <= 1;
                    master_count <= master_count + 1;
                end

                if(block_count == 171) begin
                    block_setup_request <= 0;
                end
                else begin
                    block_setup_request <= 1;
                    block_count <= block_count + 1;
                end

                if(converter_count == 11) begin
                    converter_setup_request <= 0;
                end
                else begin
                    converter_setup_request <= 1;
                    converter_count <= converter_count + 1;
                end

                //Memory setup//
                //always read//
                //BLOCK checks itself
                meminit_setup_request <= 1;

            end
            else begin
            end

            if(!image_almost_empty) begin
                if(image_request) begin
                    image_en <= 1;
                    // pixel_count <= 0;
                end
                if(image_en) begin
                    pixel_count <= pixel_count + 1;
                end
                if(pixel_count == PIXEL_NUM - 1) begin
                    image_en <= 0;
                    pixel_count <= 0;
                end
            end
            else begin
                image_en <= 0;
                pixel_count <= pixel_count;
            end

            if (result_spike_valid) begin
                //out_temp contains the most highest value
                if($signed(neuron_voltages) > $signed(out_temp)) begin
                    out_temp <= neuron_voltages;
                    out_data_in <= out_count;
                end
                out_count <= out_count + 1;

                if(out_count == 9) begin
                    out_fifo_wr_en <= 1;
                end
                else begin
                    out_fifo_wr_en <= 0;
                end
            end
            else begin
                out_fifo_wr_en <= 0;
                out_count <= 4'b0000;
                out_data_in <= 4'b0000;
                out_temp <= 10'b1000000000;
            end
        end
    end

//to do
    always @ (posedge okClk or negedge rstn) begin
        if(!rstn) begin
            pipe_in_image_ready <= 0;
            pipe_in_meminit_ready <= 0;
            pipe_in_master_ready <= 0;
            pipe_in_block_ready <= 0;
            pipe_in_converter_ready <= 0;
        end
        else begin
            //TO DO//
            //FIFO_SIZE
            if(image_almost_full) begin
                pipe_in_image_ready <= 0;
            end
            else begin
                pipe_in_image_ready <= 1;
            end

            if(meminit_almost_full) begin
                pipe_in_meminit_ready <= 0;
            end
            else begin
                pipe_in_meminit_ready <= 1;
            end

            if(master_almost_full) begin
                pipe_in_master_ready <= 0;
            end
            else begin
                pipe_in_master_ready <= 1;
            end

            if(block_almost_full) begin
                pipe_in_block_ready <= 0;
            end
            else begin
                pipe_in_block_ready <= 1;
            end

            if(converter_almost_full) begin
                pipe_in_converter_ready <= 0;
            end
            else begin
                pipe_in_converter_ready <= 1;
            end

            // if(pipe_in_image_wr_count <= (FIFO_SIZE_IMAGE-WR_BLOCK_SIZE-2) ) begin
            //     pipe_in_image_ready <= 1'b1;
            // end
            // else begin
            //     pipe_in_image_ready <= 1'b0;
            // end

            // if(pipe_in_meminit_wr_count <= (FIFO_SIZE_meminit-8-2) ) begin
            //     pipe_in_meminit_ready <= 1'b1;
            // end
            // else begin
            //     pipe_in_meminit_ready <= 1'b0;
            // end

            // if(pipe_in_master_wr_count <= (FIFO_SIZE_MASTER_SETUP-WR_BLOCK_SIZE-2) ) begin
            //     pipe_in_master_ready <= 1'b1;
            // end
            // else begin
            //     pipe_in_master_ready <= 1'b0;
            // end

            // if(pipe_in_block_wr_count <= (FIFO_SIZE_BLOCK_SETUP-WR_BLOCK_SIZE-2) ) begin
            //     pipe_in_block_ready <= 1'b1;
            // end
            // else begin
            //     pipe_in_block_ready <= 1'b0;
            // end

            // if(pipe_in_converter_wr_count <= (FIFO_SIZE_CONVERTER_SETUP-WR_BLOCK_SIZE-2) ) begin
            //     pipe_in_converter_ready <= 1'b1;
            // end
            // else begin
            //     pipe_in_converter_ready <= 1'b0;
            // end
        end
    end
    //memory meminitialize
    fifo_32bit_meminit fifo_init(
        .din(meminit_data_in),
        .dout(meminit_data_out),
        .valid(meminit_valid),
        .almost_full(meminit_almost_full),
        .almost_empty(meminit_almost_empty),
        .wr_en(meminit_fifo_write),
        .rd_en(meminit_setup_request),
        .empty(meminit_empty),
        .full(meminit_full),
        .wr_clk(okClk),
        .rd_clk(chip_clk),
        .rst(ep00wire[0]),
        .wr_data_count(pipe_in_meminit_wr_count),
        .rd_data_count(pipe_in_meminit_rd_count)
    );
    //feature
    fifo_32bit fifo_in_image(
        .din(image_data_in),
        .dout(image_out),
        .almost_full(image_almost_full),
        .almost_empty(image_almost_empty),
        .wr_en(image_fifo_write),
        .rd_en(image_en),
        .valid(input_valid_fifo),
        .empty(input_empty),
        .full(image_fifo_full),
        .wr_clk(okClk),
        .rd_clk(chip_clk),
        .rst(ep00wire[0]),
        .wr_data_count(pipe_in_image_wr_count),
        .rd_data_count(pipe_in_image_rd_count)
    );
    //master setup
    fifo_32bit fifo_in_master(
        .din(master_data_in),
        .dout(master_data_out),
        .valid(master_valid),
        .almost_full(master_almost_full),
        .almost_empty(master_almost_empty),
        .wr_en(master_fifo_write),
        .rd_en(master_setup_request),
        .full(),
        .wr_clk(okClk),
        .rd_clk(chip_clk),
        .rst(ep00wire[0]),
        .wr_data_count(pipe_in_master_wr_count),
        .rd_data_count(pipe_in_master_rd_count)
    );
    //block setup
    fifo_32bit fifo_in_block(
        .din(block_data_in),
        .dout(block_data_out),
        .valid(block_valid),
        .almost_full(block_almost_full),
        .almost_empty(block_almost_empty),
        .wr_en(block_fifo_write),//to do
        .rd_en(block_setup_request),
        .full(),
        .wr_clk(okClk),
        .rd_clk(chip_clk),
        .rst(ep00wire[0]),
        .wr_data_count(pipe_in_block_wr_count),
        .rd_data_count(pipe_in_block_rd_count)
    );
    //converter setup
    fifo_32bit fifo_in_converter(
        .din(converter_data_in),
        .dout(converter_data_out),
        .valid(converter_valid),
        .almost_full(converter_almost_full),
        .almost_empty(converter_almost_empty),
        .wr_en(converter_fifo_write),//to do
        .rd_en(converter_setup_request),
        .full(),
        .wr_clk(okClk),
        .rd_clk(chip_clk),
        .rst(ep00wire[0]),
        .wr_data_count(pipe_in_converter_wr_count),
        .rd_data_count(pipe_in_converter_rd_count)
    );
    //output
    fifo_32bit_out fifo_out(
        .din(out_data_in),
        .dout(out_data_out),
        .valid(out_valid),
        .almost_full(),
        .almost_empty(),
        .wr_en(out_fifo_wr_en),
        .rd_en(out_fifo_read),
        .full(),
        .wr_clk(chip_clk),
        .rd_clk(okClk),
        .rst(ep00wire[0]),
        .wr_data_count(pipe_out_wr_count)
    );




 endmodule
