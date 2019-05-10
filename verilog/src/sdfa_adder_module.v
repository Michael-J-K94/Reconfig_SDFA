// This is a Adder_Module
// Description:
// Author: Michael Kim

module sdfa_adder_module#(

parameter integer DATA_IN_MAX_SIZE = 8,
parameter integer DATA_KEEP_SIZE = 3,

parameter integer W_SIZE_BIT = 14,

parameter integer CAL_BIT = 10,

parameter integer NUMBER_OF_NEURONS = 256,
parameter integer NEURON_SIZE_BIT = 8 

 
)
(
input EN,

input [CAL_BIT-1:0] ADD_IN1,
input [CAL_BIT-1:0] ADD_IN2,

output [CAL_BIT-1:0] ADDER_RESULT
);

localparam	MAX = 10'b0111_1111_11,
			MIN = 10'b1000_0000_00;


wire [CAL_BIT-1:0] sum_temp;			
assign sum_temp = EN ? ADD_IN1+ADD_IN2 : 'd0;
assign ADDER_RESULT = ( (!ADD_IN1[CAL_BIT-1])&(!ADD_IN2[CAL_BIT-1])&(sum_temp[CAL_BIT-1]) ) ? MAX : ( (ADD_IN1[CAL_BIT-1])&(ADD_IN2[CAL_BIT-1])&(!sum_temp[CAL_BIT-1]) ) ? MIN : sum_temp;	
// ????????????????????????????????????????? OUTPUT WIRE ???


endmodule
