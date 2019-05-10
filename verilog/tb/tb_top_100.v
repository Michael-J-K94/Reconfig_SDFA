// Testbench file for top
// Author : Changyu

module stimulus_top;
reg [1023:0] vcdfile = "tb_top_100.vcd";
reg clk, rstn;

wire set_up_req, image_req;
wire result_spike, result_spike_valid;

reg master_inf_valid, block_inf_valid;
reg pixel_valid, train;

reg master_in, block_in;
reg [63:0] data_in;
reg set_number, set_valid;

reg MASTER_INPUT [0:254];
reg BLOCK_INPUT [0:170];
reg [63:0] Coded_Input [0:10000*98-1];
reg Set_Input [0:11];
reg [3:0] Coded_Label [0:10000-1];
reg [3:0] true_label;

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

reg [3:0] label, result;

integer w;


integer i = 0;
integer j = 0;
integer k = 0;
integer l = 0;
integer z = 0;
integer q = 0;
integer y = 0;

integer err = 0;
sdfa_top TOP(data_in, clk, rstn, pixel_valid, train, set_number, set_valid, master_inf_valid, block_inf_valid, master_in, block_in, image_req, set_up_req, result_spike, result_spike_valid);


always@(posedge clk)
begin
  if(!result_spike_valid)
    begin
      label <= 0;
      result <= 0;
    end
  else if(result_spike)
    begin
    label = label + result;
    result <= result + 1;
    end
  else result <= result + 1;

  if((result == 4'b1010) && (label!=true_label)) err = err + 1;
end


initial
  begin
    $vcdplusfile(vcdfile);
    $vcdpluson();
    $readmemb("verilog/tb/MNIST_TEST_labels.txt", Coded_Label);
    #13320
      true_label <= Coded_Label[0];
      #2690;
      true_label <= Coded_Label[1];
      #2690;
      true_label <= Coded_Label[2];
      #2930;
      for(y=3; y<100; y=y+1)
      begin
      true_label <= Coded_Label[y];
      #2980;
      end
      $vcdplusclose;
      $finish;
    end

initial
  begin
    $readmemb("verilog/tb/setup_inform.txt", Set_Input);
    $readmemh("verilog/tb/MNIST_TEST_converted.txt", Coded_Input);
    #10;


wait(mem_write_done);

    for(l = 0; l<12; l=l+1)
    begin
      set_number <= Set_Input[l];
      #10;
    end

    #10;

    for(z = 0; z<100; z=z+1)
    begin
      for(k = 98*z; k<98*(z+1); k=k+1)
      begin
        data_in <= Coded_Input[k];
        #10;
      end
      #2000;
    end

  end

initial begin
    #10
      $readmemb("verilog/tb/BLOCK_0_Weights.txt", weight_0);
      $readmemb("verilog/tb/BLOCK_1_Weights.txt", weight_1);
      $readmemb("verilog/tb/BLOCK_2_Weights.txt", weight_2);
      $readmemb("verilog/tb/BLOCK_3_Weights.txt", weight_3);
      $readmemb("verilog/tb/BLOCK_4_Weights.txt", weight_4);
      $readmemb("verilog/tb/BLOCK_5_Weights.txt", weight_5);
      $readmemb("verilog/tb/BLOCK_8_Weights.txt", weight_8);

      mem_write_done = 0;
    #10
        for (w = 0; w < 256; w = w + 1) begin
            force stimulus_top.TOP.BLOCK0.u_sdfa_sram_256.ADDR_WRITE = w;
            force stimulus_top.TOP.BLOCK0.u_sdfa_sram_256.WE = 32'h0;
            force stimulus_top.TOP.BLOCK0.u_sdfa_sram_256.DIN = weight_0[w];

            force stimulus_top.TOP.BLOCK1.u_sdfa_sram_256.ADDR_WRITE = w;
            force stimulus_top.TOP.BLOCK1.u_sdfa_sram_256.WE = 32'h0;
            force stimulus_top.TOP.BLOCK1.u_sdfa_sram_256.DIN = weight_1[w];

            force stimulus_top.TOP.BLOCK2.u_sdfa_sram_256.ADDR_WRITE = w;
            force stimulus_top.TOP.BLOCK2.u_sdfa_sram_256.WE = 32'h0;
            force stimulus_top.TOP.BLOCK2.u_sdfa_sram_256.DIN = weight_2[w];

            force stimulus_top.TOP.BLOCK3.u_sdfa_sram_256.ADDR_WRITE = w;
            force stimulus_top.TOP.BLOCK3.u_sdfa_sram_256.WE = 32'h0;
            force stimulus_top.TOP.BLOCK3.u_sdfa_sram_256.DIN = weight_3[w];

            force stimulus_top.TOP.BLOCK4.u_sdfa_sram_256.ADDR_WRITE = w;
            force stimulus_top.TOP.BLOCK4.u_sdfa_sram_256.WE = 32'h0;
            force stimulus_top.TOP.BLOCK4.u_sdfa_sram_256.DIN = weight_4[w];

            force stimulus_top.TOP.BLOCK5.u_sdfa_sram_256.ADDR_WRITE = w;
            force stimulus_top.TOP.BLOCK5.u_sdfa_sram_256.WE = 32'h0;
            force stimulus_top.TOP.BLOCK5.u_sdfa_sram_256.DIN = weight_5[w];

            force stimulus_top.TOP.BLOCK6.u_sdfa_sram_256.ADDR_WRITE = w;
            force stimulus_top.TOP.BLOCK6.u_sdfa_sram_256.WE = 32'h0;
            force stimulus_top.TOP.BLOCK6.u_sdfa_sram_256.DIN = weight_0[w];

            force stimulus_top.TOP.BLOCK7.u_sdfa_sram_256.ADDR_WRITE = w;
            force stimulus_top.TOP.BLOCK7.u_sdfa_sram_256.WE = 32'h0;
            force stimulus_top.TOP.BLOCK7.u_sdfa_sram_256.DIN = weight_0[w];

            force stimulus_top.TOP.LAST_BLOCK.u_sdfa_sram_80.ADDR_WRITE = w;
            force stimulus_top.TOP.LAST_BLOCK.u_sdfa_sram_80.WE = 10'h0;
            force stimulus_top.TOP.LAST_BLOCK.u_sdfa_sram_80.DIN = weight_8[w];
            #10;
        end

        release stimulus_top.TOP.BLOCK0.u_sdfa_sram_256.ADDR_WRITE;
        release stimulus_top.TOP.BLOCK0.u_sdfa_sram_256.WE;
        release stimulus_top.TOP.BLOCK0.u_sdfa_sram_256.DIN;

        release stimulus_top.TOP.BLOCK1.u_sdfa_sram_256.ADDR_WRITE;
        release stimulus_top.TOP.BLOCK1.u_sdfa_sram_256.WE;
        release stimulus_top.TOP.BLOCK1.u_sdfa_sram_256.DIN;

        release stimulus_top.TOP.BLOCK2.u_sdfa_sram_256.ADDR_WRITE;
        release stimulus_top.TOP.BLOCK2.u_sdfa_sram_256.WE;
        release stimulus_top.TOP.BLOCK2.u_sdfa_sram_256.DIN;

        release stimulus_top.TOP.BLOCK3.u_sdfa_sram_256.ADDR_WRITE;
        release stimulus_top.TOP.BLOCK3.u_sdfa_sram_256.WE;
        release stimulus_top.TOP.BLOCK3.u_sdfa_sram_256.DIN;

        release stimulus_top.TOP.BLOCK4.u_sdfa_sram_256.ADDR_WRITE;
        release stimulus_top.TOP.BLOCK4.u_sdfa_sram_256.WE;
        release stimulus_top.TOP.BLOCK4.u_sdfa_sram_256.DIN;

        release stimulus_top.TOP.BLOCK5.u_sdfa_sram_256.ADDR_WRITE;
        release stimulus_top.TOP.BLOCK5.u_sdfa_sram_256.WE;
        release stimulus_top.TOP.BLOCK5.u_sdfa_sram_256.DIN;

        release stimulus_top.TOP.BLOCK6.u_sdfa_sram_256.ADDR_WRITE;
        release stimulus_top.TOP.BLOCK6.u_sdfa_sram_256.WE;
        release stimulus_top.TOP.BLOCK6.u_sdfa_sram_256.DIN;

        release stimulus_top.TOP.BLOCK7.u_sdfa_sram_256.ADDR_WRITE;
        release stimulus_top.TOP.BLOCK7.u_sdfa_sram_256.WE;
        release stimulus_top.TOP.BLOCK7.u_sdfa_sram_256.DIN;

        release stimulus_top.TOP.LAST_BLOCK.u_sdfa_sram_80.ADDR_WRITE;
        release stimulus_top.TOP.LAST_BLOCK.u_sdfa_sram_80.WE;
        release stimulus_top.TOP.LAST_BLOCK.u_sdfa_sram_80.DIN;
        #10

    $display("***** Weight write is done *****\n\n");
    mem_write_done = 1;
  end

initial
  begin
    $readmemb("verilog/tb/master_inform.txt", MASTER_INPUT);

    #10;

    wait(mem_write_done);

    for(i = 0; i<255; i=i+1)
    begin
      master_in <= MASTER_INPUT[i];
      #10;
    end


  end

initial
  begin
    $readmemb("verilog/tb/block_inform.txt", BLOCK_INPUT);

    #10;

    wait(mem_write_done);

    for(j = 0; j<171; j=j+1)
    begin
      block_in <= BLOCK_INPUT[j];
      #10;
    end
  end

initial
  begin
    #10;

    wait(mem_write_done);
    #131;

    for(q = 0; q<100; q=q+1)
    begin
      pixel_valid=1;
      #980;
      pixel_valid=0;
      #2000;
    end
  end

initial
  begin
    clk = 1;
    rstn = 0;

    #10
    rstn = 1;
    train = 0;

    wait(mem_write_done);

    #1
    master_inf_valid = 1;
    block_inf_valid = 1;
    set_valid = 1;



    #120
    set_valid = 0; //input? setiing ??


    #1590
    block_inf_valid = 0;

    #840
    master_inf_valid = 0;


  end

always #5 clk = ~clk;

endmodule

