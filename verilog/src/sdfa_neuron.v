// This is a Neuron module
// Description : Simple adder with en. Reset by new_block.
// Author : Wonjae

module sdfa_neuron(
    input
        wire clk,
        wire rstn,
        wire cal_en,
	wire read_done,
        wire new_block,
        wire input_spike,
        wire [8:0] weight,
    output
	reg cal_done,
        reg [9:0] sum
    );

    localparam
        MAX = 10'b0111111111,
        MIN = 10'b1000000000;

    wire [9:0] data_in;
    wire [9:0] sum_temp;
    wire [9:0] sum_checked;

    assign data_in = (cal_en)? ((input_spike)? {{2{weight[8]}},weight[7:0]} : 10'd0) : 10'd0;
    assign sum_temp = data_in + sum;
    assign sum_checked = ((!sum[9])&(!data_in[9])&sum_temp[9])? MAX : ((sum[9]&data_in[9]&(!sum_temp[9]))? MIN : sum_temp[9:0]);
    
    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
	    cal_done <= 'd0;
            sum <= 'd0;
        end
        else begin
            if (new_block) begin
                cal_done <= 'd0;
                sum <= 'd0;
            end
            else begin
                if (!cal_done) begin
                    sum <= sum_checked;
                    if (read_done) begin
                        cal_done <= 1'b1;
                    end
                end
            end
        end
    end

endmodule


