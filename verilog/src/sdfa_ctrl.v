// This is a Control module
// Description : Top FSM
// Author : Changyu

module sdfa_top_controller(clk, rstn, set_up_req, master_inf_valid, block_inf_valid, master_in, block_in, in_filled, master_done, ready, block_inf_out, master_inf_out, conv_inf, LAYER, init_done);
  
  input clk, rstn;
  
  output reg set_up_req;
  input master_inf_valid, block_inf_valid, master_in, block_in;
  
  input in_filled, master_done, init_done;
  
  output ready;
  
  output reg [23:0] block_inf_out;
  output reg [28:0] master_inf_out;
  output [2:0] conv_inf;
  output [2:0] LAYER;
  
  localparam  SET_UP = 0,
              PROCESSING = 1, 
              DONE = 2;

  reg [2:0] state;
  
  reg [254:0] master_inf_reg;
  reg [170:0] block_inf_reg;
  
  wire [7:0] master_counter, block_counter;
  wire counter_m_done, counter_b_done;
  
  
  reg set_up_m_done, set_up_b_done;
  
  assign LAYER = master_inf_reg[254:252];

  assign ready = (state==SET_UP)? (in_filled&&set_up_m_done&&set_up_b_done&&master_done&&init_done) : (in_filled&&master_done);
 
  
  always@(posedge clk or negedge rstn)
  begin
    if (!rstn) begin
        state <= 'd0;
    end else begin
        case(state)
          SET_UP : if(ready) state<=PROCESSING;
          //PROCESSING : begin if() state<=DONE; end
          //DONE : if() state<=3'b0;
          default : state<=state;
        endcase
    end
  end


  wire [18:0] block0, block1, block2, block3, block4, block5, block6, block7, block8;
  wire [27:0] master0, master1, master2, master3, master4, master5, master6, master7, master8;
  reg [3:0] mini_counter_m, mini_counter_b;
  reg en_b, en_m;
  
  assign conv_inf = block_inf_reg[18:16];
  
  assign block0 = block_inf_reg[18:0];
  assign block1 = block_inf_reg[37:19];
  assign block2 = block_inf_reg[56:38];
  assign block3 = block_inf_reg[75:57];
  assign block4 = block_inf_reg[94:76];
  assign block5 = block_inf_reg[113:95];
  assign block6 = block_inf_reg[132:114];
  assign block7 = block_inf_reg[151:133];
  assign block8 = block_inf_reg[170:152];
  
  assign master0 = master_inf_reg[27:0];
  assign master1 = master_inf_reg[55:28];
  assign master2 = master_inf_reg[83:56];
  assign master3 = master_inf_reg[111:84];
  assign master4 = master_inf_reg[139:112];
  assign master5 = master_inf_reg[167:140];
  assign master6 = master_inf_reg[195:168];
  assign master7 = master_inf_reg[223:196];
  assign master8 = master_inf_reg[251:224];
  
  	counter_m  COUNTER_MASTER(master_counter, counter_m_done, master_inf_valid, clk, rstn);
  	counter_b  COUNTER_BLOCK(block_counter, counter_b_done,  block_inf_valid, clk, rstn);
  	
  always@(posedge clk or negedge rstn)
  begin
    if(!rstn)
      begin
      set_up_req <= 1'b0;
      mini_counter_m <= 4'b0;
      mini_counter_b <= 4'b0;
      en_b <= 1'b0;
      en_m <= 1'b0;
      set_up_m_done <= 1'b0;
      set_up_b_done <= 1'b0;
      block_inf_reg <= 171'b0;
      master_inf_reg <= 255'b0;
      end
      
    else
      begin
   
            set_up_req <= 1'b1;
            
            if(counter_m_done)
              begin
                if(mini_counter_m==4'b1000)
                  begin
                    en_m <= 1'b0;
                    mini_counter_m <= mini_counter_m;
                    set_up_m_done <= 1'b1;
                  end
                else
                  begin
                    if(!en_m) 
                      begin
                        en_m <= 1'b1; 
                        mini_counter_m <= mini_counter_m;
                        set_up_m_done <= 1'b0;
                      end
                    else 
                      begin
                        en_m <= 1'b1; 
                        mini_counter_m <= mini_counter_m+1'b1;
                        set_up_m_done <= 1'b0;
                      end
                  end
              end
              
            else
              begin
                if(master_inf_valid) master_inf_reg[master_counter]<=master_in;
              end
              
            if(counter_b_done)
              begin 
                if(mini_counter_b==4'b1000)
                  begin
                    en_b <= 1'b0;
                    mini_counter_b <= mini_counter_b;
                    set_up_b_done <= 1'b1;
                  end
                else
                  begin
                    if(!en_b) 
                      begin
                        en_b <= 1'b1; 
                        mini_counter_b <= mini_counter_b;
                        set_up_b_done <= 1'b0;
                      end
                    
                    else 
                      begin
                        en_b <= 1'b1; 
                        mini_counter_b <= mini_counter_b+1'b1;
                        set_up_b_done <= 1'b0;
                      end
                  end
              end
            
            else
              begin
                if(block_inf_valid) block_inf_reg[block_counter] <= block_in;
              end
            /*
            end
        endcase*/
      end    
  end

always@(*)
begin
  case(mini_counter_b)
    4'b0000 : block_inf_out = {en_b, 4'b0000, block0};
    4'b0001 : block_inf_out = {en_b, 4'b0001, block1};
    4'b0010 : block_inf_out = {en_b, 4'b0010, block2};
    4'b0011 : block_inf_out = {en_b, 4'b0011, block3};
    4'b0100 : block_inf_out = {en_b, 4'b0100, block4};
    4'b0101 : block_inf_out = {en_b, 4'b0101, block5};
    4'b0110 : block_inf_out = {en_b, 4'b0110, block6};
    4'b0111 : block_inf_out = {en_b, 4'b0111, block7};
    4'b1000 : block_inf_out = {en_b, 4'b1000, block8};
    default : block_inf_out = 0;
  endcase
  
  case(mini_counter_m)
    4'b0000 : master_inf_out = {en_m, master0};
    4'b0001 : master_inf_out = {en_m, master1};
    4'b0010 : master_inf_out = {en_m, master2};
    4'b0011 : master_inf_out = {en_m, master3};
    4'b0100 : master_inf_out = {en_m, master4};
    4'b0101 : master_inf_out = {en_m, master5};
    4'b0110 : master_inf_out = {en_m, master6};
    4'b0111 : master_inf_out = {en_m, master7};
    4'b1000 : master_inf_out = {en_m, master8};
    default : master_inf_out = 0;
  endcase
end

  
endmodule


module counter_m(m_counter, m_done, m_valid, clk, rstn);

output reg [7:0] m_counter;
output m_done;

input m_valid;
input clk, rstn;

always@(posedge clk or negedge rstn)
begin
  if(!rstn) m_counter <= 8'b0;
  else 
  begin  
    if(m_valid) m_counter <= m_counter + 1'b1;
 	end
end

assign m_done = (m_counter == 8'b11111111);

endmodule  



module counter_b(counter, done, valid, clk, rstn);

output reg [7:0] counter;
output done;

input valid;
input clk, rstn;

always@(posedge clk or negedge rstn)
begin
  if(!rstn) counter <= 8'b0;
  else 
  begin  
    if(valid) counter <= counter + 1'b1;
 	end
end

assign done = (counter == 8'b10101011);

endmodule
