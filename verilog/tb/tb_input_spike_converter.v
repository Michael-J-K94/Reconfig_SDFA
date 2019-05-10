module stimulus_inputspike_converter;

reg [63:0] data_in;
wire [63:0] spike_out;
wire out_valid, image_ready, image_req;
reg clk, rstn, pixel_valid, train, ready;
reg set_number, set_valid;
reg [2:0] out_bit;
reg [63:0] Coded_Input [0:195];
reg Set_Input [0:11];

integer i = 0;
integer j = 0;

sdfa_input_spike_converter top(data_in, spike_out, image_req, clk, rstn, pixel_valid, train, ready, image_ready, out_valid, set_number, set_valid, out_bit);

initial
  begin
    $readmemb("./setup_inform.txt", Set_Input);
    #10;
    for(j = 0; j<12; j=j+1)
    begin
      set_number <= Set_Input[j];
      #10;
    end
  end

initial
  begin
    $readmemb("./MNIST_INPUT2.txt", Coded_Input);
    #140;
    for(i = 0; i<98; i=i+1)
    begin
      data_in <= Coded_Input[i];
      #10;
    end
      #70;
      data_in <= Coded_Input[98];
      
      #20;
      
    for(i = 99; i<196; i=i+1)
    begin
      data_in <= Coded_Input[i];
      #10;
    end
  end
  
initial
  begin
		clk = 1;
		rstn = 0;
		ready = 0;
		
		#10
		rstn = 1;
		train = 1;
		out_bit = 3;
		
		#1
		set_valid = 1;
		
		#120
		set_valid = 0;
		
		#10
		pixel_valid = 1;
		
		#980
		pixel_valid = 0;
		
		#10
		ready = 1;
		
		#10
		ready = 0;
		
		#51 pixel_valid = 1;
		
		#10 pixel_valid = 0;
		
		#10 pixel_valid = 1;
		#970 pixel_valid = 0;
		
		#1500
		ready = 1;
		
		#10
		ready = 0;
		/* image ?? ???? tb
		#980 pixel_valid = 0;
		
		#1500 ready = 1;
		#10 ready = 0;
		*/
	end
	
always #5 clk = ~clk;

endmodule


