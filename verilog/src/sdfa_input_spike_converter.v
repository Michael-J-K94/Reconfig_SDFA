//This is a Input-Spike-Converter Module
//Description : need new image controller?
//Author : Changyu

module sdfa_input_spike_converter(data_in, spike_out, image_req, clk, rstn, pixel_valid, train, ready, image_ready, out_valid, set_number, set_valid, out_bit);

parameter Max_Pixel=2048;

input [63:0] data_in;
output reg [7:0] spike_out;
output reg image_req;

//control
input pixel_valid, train, ready;
output image_ready;
output reg out_valid;

input clk, rstn;

//for reconfig
input set_number, set_valid;
input [2:0] out_bit;
//************************************

reg [11:0] pixel_number;

reg ready1, ready2, ready3, ready4, ready5;

wire [7:0] in1, in2, in3, in4, in5, in6, in7, in8;

wire [7:0] threshold;
wire in_spike_1, in_spike_2, in_spike_3, in_spike_4, in_spike_5, in_spike_6, in_spike_7, in_spike_8;
wire [7:0] rand_8bit;
wire [10:0] counter, outcounter;

reg [3:0] set_addr;

reg [Max_Pixel-1:0] in_spike_buf, out_spike_buf;
wire out_en;

//control signal module
LFSR_in LFSR1_in(rand_8bit, clk, rstn);
counter_add4 COUNTER1(counter, pixel_valid, image_ready, ready, clk, rstn, pixel_number);
counter_fout COUNTER2(outcounter, out_en, ready5, clk, rstn, pixel_number, out_bit);

wire [10:0] addr1, addr2, addr3, addr4, addr5, addr6, addr7, addr8;
wire [10:0] oaddr1, oaddr2, oaddr3, oaddr4, oaddr5, oaddr6, oaddr7, oaddr8;

reg out0, out1, out2, out3, out4, out5, out6, out7;

// divide input
assign in8 = data_in[7:0];
assign in7 = data_in[15:8];
assign in6 = data_in[23:16];
assign in5 = data_in[31:24];
assign in4 = data_in[39:32];
assign in3 = data_in[47:40];
assign in2 = data_in[55:48];
assign in1 = data_in[63:56];

// convert spike
assign threshold = (train)? rand_8bit : 8'd127;    
assign in_spike_1 = (in1>threshold);
assign in_spike_2 = (in2>threshold);
assign in_spike_3 = (in3>threshold);
assign in_spike_4 = (in4>threshold);
assign in_spike_5 = (in5>threshold);
assign in_spike_6 = (in6>threshold);
assign in_spike_7 = (in7>threshold);
assign in_spike_8 = (in8>threshold);

//address for multiple inputs and outputs
assign addr1 = counter;
assign addr2 = counter + 1'b1;
assign addr3 = counter + 2'b10;
assign addr4 = counter + 2'b11;
assign addr5 = counter + 3'b100;
assign addr6 = counter + 3'b101;
assign addr7 = counter + 3'b110;
assign addr8 = counter + 3'b111;

assign oaddr1 = outcounter;
assign oaddr2 = outcounter + 1'b1;
assign oaddr3 = outcounter + 2'b10;
assign oaddr4 = outcounter + 2'b11;
assign oaddr5 = outcounter + 3'b100;
assign oaddr6 = outcounter + 3'b101;
assign oaddr7 = outcounter + 3'b110;
assign oaddr8 = outcounter + 3'b111;

// sequential logic
always@(posedge clk or negedge rstn)
begin
  if(!rstn) 
  begin 
    image_req <= 1'b0;
    in_spike_buf <= 2048'b0;
    out_spike_buf <= 2048'b0;
    out0 <= 1'b0;
    out1 <= 1'b0;
    out2 <= 1'b0;
    out3 <= 1'b0;
    out4 <= 1'b0;
    out5 <= 1'b0;
    out6 <= 1'b0;
    out7 <= 1'b0;
    out_valid <= 1'b0;
    ready1 <= 1'b0;
    ready2 <= 1'b0;
    ready3 <= 1'b0;
    ready4 <= 1'b0;
    ready5 <= 1'b0;
    pixel_number <= 11'b0;
    set_addr <= 4'b0;
  end
    
else 
  begin
    if(set_valid)
      begin
        pixel_number[set_addr] <= set_number;
        set_addr <= set_addr + 1'b1;
        
        if(set_addr == 4'b1011)
          image_req <= 1'b1;
      end
    
    
    
    ready1 <= ready;
    ready2 <= ready1;
    ready3 <= ready2;
    ready4 <= ready3;
    ready5 <= ready4;
    
    if(pixel_valid)
   	begin
      in_spike_buf[addr1] <= in_spike_1;
      in_spike_buf[addr2] <= in_spike_2;
      in_spike_buf[addr3] <= in_spike_3;
      in_spike_buf[addr4] <= in_spike_4;
     	in_spike_buf[addr5] <= in_spike_5;
      in_spike_buf[addr6] <= in_spike_6;
      in_spike_buf[addr7] <= in_spike_7;
      in_spike_buf[addr8] <= in_spike_8;
      image_req <= 1'b0;
    end
  
    if(ready5) 
    begin
      out_spike_buf <= in_spike_buf;
      in_spike_buf <= 2048'b0;
      image_req <= 1'b1;
    end
    
    if(out_en)
    begin
      out_valid <= 1'b1;
      out0 <= out_spike_buf[oaddr1];
      out1 <= out_spike_buf[oaddr2];
      out2 <= out_spike_buf[oaddr3];
      out3 <= out_spike_buf[oaddr4];
      out4 <= out_spike_buf[oaddr5];
      out5 <= out_spike_buf[oaddr6];
      out6 <= out_spike_buf[oaddr7];
      out7 <= out_spike_buf[oaddr8];
    end 
    
    else
    begin
      out_valid <= 1'b0;
      out0 <= 1'b0;
      out1 <= 1'b0;
      out2 <= 1'b0;
      out3 <= 1'b0;
      out4 <= 1'b0;
      out5 <= 1'b0;
      out6 <= 1'b0;
      out7 <= 1'b0;
    end
    
  end
end

//for reconfigurable
always@(*)
begin
  case(out_bit)
    3'b000 : spike_out <= {7'b0, out0}; 
    3'b001 : spike_out <= {6'b0, out1, out0};
    3'b010 : spike_out <= {5'b0, out2, out1, out0};
    3'b011 : spike_out <= {4'b0, out3, out2, out1, out0};
    3'b100 : spike_out <= {3'b0, out4, out3, out2, out1, out0};
    3'b101 : spike_out <= {2'b0, out5, out4, out3, out2, out1, out0};
    3'b110 : spike_out <= {1'b0, out6, out5, out4, out3, out2, out1, out0};
    3'b111 : spike_out <= {out7, out6, out5, out4, out3, out2, out1, out0};
  endcase
end

endmodule




// counter for input address

module counter_add4(counter, pixel_valid, image_ready, ready, clk, rstn, pixel_number);

output reg [10:0] counter;
output image_ready;


input pixel_valid, ready;
input clk, rstn;

input [11:0] pixel_number;

always@(posedge clk or negedge rstn)
begin
  if(!rstn) counter <= 11'b0;
  else 
  begin   
 	  if(ready) counter <= 11'b0;  
    else if(pixel_valid) counter <= counter + 4'b1000;
 	  else counter <= counter;
 	end
end

assign image_ready = !(counter<pixel_number);

endmodule  




//counter for output address

module counter_fout(outcounter, out_en, ready5, clk, rstn, pixel_number, out_bit);

output reg [10:0] outcounter;
output reg out_en;

input ready5;
input clk, rstn;

input [11:0] pixel_number;
input [2:0] out_bit;

wire final_image;
wire [11:0] outcounter_next;

assign outcounter_next=outcounter + out_bit + 1'b1;

always@(posedge clk  or negedge rstn)
begin
  if(!rstn) 
  begin 
    outcounter <= 11'b0; 
    out_en <= 1'b0; 
  end
  
  else 
  begin
    if(ready5) 
    begin 
      outcounter <=  11'b0; 
      out_en <= 1'b1; 
    end
    
    else if(out_en) 
    begin 
      if(final_image) 
      begin 
        outcounter <= 11'b0; 
        out_en <= 1'b0; 
      end 
      
      else 
      begin 
        outcounter <= outcounter_next[10:0]; 
        out_en <= 1'b1; 
      end 
    end
  end
end

assign final_image = !(outcounter_next<pixel_number);

endmodule




//8bit LFSR

module LFSR_in(out, clk, rstn);

parameter [7:0] seed = 8'b01010101;

output reg [7:0] out;

input clk, rstn;

wire feedback;

assign feedback = ~(out[7]^out[6]);

always@(posedge clk or negedge rstn)

begin
  if(!rstn)
    out <= seed;
  else
    out <= {out[6:0], feedback};
end

endmodule 
