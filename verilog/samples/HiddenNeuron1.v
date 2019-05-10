module stonet_hidden_neuron1(clk,  weight0, weight1, weight2, weight3, resetn, train,  gen_spike, outaddr, new_block, spike, fp, err, true, errspikes, truespikes);
    //10-random feedback weight values
    parameter fb0 = 7'sd0;
    parameter fb1 = 7'sd0;
    parameter fb2 = 7'sd0;
    parameter fb3 = 7'sd0;
    parameter fb4 = 7'sd0;
    parameter fb5 = 7'sd0;
    parameter fb6 = 7'sd0;
    parameter fb7 = 7'sd0;
    parameter fb8 = 7'sd0;
    parameter fb9 = 7'sd0;
    parameter RAND10_SEED = 10'd1023;
    parameter RAND7_SEED = 7'd127;
    parameter RAND3_SEED = 3'd7;
    
    parameter MAX = 10'b0111111111;
    parameter MIN = 10'b1000000000;
    
    
    //When new_block is high, current internal value is translated to spiking value, and stored.
    
    //I will try to optimized these after I finish
    
    input clk, resetn, train, new_block, gen_spike;
    input errspikes, truespikes; // If these are 0, no update to error sig and true sig. Combine with outaddr to indicate that these addresses are output spikes.
    input [8:0] weight0, weight1, weight2, weight3;
    input [3:0] outaddr;


    
    output reg spike;
    output reg signed [9:0] fp, true, err;
    

    reg signed [9:0] internal;
    reg signed [9:0] sum;
    reg signed [9:0] sum_1;
    reg signed [9:0] sum_2;
    reg signed [8:0] weight0_, weight1_, weight2_, weight3_;
    
    reg signed [9:0] fp0;
    reg signed [9:0] fp1;
    reg signed [9:0] fp2;

    reg signed [9:0] errsig;
    reg signed [9:0] truesig;
    reg signed [9:0] err0;
    reg signed [9:0] true0;
    
    reg signed [13:0] bias;
    //reg signed [9:0] spikeprob;
    
    reg signed [6:0] fbw;
    reg spike_buf;
    reg [9:0] spikeprob;
    wire [9:0] spikeprob_;
    
    reg signed [19:0] mulval;
    
    wire signed [10:0] internal_t;
    wire signed [10:0] sum_t;
    wire signed [10:0] sum_1_t;
    wire signed [10:0] sum_2_t;
    
    wire signed [9:0] internal_;
    wire signed [9:0] sum_;
    wire signed [9:0] sum_1_;
    wire signed [9:0] sum_2_;
    wire signed [9:0] eval;
    wire signed [10:0] errsig_t;
    wire signed [9:0] errsig_;
    wire signed [10:0] truesig_t;
    wire signed [9:0] truesig_;
    
    wire signed [13:0] bias_new;
    
    wire [9:0] random;

    
    
    
    //This RAM needs to be changed in implementation for ASIC, as it is a dual-port ram, and takes up 50% more area
    //RAM port a: for writing port b: for reading
    
    LFSR #(.RAND10_SEED(RAND10_SEED),.RAND3_SEED(RAND3_SEED),.RAND7_SEED(RAND7_SEED)) LFSR0(.clk(clk),.resetn(resetn),.newval(gen_spike),.random(random));


    assign spikeprob_ = (internal > 9'sd160) ? 10'd1023 : (internal < -9'sd160) ? 10'd0 : $unsigned(10'sd512 + mulval[15:6]);
   
    

    
    
    //Summation
    assign internal_t = $signed(internal) + $signed(sum);
    assign internal_ = (internal_t[10:9]==2'b01)? MAX : (internal_t[10:9]==2'b10) ? MIN: $signed(internal_t[9:0]);
    
    assign sum_t = $signed(sum_1) + $signed(sum_2);
    assign sum_ = (sum_t[10:9]==2'b01)? MAX: (sum_t[10:9]==2'b10)? MIN: $signed(sum_t[9:0]);
    
    assign sum_1_t = $signed(weight0_) + $signed(weight1_);
    assign sum_1_ = (sum_1_t[10:9]==2'b01)? MAX: (sum_1_t[10:9]==2'b10)? MIN: $signed(sum_1_t[9:0]);
    
    assign sum_2_t = $signed(weight2_) + $signed(weight3_);
    assign sum_2_ = (sum_2_t[10:9]==2'b01)? MAX: (sum_2_t[10:9]==2'b10)? MIN: $signed(sum_2_t[9:0]);
    
    wire signed [6:0] fbw_err;
    assign fbw_err = {7{errspikes}}&fbw;
    assign errsig_t = $signed(errsig) + $signed(fbw_err);
    assign errsig_ = (errsig_t[10:9]==2'b01)? MAX : (errsig_t[10:9]==2'b10)? MIN : $signed(errsig_t[9:0]);
    
    wire signed [6:0] fbw_true;
    assign fbw_true = {7{truespikes}}&fbw;
    assign truesig_t = $signed(truesig) + $signed(fbw_true);
    assign truesig_ = (truesig_t[10:9]==2'b01)? MAX : (truesig_t[10:9]==2'b10)? MIN : $signed(truesig_t[9:0]);
    
    
    always @(posedge clk or negedge resetn) begin
        if (resetn==1'b0) begin
            //spikeprob <= 'd0;
            mulval <= 'd0;
            spike_buf <= 'd0;
            spikeprob <= 'd0;
            //spike <= 'd0;
            fp <= 'd0;
            true <= 'd0;
            err <= 'd0;
            internal <= 'd0;
            sum <= 'd0;
            sum_1 <= 'd0;
            sum_2 <= 'd0;
            fp0 <= 'd0;
            fp1 <= 'd0;
            fp2 <= 'd0;
            errsig <= 'd0;
            truesig <= 'd0;
            err0 <= 'd0;
            true0 <= 'd0;
            bias <= 'd0;
            
            spike <= 'd0;
            weight0_ <= 'd0;
            weight1_ <= 'd0;
            weight2_ <= 'd0;
            weight3_ <= 'd0;
             
        end
        
        
        else begin
            weight0_ <= weight0;
            weight1_ <= weight1;
            weight2_ <= weight2;
            weight3_ <= weight3;
            if (new_block) begin
                spike <= spike_buf;
                internal <= 'd0;
                sum <= 'd0;
                sum_1 <= 'd0;
                sum_2 <= 'd0;
                errsig <= 'd0;
                truesig <= 'd0;
                mulval <= 'd0;
                spikeprob <= 'd0;
                spike_buf <= 'd0;
                if (train==1'b1) begin
                    bias <= bias_new;
                    //Pipelined to number of block stages before update.
                    fp0 <= internal;
                    fp1 <= fp0;
                    fp2 <= fp1;
                    fp <= fp2;
                    //One delay after receiving error signal, as this is the error signal of image being processed at "output" stage, 
                    //and we will need to synchronize with "sigmoid" stage, which is one stage later than "output" stage
                    err <= errsig;
                    
                    true <= truesig;
                end
            end
            else begin
            if (gen_spike) begin
                if (train) begin
                    mulval <= internal * 10'sd205;
                    spikeprob <= spikeprob_;
                    spike_buf <= spikeprob > random;
                end
                else begin
                    spike_buf <= internal > 'd0;
                end
                
            end

           
                //weight0_ <= weight0;
                //weight1_ <= weight1;
                //weight2_ <= weight2;
                //weight3_ <= weight3;
                internal <= internal_;
                sum <= sum_;
                sum_1 <= sum_1_;
                sum_2 <= sum_2_;
                errsig <= errsig_;
                truesig <= truesig_;
            end
            //spike_buf <= spike_;
            //if (gen_spike) begin
            //    spike <= spike_;
            
        end
    end
        
    
    always @(*) begin
        case(outaddr)
            0:  fbw = fb0;
            1:  fbw = fb1;
            2:  fbw = fb2;
            3:  fbw = fb3;
            4:  fbw = fb4;
            5:  fbw = fb5;
            6:  fbw = fb6;
            7:  fbw = fb7;
            8:  fbw = fb8;
            9:  fbw = fb9;
            default: fbw = 9'd0;
        
        endcase

    end
    
endmodule    
    
    
    
    
    
    
