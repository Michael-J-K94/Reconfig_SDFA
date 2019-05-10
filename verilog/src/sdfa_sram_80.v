// This is a SRAM_(256x14)x80
// Description:
// Author: Michael Kim

module sdfa_sram_80#(
    parameter integer W_SIZE_BIT = 14,
    parameter integer NUMBER_OF_BANK = 10,
    parameter integer NUMBER_OF_NEURONS = 80,
    parameter integer NUMBER_OF_MEMROW = 256,
    parameter integer MEM_SIZE_BIT = 8
)
(
    input CLK,
    input EN_M,
    input [NUMBER_OF_BANK-1:0] WE,
    input [MEM_SIZE_BIT-1:0] ADDR,
    input [MEM_SIZE_BIT-1:0] ADDR_WRITE,
    input [NUMBER_OF_NEURONS*W_SIZE_BIT-1:0] DIN,						
    output [NUMBER_OF_NEURONS*W_SIZE_BIT-1:0] DOUT // ????????????????????????????????????????? ENDIAN CORRECT ??? *****************************************
);

    genvar i;
    
    wire we [NUMBER_OF_BANK-1:0];
    wire [8*14-1:0] din [NUMBER_OF_BANK-1:0];
    wire [8*14-1:0] dout [NUMBER_OF_BANK-1:0];
    
    wire [NUMBER_OF_NEURONS*W_SIZE_BIT-1:0] dout_temp;

//////////////////////////////////////////
// "we", "din", "dout_temp" GENERATION  // 
//////////////////////////////////////////
    generate
    for(i=0; i < NUMBER_OF_BANK; i=i+1) begin
        assign we[i] = WE[i];
        assign din[i] = DIN[(NUMBER_OF_BANK-i)*8*14-1:(NUMBER_OF_BANK-i-1)*8*14];
        assign dout_temp[(NUMBER_OF_BANK-i)*8*14-1:(NUMBER_OF_BANK-i-1)*8*14] = dout[i];
    end
    endgenerate


/////////////////////////////////
// SRAM (8x14)x256 GENERATION  // 
/////////////////////////////////
    generate
    for(i=0; i < NUMBER_OF_BANK; i=i+1) begin
        sdfa_sram_8 bank(
        .CLK(CLK),
        .EN_M(EN_M),     
        .WE(we[i]),      
        .ADDR(ADDR),  
        .DIN(din[i]),    
        .DOUT(dout[i]),  	
        .ADDR_WRITE(ADDR_WRITE)
        );
    end
    endgenerate
    
    assign DOUT = dout_temp;
	
endmodule
