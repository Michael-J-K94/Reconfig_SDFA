// Testbench file for control
// Author : Changyu


module stimulus_top_ctrl;

reg clk, rstn;

wire set_up_req;
reg master_inf_valid, block_inf_valid;

reg master_in, block_in;

reg reset_done, in_filled, master_done;

wire ready; 
wire [22:0] block_inf_out;
wire [28:0] master_inf_out;
wire [2:0] conv_inf; 
wire [2:0] LAYER;

reg MASTER_INPUT [0:226];
reg BLOCK_INPUT [0:151];

integer i = 0;
integer j = 0;

sdfa_top_controller CONTROLLER(clk, rstn, set_up_req, master_inf_valid, block_inf_valid, master_in, block_in, reset_done, in_filled, master_done, ready, block_inf_out, master_inf_out, conv_inf, LAYER);
  
initial
  begin
    $readmemb("./master_inform.txt", MASTER_INPUT);
    
    #10;
    
    for(i = 0; i<227; i=i+1)
    begin
      master_in <= MASTER_INPUT[i];
      #10;
    end
    
    
  end
  
initial
  begin
    $readmemb("./block_inform.txt", BLOCK_INPUT);
    
    #10;
    
    for(j = 0; j<152; j=j+1)
    begin
      block_in <= BLOCK_INPUT[j];
      #10;
    end
  end  
  
initial
  begin
    clk = 1;
    rstn = 0;
    
    #10
    rstn = 1;
    reset_done = 0;
    master_done = 0;
    in_filled = 0;
    
    #1
    master_inf_valid = 1;
    block_inf_valid = 1;
    
    #760
    in_filled = 1;
    reset_done = 1;
    
    #760
    block_inf_valid = 0;
    
    #750
    master_inf_valid = 0;
    
    #200 
    master_done = 1;
  
    #10
    in_filled = 0;
    
  end

always #5 clk = ~clk;

endmodule