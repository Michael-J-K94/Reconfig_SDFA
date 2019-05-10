// Testbench file for neuron
// Author : WonJae
// Manually Controlled testbench
//
module tb_neuron();
    parameter CLK_CYCLE = 5;
    parameter CLK_PERIOD = 2*CLK_CYCLE;

    reg clk;
    reg rstn;
    reg cal_start;
    reg new_block;
    reg input_spike;
    reg [8:0] weight;
    wire [9:0] sum;

    reg read_done;
    wire cal_done;

    always #CLK_CYCLE clk = ~clk;
    
    initial begin
        clk  = 0;
        rstn = 0;
        input_spike = 0;
        cal_start = 0;
        new_block = 0;
        weight = 0;
        read_done = 0;

        repeat(10)
            @(posedge clk);

	// test start
        rstn = 1;
	#(0.01)
        #CLK_PERIOD
            cal_start = 1;
            input_spike = 1;
            weight = 9'd1;
        #CLK_PERIOD weight = 9'd2;

	// case : no start signal.
        #CLK_PERIOD
            cal_start = 0;
            weight = 9'd3;
        #CLK_PERIOD weight = 9'd4;
	// case end

        #CLK_PERIOD
            cal_start = 1;
            weight = 9'd5;

	// case : 0 vaule input spike.
        #CLK_PERIOD
            input_spike = 0;
            weight = 9'd6;
        #CLK_PERIOD weight = 9'd7;
        #CLK_PERIOD weight = 9'd8;
	// case end

	// case : negative number addition.
        #CLK_PERIOD
            input_spike = 1;
            weight = 9'b111111111;
        // case end

	// cases for negative overflow.
        #CLK_PERIOD weight = 9'b100000000;
        #CLK_PERIOD weight = 9'b100000000;
        #CLK_PERIOD weight = 9'b110000000;
	// case end

        #CLK_PERIOD read_done = 1;
        #CLK_PERIOD read_done = 0;
        
        #CLK_PERIOD weight <= 9'd1;
        #CLK_PERIOD weight <= 9'd2;
        #CLK_PERIOD weight <= 9'd3;
        
        #CLK_PERIOD cal_start <= 1'b0;
	
	// case : new input
        #CLK_PERIOD
            new_block <= 1'b1;
            cal_start <= 1'b1;
            weight <= 9'd4;
        #CLK_PERIOD new_block <= 1'b0;
	// case end

        repeat(10)
            @(posedge clk);

        $finish;
    end

    sdfa_neuron u_neuron(
        .clk(clk),
        .rstn(rstn),
        .cal_en(cal_start),
        .new_block(new_block),
        .read_done(read_done),
        .input_spike(input_spike),
        .weight(weight),
        .sum(sum),
        .cal_done(cal_done)
    );

endmodule
