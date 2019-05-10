module LFSR #(
    parameter BITWIDTH = 10,
    // TAP and SEED value are randomly selected.
    // These values can be changed later.
    parameter [BITWIDTH-1:0] TAP = 10'b0100010001,
    parameter [BITWIDTH-1:0] SEED = 10'b0000000001
    )
(
    input
        wire clk,
        wire rstn,
    output
        reg [BITWIDTH-1:0] rand_out
    );
    
    wire rand_in;
    assign rand_in = ^(rand_out[BITWIDTH-1:0]&TAP[BITWIDTH-1:0]);
    
    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            rand_out <= SEED;
        end
        else begin
            // ouput value is unsigned.
            rand_out <= {rand_in, rand_out[BITWIDTH-1:1]};
        end
    end
endmodule
