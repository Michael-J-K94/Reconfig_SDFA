module stonet_hidden1(clk, initialize_begin, resetn, initialize, new_block, in_spikes, out_spike, train, infer, errspikes, truespikes, ospikes, init_val, layer_proc_fin, init_fin);
    input clk, resetn, initialize, new_block, train, infer, errspikes, truespikes, ospikes;
    input initialize_begin;
    input [3:0] in_spikes;
    input [69:0] init_val;
    
    output reg out_spike;
    output reg layer_proc_fin;
    output reg init_fin;

    reg [7:0] sendspike_counter;
    reg [3:0] errcounter;
    reg [3:0] truecounter;
    reg [160:0] init_regs;
    reg [7:0] spike_addr_counter;
    reg [7:0] process_counter;
    reg [7:0] write_addr;
    reg [7:0] up_addr;
    reg signed [10:0] upval;
    reg signed [20:0] upvalbuff;
    //Write Address Buffer stages before up: 2, 1 buffer for 1 load/1 add.
    reg [7:0] buffer_counter0;
    reg [7:0] buffer_counter1;
    reg [7:0] buffer_counter2;
    reg [7:0] proc_buffer0;
    reg [7:0] proc_buffer1;
    reg [7:0] proc_buffer2;
    
    //Control buffers: 1, 1 buffer for 1-stage load.
    reg [3:0] up;
    reg [3:0] up0;
    
    reg [783:0] in_spikes0;
    reg [783:0] in_spikes1;
    reg [783:0] in_spikes2;
    reg [783:0] in_spikes3;
    reg [783:0] in_spikes4;
    reg [783:0] in_spikes5;

    reg  [9:0] y1, y2;
    reg  [9:0] y3;
    reg  [9:0] y3_buf;
    reg signed [10:0] y_sub;
    
    reg signed [10:0] delta [0:199];
    reg signed [10:0] delta_ [0:199];
    
    wire signed [10:0] y1_extended;
    wire signed [10:0] y2_extended;

    reg addr_eq_195;
    reg [5:0] gen_spike_buff;
    reg gen_spike;
    
     //This register indicates that processing required at this state is finished.
    
    

    //reg [69:0] datas0 [0:39];
    //reg [69:0] datas1 [0:39];
    //reg [69:0] datas2 [0:39];
    //reg [69:0] datas3 [0:39];    
    reg [3:0] add0;
    
    reg [39:0] we0, we1, we2, we3;
    wire errspikes, truespikes;
    wire errspike, truespike;
    wire [9:0] in_spikes_addr;
    wire [3:0] outaddr;
    wire [3:0] add;
    //reg [3:0] add;
    wire [199:0] spikes;
    wire [20:0] upval_;
    wire spike_process_not_fin;
    
    wire [9:0] fp [199:0];
    wire [9:0] err [199:0];
    wire [9:0] true [199:0];
    
    wire [9:0] sigdiff_input;
    wire [9:0] sigmoid_input1, sigmoid_input2;
    wire [9:0] sigdiff_output;
    wire [9:0] sigmoid_output1, sigmoid_output2;
    
    wire [3:0] write_lookahead;
    //Weight value prepped
    reg [8:0] weight0_a [39:0];
    reg [8:0] weight1_a [39:0];
    reg [8:0] weight2_a [39:0];
    reg [8:0] weight3_a [39:0];
    
    reg [8:0] weight0_b [39:0];
    reg [8:0] weight1_b [39:0];
    reg [8:0] weight2_b [39:0];
    reg [8:0] weight3_b [39:0];

    reg [8:0] weight0_c [39:0];
    reg [8:0] weight1_c [39:0];
    reg [8:0] weight2_c [39:0];
    reg [8:0] weight3_c [39:0];    

    reg [8:0] weight0_d [39:0];
    reg [8:0] weight1_d [39:0];
    reg [8:0] weight2_d [39:0];
    reg [8:0] weight3_d [39:0];    
    
    reg [8:0] weight0_e [39:0];
    reg [8:0] weight1_e [39:0];
    reg [8:0] weight2_e [39:0];
    reg [8:0] weight3_e [39:0];
    
    
        
    reg signed [13:0] weight0_a_new [39:0];
    reg signed [13:0] weight1_a_new [39:0];
    reg signed [13:0] weight2_a_new [39:0];
    reg signed [13:0] weight3_a_new [39:0];

    reg signed [13:0] weight0_b_new [39:0];
    reg signed [13:0] weight1_b_new [39:0];
    reg signed [13:0] weight2_b_new [39:0];
    reg signed [13:0] weight3_b_new [39:0];
    
    reg signed [13:0] weight0_c_new [39:0];
    reg signed [13:0] weight1_c_new [39:0];
    reg signed [13:0] weight2_c_new [39:0];
    reg signed [13:0] weight3_c_new [39:0];
    
    reg signed [13:0] weight0_d_new [39:0];
    reg signed [13:0] weight1_d_new [39:0];
    reg signed [13:0] weight2_d_new [39:0];
    reg signed [13:0] weight3_d_new [39:0];

    reg signed [13:0] weight0_e_new [39:0];
    reg signed [13:0] weight1_e_new [39:0];
    reg signed [13:0] weight2_e_new [39:0];
    reg signed [13:0] weight3_e_new [39:0];

   /* reg [8:0] weight0_a_ [39:0];
    reg [8:0] weight1_a_ [39:0];
    reg [8:0] weight2_a_ [39:0];
    reg [8:0] weight3_a_ [39:0];
    
    reg [8:0] weight0_b_ [39:0];
    reg [8:0] weight1_b_ [39:0];
    reg [8:0] weight2_b_ [39:0];
    reg [8:0] weight3_b_ [39:0];

    reg [8:0] weight0_c_ [39:0];
    reg [8:0] weight1_c_ [39:0];
    reg [8:0] weight2_c_ [39:0];
    reg [8:0] weight3_c_ [39:0];    

    reg [8:0] weight0_d_ [39:0];
    reg [8:0] weight1_d_ [39:0];
    reg [8:0] weight2_d_ [39:0];
    reg [8:0] weight3_d_ [39:0];    
    
    reg [8:0] weight0_e_ [39:0];
    reg [8:0] weight1_e_ [39:0];
    reg [8:0] weight2_e_ [39:0];
    reg [8:0] weight3_e_ [39:0];
*/
    wire [69:0] datas_0_0_wireout;
    wire [69:0] datas0_0_wireout;
    wire [69:0] data0_new_wireout;
    wire [10:0] delta_wireout;
    wire [13:0] weight0_a_new_wireout;

    wire [69:0] datas0 [39:0];
    wire [69:0] datas1 [39:0];
    wire [69:0] datas2 [39:0];
    wire [69:0] datas3 [39:0];
    
    reg [69:0] datas_0 [39:0];
    reg [69:0] datas_1 [39:0];
    reg [69:0] datas_2 [39:0]; 
    reg [69:0] datas_3 [39:0];

    reg [69:0] data0_new [39:0];
    reg [69:0] data1_new [39:0];
    reg [69:0] data2_new [39:0];
    reg [69:0] data3_new [39:0];   
    reg spikenotfinbuf;
          
    
    wire we;
    wire [3:0] read;
    assign weight0_a_new_wireout = weight0_a_new[0];
    assign datas0_0_wireout = datas0[0];
    assign datas_0_0_wireout = datas_0[0];
    assign data0_new_wireout = data0_new[0];
    assign delta_wireout = delta[0];
    
    
    assign write_lookahead = in_spikes5[spike_addr_counter];
    assign read = ~((write_lookahead | add ) & {4{spikenotfinbuf}});

    
    //assign read = (write_addr==spike_addr_counter) ? 4'b1111: 4'b0000;
    //For now, need to change to read to reduce 25% on memory read
    //assign  read =  ~ (up0 | ~add) ;
    assign  we =  train;
    //Control Signals
    assign errspike = errspikes & ospikes;
    assign truespike = truespikes & ospikes;
    assign spike_process_not_fin = ((train|infer) & (spike_addr_counter < 'd195));
    
    //Requires initialization scheme
    assign add = ({4{spike_process_not_fin}}&in_spikes);       //Masked
    
    
    assign outaddr = errspikes ? errcounter : truecounter;
    assign in_spikes_addr = {spike_addr_counter,2'b00};
    
    //assign addr = initialize ? ('d0) : spike_addr_counter;
    
    assign sigdiff_input = train ? fp[process_counter] : 'd0;
    assign sigmoid_input1 = train ? true[process_counter] : 'd0;
    assign sigmoid_input2 = train ? err[process_counter] : 'd0;
    

    assign upval_ = $signed(y3) * $signed(y_sub);

    assign y1_extended = $signed({1'b0,y1});
    assign y2_extended = $signed({1'b0,y2});

// a~e is prefix for Neurons that share a ram. LSB: a,   MSB: e
    always @(*) begin
        for (integer i=0; i<40; i=i+1) begin
            data0_new[i] = {weight0_e_new[i], weight0_d_new[i], weight0_c_new[i], weight0_b_new[i], weight0_a_new[i]};
            data1_new[i] = {weight1_e_new[i], weight1_d_new[i], weight1_c_new[i], weight1_b_new[i], weight1_a_new[i]};
            data2_new[i] = {weight2_e_new[i], weight2_d_new[i], weight2_c_new[i], weight2_b_new[i], weight2_a_new[i]};
            data3_new[i] = {weight3_e_new[i], weight3_d_new[i], weight3_c_new[i], weight3_b_new[i], weight3_a_new[i]};
        end



        if (initialize==1'b1) begin
            
            for (integer i = 0; i<40; i=i+1) begin
                we0[i] = ~init_regs[i];
                we1[i] = ~init_regs[40+i];
                we2[i] = ~init_regs[80+i];
                we3[i] = ~init_regs[120+i];
                weight0_a_new[i] = init_val[13:0];
                weight0_b_new[i] = init_val[27:14];
                weight0_c_new[i] = init_val[41:28];
                weight0_d_new[i] = init_val[55:42];
                weight0_e_new[i] = init_val[69:56];
               
                weight1_a_new[i] = init_val[13:0];
                weight1_b_new[i] = init_val[27:14];
                weight1_c_new[i] = init_val[41:28];
                weight1_d_new[i] = init_val[55:42];
                weight1_e_new[i] = init_val[69:56];
              
                weight2_a_new[i] = init_val[13:0];
                weight2_b_new[i] = init_val[27:14];
                weight2_c_new[i] = init_val[41:28];
                weight2_d_new[i] = init_val[55:42];
                weight2_e_new[i] = init_val[69:56];
             
                weight3_a_new[i] = init_val[13:0];
                weight3_b_new[i] = init_val[27:14];
                weight3_c_new[i] = init_val[41:28];
                weight3_d_new[i] = init_val[55:42];
                weight3_e_new[i] = init_val[69:56];
            end
        end
        else begin
            
            for (integer i = 0; i<40; i=i+1) begin
                we0[i] = !up[0];
                we1[i] = !up[1];
                we2[i] = !up[2];
                we3[i] = !up[3];
                weight0_a_new[i] = $signed(datas_0[i][13:0]) + $signed({11{up[0]}}&delta[5*i]);
                weight0_b_new[i] = $signed(datas_0[i][27:14]) + $signed({11{up[0]}}&delta[5*i+1]);
                weight0_c_new[i] = $signed(datas_0[i][41:28])+ $signed({11{up[0]}}&delta[5*i+2]);
                weight0_d_new[i] = $signed(datas_0[i][55:42]) + $signed({11{up[0]}}&delta[5*i+3]);
                weight0_e_new[i] = $signed(datas_0[i][69:56]) + $signed({11{up[0]}}&delta[5*i+4]);
                
                weight1_a_new[i] = $signed(datas_1[i][13:0]) + $signed({11{up[1]}}&delta[5*i]);
                weight1_b_new[i] = $signed(datas_1[i][27:14]) + $signed({11{up[1]}}&delta[5*i+1]);
                weight1_c_new[i] = $signed(datas_1[i][41:28]) + $signed({11{up[1]}}&delta[5*i+2]);
                weight1_d_new[i] = $signed(datas_1[i][55:42]) + $signed({11{up[1]}}&delta[5*i+3]);
                weight1_e_new[i] = $signed(datas_1[i][69:56]) + $signed({11{up[1]}}&delta[5*i+4]);
               
                weight2_a_new[i] = $signed(datas_2[i][13:0]) + $signed({11{up[2]}}&delta[5*i]);
                weight2_b_new[i] = $signed(datas_2[i][27:14]) + $signed({11{up[2]}}&delta[5*i+1]);
                weight2_c_new[i] = $signed(datas_2[i][41:28]) + $signed({11{up[2]}}&delta[5*i+2]);
                weight2_d_new[i] = $signed(datas_2[i][55:42]) + $signed({11{up[2]}}&delta[5*i+3]);
                weight2_e_new[i] = $signed(datas_2[i][69:56]) + $signed({11{up[2]}}&delta[5*i+4]);
              
                weight3_a_new[i] = $signed(datas_3[i][13:0]) + $signed({11{up[3]}}&delta[5*i]);
                weight3_b_new[i] = $signed(datas_3[i][27:14]) + $signed({11{up[3]}}&delta[5*i+1]);
                weight3_c_new[i] = $signed(datas_3[i][41:28]) + $signed({11{up[3]}}&delta[5*i+2]);
                weight3_d_new[i] = $signed(datas_3[i][55:42]) + $signed({11{up[3]}}&delta[5*i+3]);
                weight3_e_new[i] = $signed(datas_3[i][69:56]) + $signed({11{up[3]}}&delta[5*i+4]);
             
            end
        end
end  


    sigmoid sig0(.x(sigmoid_input1), .y(sigmoid_output1));
    sigmoid sig1(.x(sigmoid_input2), .y(sigmoid_output2));
    sigdiff sigdiff(.x(sigdiff_input), .y(sigdiff_output));
    
    always @(posedge clk or negedge resetn) begin
        if (resetn==1'b0) begin
            sendspike_counter <= 'd1;
            //All registers should be reset
            out_spike <= 'd0;
            //add <= 'd0;
            spikenotfinbuf <= 'd0;
            add0 <= 'd0; 
            errcounter <= 'd0;
            truecounter <= 'd0;
            init_regs <= 'd1;
            spike_addr_counter <= 'd0;
            process_counter <= 'd0;
            upval <= 'd0;
            upvalbuff <= 'd0;
            write_addr <= 'd0;
            up_addr <= 'd0;
            init_fin <= 'd0;
            buffer_counter0 <= 'd0;
            buffer_counter1 <= 'd0;
            buffer_counter2 <= 'd0;
            proc_buffer0 <= 'd0;
            proc_buffer1 <= 'd0;
            proc_buffer2 <= 'd0;
            up <= 'd0;
            up0 <= 'd0;
            in_spikes0 <= 'd0;
            in_spikes1 <= 'd0;
            in_spikes2 <= 'd0;
            in_spikes3 <= 'd0;
            in_spikes4 <= 'd0;
            in_spikes5 <= 'd0;
            addr_eq_195 <= 'd0;
            gen_spike_buff <= 'd0;
            gen_spike <= 'd0;
            layer_proc_fin <= 'd0;
            y1 <= 'd0;
            y2 <= 'd0;
            y3 <= 'd0;
            y3_buf <= 'd0;
            y_sub <= 'd0;
            
            for (integer i=0;i<200;i=i+1) begin
                delta[i] <= 'd0;
                delta_[i] <= 'd0;
            end 
           
            for (integer i=0;i<40;i=i+1) begin
 	            weight0_a[i] <= 'd0; 
 	            weight0_b[i] <= 'd0;
 	            weight0_c[i] <= 'd0;
 	            weight0_d[i] <= 'd0;
 	            weight0_e[i] <= 'd0;
 	            weight1_a[i] <= 'd0;
 	            weight1_b[i] <= 'd0;
 	            weight1_c[i] <= 'd0; 
                weight1_d[i] <= 'd0;
                weight1_e[i] <= 'd0;
                weight2_a[i] <= 'd0;
                weight2_b[i] <= 'd0;
                weight2_c[i] <= 'd0;
                weight2_d[i] <= 'd0;
                weight2_e[i] <= 'd0;
                weight3_a[i] <= 'd0;
                weight3_b[i] <= 'd0;
                weight3_c[i] <= 'd0;
                weight3_d[i] <= 'd0;
                weight3_e[i] <= 'd0;
             end
                                                 
        end
        
        else begin
            spikenotfinbuf <= spike_process_not_fin;
            //add <= add;
            //add0 is buffered since "read data" will be ready on next cycle.
            add0 <= add;
            //add0 <= ({4{spike_process_not_fin}}&in_spikes);
            if (initialize) begin
                if (initialize_begin) begin
                    if (write_addr=='d195) begin
                        if (init_regs[159]==1'b1) begin
                            init_fin <= 1'b1;
                        //init_regs[159:1] <= 'd0;
                        end
                        for (integer i=0;i<160;i=i+1) begin
                            init_regs[i+1] <= init_regs[i];
                        end
                        init_regs[0] <= 1'b0;
                        write_addr <= 'd0;
                    end
                
                    else begin
                        write_addr <= write_addr + 'd1;
                    end
                end
                
               
              
            end
            else begin
                 write_addr <= buffer_counter0;
            end
                 
            
            for (integer i=0;i<40;i=i+1) begin
                datas_0[i] <= datas0[i];
                datas_1[i] <= datas1[i];
                datas_2[i] <= datas2[i];
                datas_3[i] <= datas3[i];
            end
           
            if (add0[0]==1'b1) begin
            for (integer i=0;i<40;i=i+1) begin
 	            weight0_a[i] <= datas0[i][13:5];
 	            weight0_b[i] <= datas0[i][27:19];
 	            weight0_c[i] <= datas0[i][41:33];
 	            weight0_d[i] <= datas0[i][55:47];
 	            weight0_e[i] <= datas0[i][69:61];
 	        end                                 
            end
            else begin
            for (integer i=0;i<40;i=i+1) begin
 	            weight0_a[i] <= 'd0;
 	            weight0_b[i] <= 'd0;
 	            weight0_c[i] <= 'd0;
 	            weight0_d[i] <= 'd0;
 	            weight0_e[i] <= 'd0;
 	        end                                 
            end
            
            if (add0[1]==1'b1) begin
            for (integer i=0;i<40;i=i+1) begin
                weight1_a[i] <= datas1[i][13:5];
 	            weight1_b[i] <= datas1[i][27:19];
 	            weight1_c[i] <= datas1[i][41:33];
                weight1_d[i] <= datas1[i][55:47];
                weight1_e[i] <= datas1[i][69:61];
            end
            end
            else begin
            for (integer i=0;i<40;i=i+1) begin
 	            weight1_a[i] <= 'd0;
 	            weight1_b[i] <= 'd0;
 	            weight1_c[i] <= 'd0;
 	            weight1_d[i] <= 'd0;
 	            weight1_e[i] <= 'd0;
 	        end
            end                                 

            if(add0[2]==1'b1) begin
            for (integer i=0;i<40;i=i+1) begin
                weight2_a[i] <= datas2[i][13:5];
                weight2_b[i] <= datas2[i][27:19];
                weight2_c[i] <= datas2[i][41:33];
                weight2_d[i] <= datas2[i][55:47];
                weight2_e[i] <= datas2[i][69:61];
            end
            end
            else begin
            for (integer i=0;i<40;i=i+1) begin
 	            weight2_a[i] <= 'd0;
 	            weight2_b[i] <= 'd0;
 	            weight2_c[i] <= 'd0;
 	            weight2_d[i] <= 'd0;
 	            weight2_e[i] <= 'd0;
 	        end
            end

            if(add0[3]==1'b1) begin
            for (integer i=0;i<40;i=i+1) begin
                weight3_a[i] <= datas3[i][13:5];
                weight3_b[i] <= datas3[i][27:19];
                weight3_c[i] <= datas3[i][41:33];
                weight3_d[i] <= datas3[i][55:47];
                weight3_e[i] <= datas3[i][69:61];
            end
            end
            else begin
            for (integer i=0;i<40;i=i+1) begin
 	            weight3_a[i] <= 'd0;
 	            weight3_b[i] <= 'd0;
 	            weight3_c[i] <= 'd0;
 	            weight3_d[i] <= 'd0;
 	            weight3_e[i] <= 'd0;
 	        end            
            end


                      
            
            if (new_block) begin
                sendspike_counter <= 'd1;
                gen_spike <= 'd0;
                gen_spike_buff <= 'd0;
                errcounter <= 'd0;
                truecounter <= 'd0;
                spike_addr_counter <='d0;
                out_spike <= spikes[0]; 
                in_spikes1 <= in_spikes0;
                in_spikes2 <= in_spikes1;
                in_spikes3 <= in_spikes2;
                in_spikes4 <= in_spikes3;
                in_spikes5 <= in_spikes4;
                process_counter <= 'd0;
                up <= 'd0;
                up0 <= 'd0;

                layer_proc_fin <= 1'b0;
                write_addr <= 'd0;
                up_addr <= 'd0;
                buffer_counter0 <= 'd0;
                buffer_counter1 <= 'd0;
                buffer_counter2 <= 'd0;
                proc_buffer0 <= 'd0;
                proc_buffer1 <= 'd0;
                proc_buffer2 <= 'd0;
                if (train) begin
                    for (integer i=0;i<200;i=i+1) begin
                        delta[i] <= delta_[i];
                    end
                end

            end
            
            else begin            
            gen_spike_buff[0] <= (spike_addr_counter =='d195);
            for (integer i=0;i<5;i=i+1) begin                                   
                gen_spike_buff[i+1] <= gen_spike_buff[i];                   
            end
            gen_spike <= gen_spike_buff[4];
                                                                
            if (train) begin
                //Should be changed to rounding
                //Rounding logic: if [8] is 1, round up;
                upvalbuff <= upval_;
                upval <= $signed($unsigned(upvalbuff[20:12])+$unsigned(upvalbuff[11]));
                delta_[up_addr] <= upval;
                y1 <= sigmoid_output1;
                y2 <= sigmoid_output2;
                y3_buf <= sigdiff_output;
                y3 <= y3_buf;
                y_sub <= y1_extended - y2_extended;
            end
            if (errspikes) begin
                errcounter <= errcounter + 'd1;
            end
            else if (truespikes) begin
                truecounter <= truecounter + 'd1;
            end
            if (up_addr=='d199) begin 
                layer_proc_fin <= 1'b1; 
            end
            
            if (errspikes) begin
                errcounter <= errcounter + 'd1;
            end
            if (truespikes) begin
                truecounter <= truecounter + 'd1;
            end
            if (spike_addr_counter < 'd195) begin
                spike_addr_counter <= spike_addr_counter + 'd1;
            end

            if ((train)&(spike_addr_counter<'d196)) begin 
                in_spikes0[spike_addr_counter + 'd588] <= in_spikes[3];
                in_spikes0[spike_addr_counter + 'd392] <= in_spikes[2];
                in_spikes0[spike_addr_counter + 'd196] <= in_spikes[1];
                in_spikes0[spike_addr_counter] <= in_spikes[0];
                up <= up0;  
                
                //One Buffer, so that update happens later
                up0[3] <= in_spikes5[spike_addr_counter + 'd588];
                up0[2] <= in_spikes5[spike_addr_counter + 'd392];
                up0[1] <= in_spikes5[spike_addr_counter + 'd196];
                up0[0] <= in_spikes5[spike_addr_counter];
            end
            else if (infer & spike_process_not_fin) begin 
                spike_addr_counter <=  spike_addr_counter + 'd1;
                in_spikes0 <= 'd0;
                in_spikes1 <= 'd0;
                in_spikes2 <= 'd0;
                in_spikes3 <= 'd0;
                in_spikes4 <= 'd0;
                in_spikes5 <= 'd0;
                up <= 'd0;
            end
            else begin
                up <= 'd0;
            end
            //2 buffers before address enters "up" value
            up_addr <= proc_buffer2;
            
            
            
            
            buffer_counter2 <= buffer_counter1;
            buffer_counter1 <= buffer_counter0;
            buffer_counter0 <= spike_addr_counter;
            
            proc_buffer2 <= proc_buffer1;
            proc_buffer1 <= proc_buffer0;
            proc_buffer0 <= process_counter;
            
            //Write address: 1 buffer stage for fetching correct data.
            if (process_counter<199) begin 
                process_counter <= process_counter + 'd1;
            end
            else begin
              
                process_counter <= process_counter;
            end
            
            if (sendspike_counter<199) begin
                out_spike <= spikes[sendspike_counter];
                sendspike_counter <= sendspike_counter + 'd1;
            end
            else begin
                out_spike <= 'd0;
                sendspike_counter <= sendspike_counter;
            end

        end
    end
end
  
	TS6N65LPLLA200X70M2S ram0_0(.CLKW(clk),.CLKR(clk),.AA(write_addr), .AB(spike_addr_counter),.D(data0_new[0]), .BWEB(70'd0), .WEB(we0[0]), .Q(datas0[0]), .REB(read[0]), 
	.AMA(8'd0), .DM(70'd0), .BWEBM(70'd0), .WEBM(1'b1), .AMB(8'd0), .REBM(1'b1),.BIST(1'b0));
	TS6N65LPLLA200X70M2S ram0_1(.CLKW(clk),.CLKR(clk),.AA(write_addr), .AB(spike_addr_counter),.D(data0_new[1]), .BWEB(70'd0), .WEB(we0[1]), .Q(datas0[1]), .REB(read[0]), 
	.AMA(8'd0), .DM(70'd0), .BWEBM(70'd0), .WEBM(1'b1), .AMB(8'd0), .REBM(1'b1),.BIST(1'b0));
	TS6N65LPLLA200X70M2S ram0_2(.CLKW(clk),.CLKR(clk),.AA(write_addr), .AB(spike_addr_counter),.D(data0_new[2]), .BWEB(70'd0), .WEB(we0[2]), .Q(datas0[2]), .REB(read[0]), 
	.AMA(8'd0), .DM(70'd0), .BWEBM(70'd0), .WEBM(1'b1), .AMB(8'd0), .REBM(1'b1),.BIST(1'b0));
	TS6N65LPLLA200X70M2S ram0_3(.CLKW(clk),.CLKR(clk),.AA(write_addr), .AB(spike_addr_counter),.D(data0_new[3]), .BWEB(70'd0), .WEB(we0[3]), .Q(datas0[3]), .REB(read[0]), 
	.AMA(8'd0), .DM(70'd0), .BWEBM(70'd0), .WEBM(1'b1), .AMB(8'd0), .REBM(1'b1),.BIST(1'b0));
	TS6N65LPLLA200X70M2S ram0_4(.CLKW(clk),.CLKR(clk),.AA(write_addr), .AB(spike_addr_counter),.D(data0_new[4]), .BWEB(70'd0), .WEB(we0[4]), .Q(datas0[4]), .REB(read[0]), 
	.AMA(8'd0), .DM(70'd0), .BWEBM(70'd0), .WEBM(1'b1), .AMB(8'd0), .REBM(1'b1),.BIST(1'b0));
	TS6N65LPLLA200X70M2S ram0_5(.CLKW(clk),.CLKR(clk),.AA(write_addr), .AB(spike_addr_counter),.D(data0_new[5]), .BWEB(70'd0), .WEB(we0[5]), .Q(datas0[5]), .REB(read[0]), 
	.AMA(8'd0), .DM(70'd0), .BWEBM(70'd0), .WEBM(1'b1), .AMB(8'd0), .REBM(1'b1),.BIST(1'b0));
	TS6N65LPLLA200X70M2S ram0_6(.CLKW(clk),.CLKR(clk),.AA(write_addr), .AB(spike_addr_counter),.D(data0_new[6]), .BWEB(70'd0), .WEB(we0[6]), .Q(datas0[6]), .REB(read[0]), 
	.AMA(8'd0), .DM(70'd0), .BWEBM(70'd0), .WEBM(1'b1), .AMB(8'd0), .REBM(1'b1),.BIST(1'b0));
	TS6N65LPLLA200X70M2S ram0_7(.CLKW(clk),.CLKR(clk),.AA(write_addr), .AB(spike_addr_counter),.D(data0_new[7]), .BWEB(70'd0), .WEB(we0[7]), .Q(datas0[7]), .REB(read[0]), 
	.AMA(8'd0), .DM(70'd0), .BWEBM(70'd0), .WEBM(1'b1), .AMB(8'd0), .REBM(1'b1),.BIST(1'b0));
	TS6N65LPLLA200X70M2S ram0_8(.CLKW(clk),.CLKR(clk),.AA(write_addr), .AB(spike_addr_counter),.D(data0_new[8]), .BWEB(70'd0), .WEB(we0[8]), .Q(datas0[8]), .REB(read[0]), 
	.AMA(8'd0), .DM(70'd0), .BWEBM(70'd0), .WEBM(1'b1), .AMB(8'd0), .REBM(1'b1),.BIST(1'b0));
	TS6N65LPLLA200X70M2S ram0_9(.CLKW(clk),.CLKR(clk),.AA(write_addr), .AB(spike_addr_counter),.D(data0_new[9]), .BWEB(70'd0), .WEB(we0[9]), .Q(datas0[9]), .REB(read[0]), 
	.AMA(8'd0), .DM(70'd0), .BWEBM(70'd0), .WEBM(1'b1), .AMB(8'd0), .REBM(1'b1),.BIST(1'b0));
	TS6N65LPLLA200X70M2S ram0_10(.CLKW(clk),.CLKR(clk),.AA(write_addr), .AB(spike_addr_counter),.D(data0_new[10]), .BWEB(70'd0), .WEB(we0[10]), .Q(datas0[10]), .REB(read[0]), 
	.AMA(8'd0), .DM(70'd0), .BWEBM(70'd0), .WEBM(1'b1), .AMB(8'd0), .REBM(1'b1),.BIST(1'b0));
	TS6N65LPLLA200X70M2S ram0_11(.CLKW(clk),.CLKR(clk),.AA(write_addr), .AB(spike_addr_counter),.D(data0_new[11]), .BWEB(70'd0), .WEB(we0[11]), .Q(datas0[11]), .REB(read[0]), 
	.AMA(8'd0), .DM(70'd0), .BWEBM(70'd0), .WEBM(1'b1), .AMB(8'd0), .REBM(1'b1),.BIST(1'b0));
	TS6N65LPLLA200X70M2S ram0_12(.CLKW(clk),.CLKR(clk),.AA(write_addr), .AB(spike_addr_counter),.D(data0_new[12]), .BWEB(70'd0), .WEB(we0[12]), .Q(datas0[12]), .REB(read[0]), 
	.AMA(8'd0), .DM(70'd0), .BWEBM(70'd0), .WEBM(1'b1), .AMB(8'd0), .REBM(1'b1),.BIST(1'b0));
	TS6N65LPLLA200X70M2S ram0_13(.CLKW(clk),.CLKR(clk),.AA(write_addr), .AB(spike_addr_counter),.D(data0_new[13]), .BWEB(70'd0), .WEB(we0[13]), .Q(datas0[13]), .REB(read[0]), 
	.AMA(8'd0), .DM(70'd0), .BWEBM(70'd0), .WEBM(1'b1), .AMB(8'd0), .REBM(1'b1),.BIST(1'b0));
	TS6N65LPLLA200X70M2S ram0_14(.CLKW(clk),.CLKR(clk),.AA(write_addr), .AB(spike_addr_counter),.D(data0_new[14]), .BWEB(70'd0), .WEB(we0[14]), .Q(datas0[14]), .REB(read[0]), 
	.AMA(8'd0), .DM(70'd0), .BWEBM(70'd0), .WEBM(1'b1), .AMB(8'd0), .REBM(1'b1),.BIST(1'b0));
	TS6N65LPLLA200X70M2S ram0_15(.CLKW(clk),.CLKR(clk),.AA(write_addr), .AB(spike_addr_counter),.D(data0_new[15]), .BWEB(70'd0), .WEB(we0[15]), .Q(datas0[15]), .REB(read[0]), 
	.AMA(8'd0), .DM(70'd0), .BWEBM(70'd0), .WEBM(1'b1), .AMB(8'd0), .REBM(1'b1),.BIST(1'b0));
	TS6N65LPLLA200X70M2S ram0_16(.CLKW(clk),.CLKR(clk),.AA(write_addr), .AB(spike_addr_counter),.D(data0_new[16]), .BWEB(70'd0), .WEB(we0[16]), .Q(datas0[16]), .REB(read[0]), 
	.AMA(8'd0), .DM(70'd0), .BWEBM(70'd0), .WEBM(1'b1), .AMB(8'd0), .REBM(1'b1),.BIST(1'b0));
	TS6N65LPLLA200X70M2S ram0_17(.CLKW(clk),.CLKR(clk),.AA(write_addr), .AB(spike_addr_counter),.D(data0_new[17]), .BWEB(70'd0), .WEB(we0[17]), .Q(datas0[17]), .REB(read[0]), 
	.AMA(8'd0), .DM(70'd0), .BWEBM(70'd0), .WEBM(1'b1), .AMB(8'd0), .REBM(1'b1),.BIST(1'b0));
	TS6N65LPLLA200X70M2S ram0_18(.CLKW(clk),.CLKR(clk),.AA(write_addr), .AB(spike_addr_counter),.D(data0_new[18]), .BWEB(70'd0), .WEB(we0[18]), .Q(datas0[18]), .REB(read[0]), 
	.AMA(8'd0), .DM(70'd0), .BWEBM(70'd0), .WEBM(1'b1), .AMB(8'd0), .REBM(1'b1),.BIST(1'b0));
	TS6N65LPLLA200X70M2S ram0_19(.CLKW(clk),.CLKR(clk),.AA(write_addr), .AB(spike_addr_counter),.D(data0_new[19]), .BWEB(70'd0), .WEB(we0[19]), .Q(datas0[19]), .REB(read[0]), 
	.AMA(8'd0), .DM(70'd0), .BWEBM(70'd0), .WEBM(1'b1), .AMB(8'd0), .REBM(1'b1),.BIST(1'b0));
	TS6N65LPLLA200X70M2S ram0_20(.CLKW(clk),.CLKR(clk),.AA(write_addr), .AB(spike_addr_counter),.D(data0_new[20]), .BWEB(70'd0), .WEB(we0[20]), .Q(datas0[20]), .REB(read[0]), 
	.AMA(8'd0), .DM(70'd0), .BWEBM(70'd0), .WEBM(1'b1), .AMB(8'd0), .REBM(1'b1),.BIST(1'b0));
	TS6N65LPLLA200X70M2S ram0_21(.CLKW(clk),.CLKR(clk),.AA(write_addr), .AB(spike_addr_counter),.D(data0_new[21]), .BWEB(70'd0), .WEB(we0[21]), .Q(datas0[21]), .REB(read[0]), 
	.AMA(8'd0), .DM(70'd0), .BWEBM(70'd0), .WEBM(1'b1), .AMB(8'd0), .REBM(1'b1),.BIST(1'b0));
	TS6N65LPLLA200X70M2S ram0_22(.CLKW(clk),.CLKR(clk),.AA(write_addr), .AB(spike_addr_counter),.D(data0_new[22]), .BWEB(70'd0), .WEB(we0[22]), .Q(datas0[22]), .REB(read[0]), 
	.AMA(8'd0), .DM(70'd0), .BWEBM(70'd0), .WEBM(1'b1), .AMB(8'd0), .REBM(1'b1),.BIST(1'b0));
	TS6N65LPLLA200X70M2S ram0_23(.CLKW(clk),.CLKR(clk),.AA(write_addr), .AB(spike_addr_counter),.D(data0_new[23]), .BWEB(70'd0), .WEB(we0[23]), .Q(datas0[23]), .REB(read[0]), 
	.AMA(8'd0), .DM(70'd0), .BWEBM(70'd0), .WEBM(1'b1), .AMB(8'd0), .REBM(1'b1),.BIST(1'b0));
	TS6N65LPLLA200X70M2S ram0_24(.CLKW(clk),.CLKR(clk),.AA(write_addr), .AB(spike_addr_counter),.D(data0_new[24]), .BWEB(70'd0), .WEB(we0[24]), .Q(datas0[24]), .REB(read[0]), 
	.AMA(8'd0), .DM(70'd0), .BWEBM(70'd0), .WEBM(1'b1), .AMB(8'd0), .REBM(1'b1),.BIST(1'b0));
	TS6N65LPLLA200X70M2S ram0_25(.CLKW(clk),.CLKR(clk),.AA(write_addr), .AB(spike_addr_counter),.D(data0_new[25]), .BWEB(70'd0), .WEB(we0[25]), .Q(datas0[25]), .REB(read[0]), 
	.AMA(8'd0), .DM(70'd0), .BWEBM(70'd0), .WEBM(1'b1), .AMB(8'd0), .REBM(1'b1),.BIST(1'b0));
	TS6N65LPLLA200X70M2S ram0_26(.CLKW(clk),.CLKR(clk),.AA(write_addr), .AB(spike_addr_counter),.D(data0_new[26]), .BWEB(70'd0), .WEB(we0[26]), .Q(datas0[26]), .REB(read[0]), 
	.AMA(8'd0), .DM(70'd0), .BWEBM(70'd0), .WEBM(1'b1), .AMB(8'd0), .REBM(1'b1),.BIST(1'b0));
	TS6N65LPLLA200X70M2S ram0_27(.CLKW(clk),.CLKR(clk),.AA(write_addr), .AB(spike_addr_counter),.D(data0_new[27]), .BWEB(70'd0), .WEB(we0[27]), .Q(datas0[27]), .REB(read[0]), 
	.AMA(8'd0), .DM(70'd0), .BWEBM(70'd0), .WEBM(1'b1), .AMB(8'd0), .REBM(1'b1),.BIST(1'b0));
	TS6N65LPLLA200X70M2S ram0_28(.CLKW(clk),.CLKR(clk),.AA(write_addr), .AB(spike_addr_counter),.D(data0_new[28]), .BWEB(70'd0), .WEB(we0[28]), .Q(datas0[28]), .REB(read[0]), 
	.AMA(8'd0), .DM(70'd0), .BWEBM(70'd0), .WEBM(1'b1), .AMB(8'd0), .REBM(1'b1),.BIST(1'b0));
	TS6N65LPLLA200X70M2S ram0_29(.CLKW(clk),.CLKR(clk),.AA(write_addr), .AB(spike_addr_counter),.D(data0_new[29]), .BWEB(70'd0), .WEB(we0[29]), .Q(datas0[29]), .REB(read[0]), 
	.AMA(8'd0), .DM(70'd0), .BWEBM(70'd0), .WEBM(1'b1), .AMB(8'd0), .REBM(1'b1),.BIST(1'b0));
	TS6N65LPLLA200X70M2S ram0_30(.CLKW(clk),.CLKR(clk),.AA(write_addr), .AB(spike_addr_counter),.D(data0_new[30]), .BWEB(70'd0), .WEB(we0[30]), .Q(datas0[30]), .REB(read[0]), 
	.AMA(8'd0), .DM(70'd0), .BWEBM(70'd0), .WEBM(1'b1), .AMB(8'd0), .REBM(1'b1),.BIST(1'b0));
	TS6N65LPLLA200X70M2S ram0_31(.CLKW(clk),.CLKR(clk),.AA(write_addr), .AB(spike_addr_counter),.D(data0_new[31]), .BWEB(70'd0), .WEB(we0[31]), .Q(datas0[31]), .REB(read[0]), 
	.AMA(8'd0), .DM(70'd0), .BWEBM(70'd0), .WEBM(1'b1), .AMB(8'd0), .REBM(1'b1),.BIST(1'b0));
	TS6N65LPLLA200X70M2S ram0_32(.CLKW(clk),.CLKR(clk),.AA(write_addr), .AB(spike_addr_counter),.D(data0_new[32]), .BWEB(70'd0), .WEB(we0[32]), .Q(datas0[32]), .REB(read[0]), 
	.AMA(8'd0), .DM(70'd0), .BWEBM(70'd0), .WEBM(1'b1), .AMB(8'd0), .REBM(1'b1),.BIST(1'b0));
	TS6N65LPLLA200X70M2S ram0_33(.CLKW(clk),.CLKR(clk),.AA(write_addr), .AB(spike_addr_counter),.D(data0_new[33]), .BWEB(70'd0), .WEB(we0[33]), .Q(datas0[33]), .REB(read[0]), 
	.AMA(8'd0), .DM(70'd0), .BWEBM(70'd0), .WEBM(1'b1), .AMB(8'd0), .REBM(1'b1),.BIST(1'b0));
	TS6N65LPLLA200X70M2S ram0_34(.CLKW(clk),.CLKR(clk),.AA(write_addr), .AB(spike_addr_counter),.D(data0_new[34]), .BWEB(70'd0), .WEB(we0[34]), .Q(datas0[34]), .REB(read[0]), 
	.AMA(8'd0), .DM(70'd0), .BWEBM(70'd0), .WEBM(1'b1), .AMB(8'd0), .REBM(1'b1),.BIST(1'b0));
	TS6N65LPLLA200X70M2S ram0_35(.CLKW(clk),.CLKR(clk),.AA(write_addr), .AB(spike_addr_counter),.D(data0_new[35]), .BWEB(70'd0), .WEB(we0[35]), .Q(datas0[35]), .REB(read[0]), 
	.AMA(8'd0), .DM(70'd0), .BWEBM(70'd0), .WEBM(1'b1), .AMB(8'd0), .REBM(1'b1),.BIST(1'b0));
	TS6N65LPLLA200X70M2S ram0_36(.CLKW(clk),.CLKR(clk),.AA(write_addr), .AB(spike_addr_counter),.D(data0_new[36]), .BWEB(70'd0), .WEB(we0[36]), .Q(datas0[36]), .REB(read[0]), 
	.AMA(8'd0), .DM(70'd0), .BWEBM(70'd0), .WEBM(1'b1), .AMB(8'd0), .REBM(1'b1),.BIST(1'b0));
	TS6N65LPLLA200X70M2S ram0_37(.CLKW(clk),.CLKR(clk),.AA(write_addr), .AB(spike_addr_counter),.D(data0_new[37]), .BWEB(70'd0), .WEB(we0[37]), .Q(datas0[37]), .REB(read[0]), 
	.AMA(8'd0), .DM(70'd0), .BWEBM(70'd0), .WEBM(1'b1), .AMB(8'd0), .REBM(1'b1),.BIST(1'b0));
	TS6N65LPLLA200X70M2S ram0_38(.CLKW(clk),.CLKR(clk),.AA(write_addr), .AB(spike_addr_counter),.D(data0_new[38]), .BWEB(70'd0), .WEB(we0[38]), .Q(datas0[38]), .REB(read[0]), 
	.AMA(8'd0), .DM(70'd0), .BWEBM(70'd0), .WEBM(1'b1), .AMB(8'd0), .REBM(1'b1),.BIST(1'b0));
	TS6N65LPLLA200X70M2S ram0_39(.CLKW(clk),.CLKR(clk),.AA(write_addr), .AB(spike_addr_counter),.D(data0_new[39]), .BWEB(70'd0), .WEB(we0[39]), .Q(datas0[39]), .REB(read[0]), 
	.AMA(8'd0), .DM(70'd0), .BWEBM(70'd0), .WEBM(1'b1), .AMB(8'd0), .REBM(1'b1),.BIST(1'b0));

	TS6N65LPLLA200X70M2S ram1_0(.CLKW(clk),.CLKR(clk),.AA(write_addr), .AB(spike_addr_counter),.D(data1_new[0]), .BWEB(70'd0), .WEB(we1[0]), .Q(datas1[0]), .REB(read[1]), 
	.AMA(8'd0), .DM(70'd0), .BWEBM(70'd0), .WEBM(1'b1), .AMB(8'd0), .REBM(1'b1),.BIST(1'b0));
	TS6N65LPLLA200X70M2S ram1_1(.CLKW(clk),.CLKR(clk),.AA(write_addr), .AB(spike_addr_counter),.D(data1_new[1]), .BWEB(70'd0), .WEB(we1[1]), .Q(datas1[1]), .REB(read[1]), 
	.AMA(8'd0), .DM(70'd0), .BWEBM(70'd0), .WEBM(1'b1), .AMB(8'd0), .REBM(1'b1),.BIST(1'b0));
	TS6N65LPLLA200X70M2S ram1_2(.CLKW(clk),.CLKR(clk),.AA(write_addr), .AB(spike_addr_counter),.D(data1_new[2]), .BWEB(70'd0), .WEB(we1[2]), .Q(datas1[2]), .REB(read[1]), 
	.AMA(8'd0), .DM(70'd0), .BWEBM(70'd0), .WEBM(1'b1), .AMB(8'd0), .REBM(1'b1),.BIST(1'b0));
	TS6N65LPLLA200X70M2S ram1_3(.CLKW(clk),.CLKR(clk),.AA(write_addr), .AB(spike_addr_counter),.D(data1_new[3]), .BWEB(70'd0), .WEB(we1[3]), .Q(datas1[3]), .REB(read[1]), 
	.AMA(8'd0), .DM(70'd0), .BWEBM(70'd0), .WEBM(1'b1), .AMB(8'd0), .REBM(1'b1),.BIST(1'b0));
	TS6N65LPLLA200X70M2S ram1_4(.CLKW(clk),.CLKR(clk),.AA(write_addr), .AB(spike_addr_counter),.D(data1_new[4]), .BWEB(70'd0), .WEB(we1[4]), .Q(datas1[4]), .REB(read[1]), 
	.AMA(8'd0), .DM(70'd0), .BWEBM(70'd0), .WEBM(1'b1), .AMB(8'd0), .REBM(1'b1),.BIST(1'b0));
	TS6N65LPLLA200X70M2S ram1_5(.CLKW(clk),.CLKR(clk),.AA(write_addr), .AB(spike_addr_counter),.D(data1_new[5]), .BWEB(70'd0), .WEB(we1[5]), .Q(datas1[5]), .REB(read[1]), 
	.AMA(8'd0), .DM(70'd0), .BWEBM(70'd0), .WEBM(1'b1), .AMB(8'd0), .REBM(1'b1),.BIST(1'b0));
	TS6N65LPLLA200X70M2S ram1_6(.CLKW(clk),.CLKR(clk),.AA(write_addr), .AB(spike_addr_counter),.D(data1_new[6]), .BWEB(70'd0), .WEB(we1[6]), .Q(datas1[6]), .REB(read[1]), 
	.AMA(8'd0), .DM(70'd0), .BWEBM(70'd0), .WEBM(1'b1), .AMB(8'd0), .REBM(1'b1),.BIST(1'b0));
	TS6N65LPLLA200X70M2S ram1_7(.CLKW(clk),.CLKR(clk),.AA(write_addr), .AB(spike_addr_counter),.D(data1_new[7]), .BWEB(70'd0), .WEB(we1[7]), .Q(datas1[7]), .REB(read[1]), 
	.AMA(8'd0), .DM(70'd0), .BWEBM(70'd0), .WEBM(1'b1), .AMB(8'd0), .REBM(1'b1),.BIST(1'b0));
	TS6N65LPLLA200X70M2S ram1_8(.CLKW(clk),.CLKR(clk),.AA(write_addr), .AB(spike_addr_counter),.D(data1_new[8]), .BWEB(70'd0), .WEB(we1[8]), .Q(datas1[8]), .REB(read[1]), 
	.AMA(8'd0), .DM(70'd0), .BWEBM(70'd0), .WEBM(1'b1), .AMB(8'd0), .REBM(1'b1),.BIST(1'b0));
	TS6N65LPLLA200X70M2S ram1_9(.CLKW(clk),.CLKR(clk),.AA(write_addr), .AB(spike_addr_counter),.D(data1_new[9]), .BWEB(70'd0), .WEB(we1[9]), .Q(datas1[9]), .REB(read[1]), 
	.AMA(8'd0), .DM(70'd0), .BWEBM(70'd0), .WEBM(1'b1), .AMB(8'd0), .REBM(1'b1),.BIST(1'b0));
	TS6N65LPLLA200X70M2S ram1_10(.CLKW(clk),.CLKR(clk),.AA(write_addr), .AB(spike_addr_counter),.D(data1_new[10]), .BWEB(70'd0), .WEB(we1[10]), .Q(datas1[10]), .REB(read[1]), 
	.AMA(8'd0), .DM(70'd0), .BWEBM(70'd0), .WEBM(1'b1), .AMB(8'd0), .REBM(1'b1),.BIST(1'b0));
	TS6N65LPLLA200X70M2S ram1_11(.CLKW(clk),.CLKR(clk),.AA(write_addr), .AB(spike_addr_counter),.D(data1_new[11]), .BWEB(70'd0), .WEB(we1[11]), .Q(datas1[11]), .REB(read[1]), 
	.AMA(8'd0), .DM(70'd0), .BWEBM(70'd0), .WEBM(1'b1), .AMB(8'd0), .REBM(1'b1),.BIST(1'b0));
	TS6N65LPLLA200X70M2S ram1_12(.CLKW(clk),.CLKR(clk),.AA(write_addr), .AB(spike_addr_counter),.D(data1_new[12]), .BWEB(70'd0), .WEB(we1[12]), .Q(datas1[12]), .REB(read[1]), 
	.AMA(8'd0), .DM(70'd0), .BWEBM(70'd0), .WEBM(1'b1), .AMB(8'd0), .REBM(1'b1),.BIST(1'b0));
	TS6N65LPLLA200X70M2S ram1_13(.CLKW(clk),.CLKR(clk),.AA(write_addr), .AB(spike_addr_counter),.D(data1_new[13]), .BWEB(70'd0), .WEB(we1[13]), .Q(datas1[13]), .REB(read[1]), 
	.AMA(8'd0), .DM(70'd0), .BWEBM(70'd0), .WEBM(1'b1), .AMB(8'd0), .REBM(1'b1),.BIST(1'b0));
	TS6N65LPLLA200X70M2S ram1_14(.CLKW(clk),.CLKR(clk),.AA(write_addr), .AB(spike_addr_counter),.D(data1_new[14]), .BWEB(70'd0), .WEB(we1[14]), .Q(datas1[14]), .REB(read[1]), 
	.AMA(8'd0), .DM(70'd0), .BWEBM(70'd0), .WEBM(1'b1), .AMB(8'd0), .REBM(1'b1),.BIST(1'b0));
	TS6N65LPLLA200X70M2S ram1_15(.CLKW(clk),.CLKR(clk),.AA(write_addr), .AB(spike_addr_counter),.D(data1_new[15]), .BWEB(70'd0), .WEB(we1[15]), .Q(datas1[15]), .REB(read[1]), 
	.AMA(8'd0), .DM(70'd0), .BWEBM(70'd0), .WEBM(1'b1), .AMB(8'd0), .REBM(1'b1),.BIST(1'b0));
	TS6N65LPLLA200X70M2S ram1_16(.CLKW(clk),.CLKR(clk),.AA(write_addr), .AB(spike_addr_counter),.D(data1_new[16]), .BWEB(70'd0), .WEB(we1[16]), .Q(datas1[16]), .REB(read[1]), 
	.AMA(8'd0), .DM(70'd0), .BWEBM(70'd0), .WEBM(1'b1), .AMB(8'd0), .REBM(1'b1),.BIST(1'b0));
	TS6N65LPLLA200X70M2S ram1_17(.CLKW(clk),.CLKR(clk),.AA(write_addr), .AB(spike_addr_counter),.D(data1_new[17]), .BWEB(70'd0), .WEB(we1[17]), .Q(datas1[17]), .REB(read[1]), 
	.AMA(8'd0), .DM(70'd0), .BWEBM(70'd0), .WEBM(1'b1), .AMB(8'd0), .REBM(1'b1),.BIST(1'b0));
	TS6N65LPLLA200X70M2S ram1_18(.CLKW(clk),.CLKR(clk),.AA(write_addr), .AB(spike_addr_counter),.D(data1_new[18]), .BWEB(70'd0), .WEB(we1[18]), .Q(datas1[18]), .REB(read[1]), 
	.AMA(8'd0), .DM(70'd0), .BWEBM(70'd0), .WEBM(1'b1), .AMB(8'd0), .REBM(1'b1),.BIST(1'b0));
	TS6N65LPLLA200X70M2S ram1_19(.CLKW(clk),.CLKR(clk),.AA(write_addr), .AB(spike_addr_counter),.D(data1_new[19]), .BWEB(70'd0), .WEB(we1[19]), .Q(datas1[19]), .REB(read[1]), 
	.AMA(8'd0), .DM(70'd0), .BWEBM(70'd0), .WEBM(1'b1), .AMB(8'd0), .REBM(1'b1),.BIST(1'b0));
	TS6N65LPLLA200X70M2S ram1_20(.CLKW(clk),.CLKR(clk),.AA(write_addr), .AB(spike_addr_counter),.D(data1_new[20]), .BWEB(70'd0), .WEB(we1[20]), .Q(datas1[20]), .REB(read[1]), 
	.AMA(8'd0), .DM(70'd0), .BWEBM(70'd0), .WEBM(1'b1), .AMB(8'd0), .REBM(1'b1),.BIST(1'b0));
	TS6N65LPLLA200X70M2S ram1_21(.CLKW(clk),.CLKR(clk),.AA(write_addr), .AB(spike_addr_counter),.D(data1_new[21]), .BWEB(70'd0), .WEB(we1[21]), .Q(datas1[21]), .REB(read[1]), 
	.AMA(8'd0), .DM(70'd0), .BWEBM(70'd0), .WEBM(1'b1), .AMB(8'd0), .REBM(1'b1),.BIST(1'b0));
	TS6N65LPLLA200X70M2S ram1_22(.CLKW(clk),.CLKR(clk),.AA(write_addr), .AB(spike_addr_counter),.D(data1_new[22]), .BWEB(70'd0), .WEB(we1[22]), .Q(datas1[22]), .REB(read[1]), 
	.AMA(8'd0), .DM(70'd0), .BWEBM(70'd0), .WEBM(1'b1), .AMB(8'd0), .REBM(1'b1),.BIST(1'b0));
	TS6N65LPLLA200X70M2S ram1_23(.CLKW(clk),.CLKR(clk),.AA(write_addr), .AB(spike_addr_counter),.D(data1_new[23]), .BWEB(70'd0), .WEB(we1[23]), .Q(datas1[23]), .REB(read[1]), 
	.AMA(8'd0), .DM(70'd0), .BWEBM(70'd0), .WEBM(1'b1), .AMB(8'd0), .REBM(1'b1),.BIST(1'b0));
	TS6N65LPLLA200X70M2S ram1_24(.CLKW(clk),.CLKR(clk),.AA(write_addr), .AB(spike_addr_counter),.D(data1_new[24]), .BWEB(70'd0), .WEB(we1[24]), .Q(datas1[24]), .REB(read[1]), 
	.AMA(8'd0), .DM(70'd0), .BWEBM(70'd0), .WEBM(1'b1), .AMB(8'd0), .REBM(1'b1),.BIST(1'b0));
	TS6N65LPLLA200X70M2S ram1_25(.CLKW(clk),.CLKR(clk),.AA(write_addr), .AB(spike_addr_counter),.D(data1_new[25]), .BWEB(70'd0), .WEB(we1[25]), .Q(datas1[25]), .REB(read[1]), 
	.AMA(8'd0), .DM(70'd0), .BWEBM(70'd0), .WEBM(1'b1), .AMB(8'd0), .REBM(1'b1),.BIST(1'b0));
	TS6N65LPLLA200X70M2S ram1_26(.CLKW(clk),.CLKR(clk),.AA(write_addr), .AB(spike_addr_counter),.D(data1_new[26]), .BWEB(70'd0), .WEB(we1[26]), .Q(datas1[26]), .REB(read[1]), 
	.AMA(8'd0), .DM(70'd0), .BWEBM(70'd0), .WEBM(1'b1), .AMB(8'd0), .REBM(1'b1),.BIST(1'b0));
	TS6N65LPLLA200X70M2S ram1_27(.CLKW(clk),.CLKR(clk),.AA(write_addr), .AB(spike_addr_counter),.D(data1_new[27]), .BWEB(70'd0), .WEB(we1[27]), .Q(datas1[27]), .REB(read[1]), 
	.AMA(8'd0), .DM(70'd0), .BWEBM(70'd0), .WEBM(1'b1), .AMB(8'd0), .REBM(1'b1),.BIST(1'b0));
	TS6N65LPLLA200X70M2S ram1_28(.CLKW(clk),.CLKR(clk),.AA(write_addr), .AB(spike_addr_counter),.D(data1_new[28]), .BWEB(70'd0), .WEB(we1[28]), .Q(datas1[28]), .REB(read[1]), 
	.AMA(8'd0), .DM(70'd0), .BWEBM(70'd0), .WEBM(1'b1), .AMB(8'd0), .REBM(1'b1),.BIST(1'b0));
	TS6N65LPLLA200X70M2S ram1_29(.CLKW(clk),.CLKR(clk),.AA(write_addr), .AB(spike_addr_counter),.D(data1_new[29]), .BWEB(70'd0), .WEB(we1[29]), .Q(datas1[29]), .REB(read[1]), 
	.AMA(8'd0), .DM(70'd0), .BWEBM(70'd0), .WEBM(1'b1), .AMB(8'd0), .REBM(1'b1),.BIST(1'b0));
	TS6N65LPLLA200X70M2S ram1_30(.CLKW(clk),.CLKR(clk),.AA(write_addr), .AB(spike_addr_counter),.D(data1_new[30]), .BWEB(70'd0), .WEB(we1[30]), .Q(datas1[30]), .REB(read[1]), 
	.AMA(8'd0), .DM(70'd0), .BWEBM(70'd0), .WEBM(1'b1), .AMB(8'd0), .REBM(1'b1),.BIST(1'b0));
	TS6N65LPLLA200X70M2S ram1_31(.CLKW(clk),.CLKR(clk),.AA(write_addr), .AB(spike_addr_counter),.D(data1_new[31]), .BWEB(70'd0), .WEB(we1[31]), .Q(datas1[31]), .REB(read[1]), 
	.AMA(8'd0), .DM(70'd0), .BWEBM(70'd0), .WEBM(1'b1), .AMB(8'd0), .REBM(1'b1),.BIST(1'b0));
	TS6N65LPLLA200X70M2S ram1_32(.CLKW(clk),.CLKR(clk),.AA(write_addr), .AB(spike_addr_counter),.D(data1_new[32]), .BWEB(70'd0), .WEB(we1[32]), .Q(datas1[32]), .REB(read[1]), 
	.AMA(8'd0), .DM(70'd0), .BWEBM(70'd0), .WEBM(1'b1), .AMB(8'd0), .REBM(1'b1),.BIST(1'b0));
	TS6N65LPLLA200X70M2S ram1_33(.CLKW(clk),.CLKR(clk),.AA(write_addr), .AB(spike_addr_counter),.D(data1_new[33]), .BWEB(70'd0), .WEB(we1[33]), .Q(datas1[33]), .REB(read[1]), 
	.AMA(8'd0), .DM(70'd0), .BWEBM(70'd0), .WEBM(1'b1), .AMB(8'd0), .REBM(1'b1),.BIST(1'b0));
	TS6N65LPLLA200X70M2S ram1_34(.CLKW(clk),.CLKR(clk),.AA(write_addr), .AB(spike_addr_counter),.D(data1_new[34]), .BWEB(70'd0), .WEB(we1[34]), .Q(datas1[34]), .REB(read[1]), 
	.AMA(8'd0), .DM(70'd0), .BWEBM(70'd0), .WEBM(1'b1), .AMB(8'd0), .REBM(1'b1),.BIST(1'b0));
	TS6N65LPLLA200X70M2S ram1_35(.CLKW(clk),.CLKR(clk),.AA(write_addr), .AB(spike_addr_counter),.D(data1_new[35]), .BWEB(70'd0), .WEB(we1[35]), .Q(datas1[35]), .REB(read[1]), 
	.AMA(8'd0), .DM(70'd0), .BWEBM(70'd0), .WEBM(1'b1), .AMB(8'd0), .REBM(1'b1),.BIST(1'b0));
	TS6N65LPLLA200X70M2S ram1_36(.CLKW(clk),.CLKR(clk),.AA(write_addr), .AB(spike_addr_counter),.D(data1_new[36]), .BWEB(70'd0), .WEB(we1[36]), .Q(datas1[36]), .REB(read[1]), 
	.AMA(8'd0), .DM(70'd0), .BWEBM(70'd0), .WEBM(1'b1), .AMB(8'd0), .REBM(1'b1),.BIST(1'b0));
	TS6N65LPLLA200X70M2S ram1_37(.CLKW(clk),.CLKR(clk),.AA(write_addr), .AB(spike_addr_counter),.D(data1_new[37]), .BWEB(70'd0), .WEB(we1[37]), .Q(datas1[37]), .REB(read[1]), 
	.AMA(8'd0), .DM(70'd0), .BWEBM(70'd0), .WEBM(1'b1), .AMB(8'd0), .REBM(1'b1),.BIST(1'b0));
	TS6N65LPLLA200X70M2S ram1_38(.CLKW(clk),.CLKR(clk),.AA(write_addr), .AB(spike_addr_counter),.D(data1_new[38]), .BWEB(70'd0), .WEB(we1[38]), .Q(datas1[38]), .REB(read[1]), 
	.AMA(8'd0), .DM(70'd0), .BWEBM(70'd0), .WEBM(1'b1), .AMB(8'd0), .REBM(1'b1),.BIST(1'b0));
	TS6N65LPLLA200X70M2S ram1_39(.CLKW(clk),.CLKR(clk),.AA(write_addr), .AB(spike_addr_counter),.D(data1_new[39]), .BWEB(70'd0), .WEB(we1[39]), .Q(datas1[39]), .REB(read[1]), 
	.AMA(8'd0), .DM(70'd0), .BWEBM(70'd0), .WEBM(1'b1), .AMB(8'd0), .REBM(1'b1),.BIST(1'b0));

	TS6N65LPLLA200X70M2S ram2_0(.CLKW(clk),.CLKR(clk),.AA(write_addr), .AB(spike_addr_counter),.D(data2_new[0]), .BWEB(70'd0), .WEB(we2[0]), .Q(datas2[0]), .REB(read[2]), 
	.AMA(8'd0), .DM(70'd0), .BWEBM(70'd0), .WEBM(1'b1), .AMB(8'd0), .REBM(1'b1),.BIST(1'b0));
	TS6N65LPLLA200X70M2S ram2_1(.CLKW(clk),.CLKR(clk),.AA(write_addr), .AB(spike_addr_counter),.D(data2_new[1]), .BWEB(70'd0), .WEB(we2[1]), .Q(datas2[1]), .REB(read[2]), 
	.AMA(8'd0), .DM(70'd0), .BWEBM(70'd0), .WEBM(1'b1), .AMB(8'd0), .REBM(1'b1),.BIST(1'b0));
	TS6N65LPLLA200X70M2S ram2_2(.CLKW(clk),.CLKR(clk),.AA(write_addr), .AB(spike_addr_counter),.D(data2_new[2]), .BWEB(70'd0), .WEB(we2[2]), .Q(datas2[2]), .REB(read[2]), 
	.AMA(8'd0), .DM(70'd0), .BWEBM(70'd0), .WEBM(1'b1), .AMB(8'd0), .REBM(1'b1),.BIST(1'b0));
	TS6N65LPLLA200X70M2S ram2_3(.CLKW(clk),.CLKR(clk),.AA(write_addr), .AB(spike_addr_counter),.D(data2_new[3]), .BWEB(70'd0), .WEB(we2[3]), .Q(datas2[3]), .REB(read[2]), 
	.AMA(8'd0), .DM(70'd0), .BWEBM(70'd0), .WEBM(1'b1), .AMB(8'd0), .REBM(1'b1),.BIST(1'b0));
	TS6N65LPLLA200X70M2S ram2_4(.CLKW(clk),.CLKR(clk),.AA(write_addr), .AB(spike_addr_counter),.D(data2_new[4]), .BWEB(70'd0), .WEB(we2[4]), .Q(datas2[4]), .REB(read[2]), 
	.AMA(8'd0), .DM(70'd0), .BWEBM(70'd0), .WEBM(1'b1), .AMB(8'd0), .REBM(1'b1),.BIST(1'b0));
	TS6N65LPLLA200X70M2S ram2_5(.CLKW(clk),.CLKR(clk),.AA(write_addr), .AB(spike_addr_counter),.D(data2_new[5]), .BWEB(70'd0), .WEB(we2[5]), .Q(datas2[5]), .REB(read[2]), 
	.AMA(8'd0), .DM(70'd0), .BWEBM(70'd0), .WEBM(1'b1), .AMB(8'd0), .REBM(1'b1),.BIST(1'b0));
	TS6N65LPLLA200X70M2S ram2_6(.CLKW(clk),.CLKR(clk),.AA(write_addr), .AB(spike_addr_counter),.D(data2_new[6]), .BWEB(70'd0), .WEB(we2[6]), .Q(datas2[6]), .REB(read[2]), 
	.AMA(8'd0), .DM(70'd0), .BWEBM(70'd0), .WEBM(1'b1), .AMB(8'd0), .REBM(1'b1),.BIST(1'b0));
	TS6N65LPLLA200X70M2S ram2_7(.CLKW(clk),.CLKR(clk),.AA(write_addr), .AB(spike_addr_counter),.D(data2_new[7]), .BWEB(70'd0), .WEB(we2[7]), .Q(datas2[7]), .REB(read[2]), 
	.AMA(8'd0), .DM(70'd0), .BWEBM(70'd0), .WEBM(1'b1), .AMB(8'd0), .REBM(1'b1),.BIST(1'b0));
	TS6N65LPLLA200X70M2S ram2_8(.CLKW(clk),.CLKR(clk),.AA(write_addr), .AB(spike_addr_counter),.D(data2_new[8]), .BWEB(70'd0), .WEB(we2[8]), .Q(datas2[8]), .REB(read[2]), 
	.AMA(8'd0), .DM(70'd0), .BWEBM(70'd0), .WEBM(1'b1), .AMB(8'd0), .REBM(1'b1),.BIST(1'b0));
	TS6N65LPLLA200X70M2S ram2_9(.CLKW(clk),.CLKR(clk),.AA(write_addr), .AB(spike_addr_counter),.D(data2_new[9]), .BWEB(70'd0), .WEB(we2[9]), .Q(datas2[9]), .REB(read[2]), 
	.AMA(8'd0), .DM(70'd0), .BWEBM(70'd0), .WEBM(1'b1), .AMB(8'd0), .REBM(1'b1),.BIST(1'b0));
	TS6N65LPLLA200X70M2S ram2_10(.CLKW(clk),.CLKR(clk),.AA(write_addr), .AB(spike_addr_counter),.D(data2_new[10]), .BWEB(70'd0), .WEB(we2[10]), .Q(datas2[10]), .REB(read[2]), 
	.AMA(8'd0), .DM(70'd0), .BWEBM(70'd0), .WEBM(1'b1), .AMB(8'd0), .REBM(1'b1),.BIST(1'b0));
	TS6N65LPLLA200X70M2S ram2_11(.CLKW(clk),.CLKR(clk),.AA(write_addr), .AB(spike_addr_counter),.D(data2_new[11]), .BWEB(70'd0), .WEB(we2[11]), .Q(datas2[11]), .REB(read[2]), 
	.AMA(8'd0), .DM(70'd0), .BWEBM(70'd0), .WEBM(1'b1), .AMB(8'd0), .REBM(1'b1),.BIST(1'b0));
	TS6N65LPLLA200X70M2S ram2_12(.CLKW(clk),.CLKR(clk),.AA(write_addr), .AB(spike_addr_counter),.D(data2_new[12]), .BWEB(70'd0), .WEB(we2[12]), .Q(datas2[12]), .REB(read[2]), 
	.AMA(8'd0), .DM(70'd0), .BWEBM(70'd0), .WEBM(1'b1), .AMB(8'd0), .REBM(1'b1),.BIST(1'b0));
	TS6N65LPLLA200X70M2S ram2_13(.CLKW(clk),.CLKR(clk),.AA(write_addr), .AB(spike_addr_counter),.D(data2_new[13]), .BWEB(70'd0), .WEB(we2[13]), .Q(datas2[13]), .REB(read[2]), 
	.AMA(8'd0), .DM(70'd0), .BWEBM(70'd0), .WEBM(1'b1), .AMB(8'd0), .REBM(1'b1),.BIST(1'b0));
	TS6N65LPLLA200X70M2S ram2_14(.CLKW(clk),.CLKR(clk),.AA(write_addr), .AB(spike_addr_counter),.D(data2_new[14]), .BWEB(70'd0), .WEB(we2[14]), .Q(datas2[14]), .REB(read[2]), 
	.AMA(8'd0), .DM(70'd0), .BWEBM(70'd0), .WEBM(1'b1), .AMB(8'd0), .REBM(1'b1),.BIST(1'b0));
	TS6N65LPLLA200X70M2S ram2_15(.CLKW(clk),.CLKR(clk),.AA(write_addr), .AB(spike_addr_counter),.D(data2_new[15]), .BWEB(70'd0), .WEB(we2[15]), .Q(datas2[15]), .REB(read[2]), 
	.AMA(8'd0), .DM(70'd0), .BWEBM(70'd0), .WEBM(1'b1), .AMB(8'd0), .REBM(1'b1),.BIST(1'b0));
	TS6N65LPLLA200X70M2S ram2_16(.CLKW(clk),.CLKR(clk),.AA(write_addr), .AB(spike_addr_counter),.D(data2_new[16]), .BWEB(70'd0), .WEB(we2[16]), .Q(datas2[16]), .REB(read[2]), 
	.AMA(8'd0), .DM(70'd0), .BWEBM(70'd0), .WEBM(1'b1), .AMB(8'd0), .REBM(1'b1),.BIST(1'b0));
	TS6N65LPLLA200X70M2S ram2_17(.CLKW(clk),.CLKR(clk),.AA(write_addr), .AB(spike_addr_counter),.D(data2_new[17]), .BWEB(70'd0), .WEB(we2[17]), .Q(datas2[17]), .REB(read[2]), 
	.AMA(8'd0), .DM(70'd0), .BWEBM(70'd0), .WEBM(1'b1), .AMB(8'd0), .REBM(1'b1),.BIST(1'b0));
	TS6N65LPLLA200X70M2S ram2_18(.CLKW(clk),.CLKR(clk),.AA(write_addr), .AB(spike_addr_counter),.D(data2_new[18]), .BWEB(70'd0), .WEB(we2[18]), .Q(datas2[18]), .REB(read[2]), 
	.AMA(8'd0), .DM(70'd0), .BWEBM(70'd0), .WEBM(1'b1), .AMB(8'd0), .REBM(1'b1),.BIST(1'b0));
	TS6N65LPLLA200X70M2S ram2_19(.CLKW(clk),.CLKR(clk),.AA(write_addr), .AB(spike_addr_counter),.D(data2_new[19]), .BWEB(70'd0), .WEB(we2[19]), .Q(datas2[19]), .REB(read[2]), 
	.AMA(8'd0), .DM(70'd0), .BWEBM(70'd0), .WEBM(1'b1), .AMB(8'd0), .REBM(1'b1),.BIST(1'b0));
	TS6N65LPLLA200X70M2S ram2_20(.CLKW(clk),.CLKR(clk),.AA(write_addr), .AB(spike_addr_counter),.D(data2_new[20]), .BWEB(70'd0), .WEB(we2[20]), .Q(datas2[20]), .REB(read[2]), 
	.AMA(8'd0), .DM(70'd0), .BWEBM(70'd0), .WEBM(1'b1), .AMB(8'd0), .REBM(1'b1),.BIST(1'b0));
	TS6N65LPLLA200X70M2S ram2_21(.CLKW(clk),.CLKR(clk),.AA(write_addr), .AB(spike_addr_counter),.D(data2_new[21]), .BWEB(70'd0), .WEB(we2[21]), .Q(datas2[21]), .REB(read[2]), 
	.AMA(8'd0), .DM(70'd0), .BWEBM(70'd0), .WEBM(1'b1), .AMB(8'd0), .REBM(1'b1),.BIST(1'b0));
	TS6N65LPLLA200X70M2S ram2_22(.CLKW(clk),.CLKR(clk),.AA(write_addr), .AB(spike_addr_counter),.D(data2_new[22]), .BWEB(70'd0), .WEB(we2[22]), .Q(datas2[22]), .REB(read[2]), 
	.AMA(8'd0), .DM(70'd0), .BWEBM(70'd0), .WEBM(1'b1), .AMB(8'd0), .REBM(1'b1),.BIST(1'b0));
	TS6N65LPLLA200X70M2S ram2_23(.CLKW(clk),.CLKR(clk),.AA(write_addr), .AB(spike_addr_counter),.D(data2_new[23]), .BWEB(70'd0), .WEB(we2[23]), .Q(datas2[23]), .REB(read[2]), 
	.AMA(8'd0), .DM(70'd0), .BWEBM(70'd0), .WEBM(1'b1), .AMB(8'd0), .REBM(1'b1),.BIST(1'b0));
	TS6N65LPLLA200X70M2S ram2_24(.CLKW(clk),.CLKR(clk),.AA(write_addr), .AB(spike_addr_counter),.D(data2_new[24]), .BWEB(70'd0), .WEB(we2[24]), .Q(datas2[24]), .REB(read[2]), 
	.AMA(8'd0), .DM(70'd0), .BWEBM(70'd0), .WEBM(1'b1), .AMB(8'd0), .REBM(1'b1),.BIST(1'b0));
	TS6N65LPLLA200X70M2S ram2_25(.CLKW(clk),.CLKR(clk),.AA(write_addr), .AB(spike_addr_counter),.D(data2_new[25]), .BWEB(70'd0), .WEB(we2[25]), .Q(datas2[25]), .REB(read[2]), 
	.AMA(8'd0), .DM(70'd0), .BWEBM(70'd0), .WEBM(1'b1), .AMB(8'd0), .REBM(1'b1),.BIST(1'b0));
	TS6N65LPLLA200X70M2S ram2_26(.CLKW(clk),.CLKR(clk),.AA(write_addr), .AB(spike_addr_counter),.D(data2_new[26]), .BWEB(70'd0), .WEB(we2[26]), .Q(datas2[26]), .REB(read[2]), 
	.AMA(8'd0), .DM(70'd0), .BWEBM(70'd0), .WEBM(1'b1), .AMB(8'd0), .REBM(1'b1),.BIST(1'b0));
	TS6N65LPLLA200X70M2S ram2_27(.CLKW(clk),.CLKR(clk),.AA(write_addr), .AB(spike_addr_counter),.D(data2_new[27]), .BWEB(70'd0), .WEB(we2[27]), .Q(datas2[27]), .REB(read[2]), 
	.AMA(8'd0), .DM(70'd0), .BWEBM(70'd0), .WEBM(1'b1), .AMB(8'd0), .REBM(1'b1),.BIST(1'b0));
	TS6N65LPLLA200X70M2S ram2_28(.CLKW(clk),.CLKR(clk),.AA(write_addr), .AB(spike_addr_counter),.D(data2_new[28]), .BWEB(70'd0), .WEB(we2[28]), .Q(datas2[28]), .REB(read[2]), 
	.AMA(8'd0), .DM(70'd0), .BWEBM(70'd0), .WEBM(1'b1), .AMB(8'd0), .REBM(1'b1),.BIST(1'b0));
	TS6N65LPLLA200X70M2S ram2_29(.CLKW(clk),.CLKR(clk),.AA(write_addr), .AB(spike_addr_counter),.D(data2_new[29]), .BWEB(70'd0), .WEB(we2[29]), .Q(datas2[29]), .REB(read[2]), 
	.AMA(8'd0), .DM(70'd0), .BWEBM(70'd0), .WEBM(1'b1), .AMB(8'd0), .REBM(1'b1),.BIST(1'b0));
	TS6N65LPLLA200X70M2S ram2_30(.CLKW(clk),.CLKR(clk),.AA(write_addr), .AB(spike_addr_counter),.D(data2_new[30]), .BWEB(70'd0), .WEB(we2[30]), .Q(datas2[30]), .REB(read[2]), 
	.AMA(8'd0), .DM(70'd0), .BWEBM(70'd0), .WEBM(1'b1), .AMB(8'd0), .REBM(1'b1),.BIST(1'b0));
	TS6N65LPLLA200X70M2S ram2_31(.CLKW(clk),.CLKR(clk),.AA(write_addr), .AB(spike_addr_counter),.D(data2_new[31]), .BWEB(70'd0), .WEB(we2[31]), .Q(datas2[31]), .REB(read[2]), 
	.AMA(8'd0), .DM(70'd0), .BWEBM(70'd0), .WEBM(1'b1), .AMB(8'd0), .REBM(1'b1),.BIST(1'b0));
	TS6N65LPLLA200X70M2S ram2_32(.CLKW(clk),.CLKR(clk),.AA(write_addr), .AB(spike_addr_counter),.D(data2_new[32]), .BWEB(70'd0), .WEB(we2[32]), .Q(datas2[32]), .REB(read[2]), 
	.AMA(8'd0), .DM(70'd0), .BWEBM(70'd0), .WEBM(1'b1), .AMB(8'd0), .REBM(1'b1),.BIST(1'b0));
	TS6N65LPLLA200X70M2S ram2_33(.CLKW(clk),.CLKR(clk),.AA(write_addr), .AB(spike_addr_counter),.D(data2_new[33]), .BWEB(70'd0), .WEB(we2[33]), .Q(datas2[33]), .REB(read[2]), 
	.AMA(8'd0), .DM(70'd0), .BWEBM(70'd0), .WEBM(1'b1), .AMB(8'd0), .REBM(1'b1),.BIST(1'b0));
	TS6N65LPLLA200X70M2S ram2_34(.CLKW(clk),.CLKR(clk),.AA(write_addr), .AB(spike_addr_counter),.D(data2_new[34]), .BWEB(70'd0), .WEB(we2[34]), .Q(datas2[34]), .REB(read[2]), 
	.AMA(8'd0), .DM(70'd0), .BWEBM(70'd0), .WEBM(1'b1), .AMB(8'd0), .REBM(1'b1),.BIST(1'b0));
	TS6N65LPLLA200X70M2S ram2_35(.CLKW(clk),.CLKR(clk),.AA(write_addr), .AB(spike_addr_counter),.D(data2_new[35]), .BWEB(70'd0), .WEB(we2[35]), .Q(datas2[35]), .REB(read[2]), 
	.AMA(8'd0), .DM(70'd0), .BWEBM(70'd0), .WEBM(1'b1), .AMB(8'd0), .REBM(1'b1),.BIST(1'b0));
	TS6N65LPLLA200X70M2S ram2_36(.CLKW(clk),.CLKR(clk),.AA(write_addr), .AB(spike_addr_counter),.D(data2_new[36]), .BWEB(70'd0), .WEB(we2[36]), .Q(datas2[36]), .REB(read[2]), 
	.AMA(8'd0), .DM(70'd0), .BWEBM(70'd0), .WEBM(1'b1), .AMB(8'd0), .REBM(1'b1),.BIST(1'b0));
	TS6N65LPLLA200X70M2S ram2_37(.CLKW(clk),.CLKR(clk),.AA(write_addr), .AB(spike_addr_counter),.D(data2_new[37]), .BWEB(70'd0), .WEB(we2[37]), .Q(datas2[37]), .REB(read[2]), 
	.AMA(8'd0), .DM(70'd0), .BWEBM(70'd0), .WEBM(1'b1), .AMB(8'd0), .REBM(1'b1),.BIST(1'b0));
	TS6N65LPLLA200X70M2S ram2_38(.CLKW(clk),.CLKR(clk),.AA(write_addr), .AB(spike_addr_counter),.D(data2_new[38]), .BWEB(70'd0), .WEB(we2[38]), .Q(datas2[38]), .REB(read[2]), 
	.AMA(8'd0), .DM(70'd0), .BWEBM(70'd0), .WEBM(1'b1), .AMB(8'd0), .REBM(1'b1),.BIST(1'b0));
	TS6N65LPLLA200X70M2S ram2_39(.CLKW(clk),.CLKR(clk),.AA(write_addr), .AB(spike_addr_counter),.D(data2_new[39]), .BWEB(70'd0), .WEB(we2[39]), .Q(datas2[39]), .REB(read[2]), 
	.AMA(8'd0), .DM(70'd0), .BWEBM(70'd0), .WEBM(1'b1), .AMB(8'd0), .REBM(1'b1),.BIST(1'b0));

	TS6N65LPLLA200X70M2S ram3_0(.CLKW(clk),.CLKR(clk),.AA(write_addr), .AB(spike_addr_counter),.D(data3_new[0]), .BWEB(70'd0), .WEB(we3[0]), .Q(datas3[0]), .REB(read[3]), 
	.AMA(8'd0), .DM(70'd0), .BWEBM(70'd0), .WEBM(1'b1), .AMB(8'd0), .REBM(1'b1),.BIST(1'b0));
	TS6N65LPLLA200X70M2S ram3_1(.CLKW(clk),.CLKR(clk),.AA(write_addr), .AB(spike_addr_counter),.D(data3_new[1]), .BWEB(70'd0), .WEB(we3[1]), .Q(datas3[1]), .REB(read[3]), 
	.AMA(8'd0), .DM(70'd0), .BWEBM(70'd0), .WEBM(1'b1), .AMB(8'd0), .REBM(1'b1),.BIST(1'b0));
	TS6N65LPLLA200X70M2S ram3_2(.CLKW(clk),.CLKR(clk),.AA(write_addr), .AB(spike_addr_counter),.D(data3_new[2]), .BWEB(70'd0), .WEB(we3[2]), .Q(datas3[2]), .REB(read[3]), 
	.AMA(8'd0), .DM(70'd0), .BWEBM(70'd0), .WEBM(1'b1), .AMB(8'd0), .REBM(1'b1),.BIST(1'b0));
	TS6N65LPLLA200X70M2S ram3_3(.CLKW(clk),.CLKR(clk),.AA(write_addr), .AB(spike_addr_counter),.D(data3_new[3]), .BWEB(70'd0), .WEB(we3[3]), .Q(datas3[3]), .REB(read[3]), 
	.AMA(8'd0), .DM(70'd0), .BWEBM(70'd0), .WEBM(1'b1), .AMB(8'd0), .REBM(1'b1),.BIST(1'b0));
	TS6N65LPLLA200X70M2S ram3_4(.CLKW(clk),.CLKR(clk),.AA(write_addr), .AB(spike_addr_counter),.D(data3_new[4]), .BWEB(70'd0), .WEB(we3[4]), .Q(datas3[4]), .REB(read[3]), 
	.AMA(8'd0), .DM(70'd0), .BWEBM(70'd0), .WEBM(1'b1), .AMB(8'd0), .REBM(1'b1),.BIST(1'b0));
	TS6N65LPLLA200X70M2S ram3_5(.CLKW(clk),.CLKR(clk),.AA(write_addr), .AB(spike_addr_counter),.D(data3_new[5]), .BWEB(70'd0), .WEB(we3[5]), .Q(datas3[5]), .REB(read[3]), 
	.AMA(8'd0), .DM(70'd0), .BWEBM(70'd0), .WEBM(1'b1), .AMB(8'd0), .REBM(1'b1),.BIST(1'b0));
	TS6N65LPLLA200X70M2S ram3_6(.CLKW(clk),.CLKR(clk),.AA(write_addr), .AB(spike_addr_counter),.D(data3_new[6]), .BWEB(70'd0), .WEB(we3[6]), .Q(datas3[6]), .REB(read[3]), 
	.AMA(8'd0), .DM(70'd0), .BWEBM(70'd0), .WEBM(1'b1), .AMB(8'd0), .REBM(1'b1),.BIST(1'b0));
	TS6N65LPLLA200X70M2S ram3_7(.CLKW(clk),.CLKR(clk),.AA(write_addr), .AB(spike_addr_counter),.D(data3_new[7]), .BWEB(70'd0), .WEB(we3[7]), .Q(datas3[7]), .REB(read[3]), 
	.AMA(8'd0), .DM(70'd0), .BWEBM(70'd0), .WEBM(1'b1), .AMB(8'd0), .REBM(1'b1),.BIST(1'b0));
	TS6N65LPLLA200X70M2S ram3_8(.CLKW(clk),.CLKR(clk),.AA(write_addr), .AB(spike_addr_counter),.D(data3_new[8]), .BWEB(70'd0), .WEB(we3[8]), .Q(datas3[8]), .REB(read[3]), 
	.AMA(8'd0), .DM(70'd0), .BWEBM(70'd0), .WEBM(1'b1), .AMB(8'd0), .REBM(1'b1),.BIST(1'b0));
	TS6N65LPLLA200X70M2S ram3_9(.CLKW(clk),.CLKR(clk),.AA(write_addr), .AB(spike_addr_counter),.D(data3_new[9]), .BWEB(70'd0), .WEB(we3[9]), .Q(datas3[9]), .REB(read[3]), 
	.AMA(8'd0), .DM(70'd0), .BWEBM(70'd0), .WEBM(1'b1), .AMB(8'd0), .REBM(1'b1),.BIST(1'b0));
	TS6N65LPLLA200X70M2S ram3_10(.CLKW(clk),.CLKR(clk),.AA(write_addr), .AB(spike_addr_counter),.D(data3_new[10]), .BWEB(70'd0), .WEB(we3[10]), .Q(datas3[10]), .REB(read[3]), 
	.AMA(8'd0), .DM(70'd0), .BWEBM(70'd0), .WEBM(1'b1), .AMB(8'd0), .REBM(1'b1),.BIST(1'b0));
	TS6N65LPLLA200X70M2S ram3_11(.CLKW(clk),.CLKR(clk),.AA(write_addr), .AB(spike_addr_counter),.D(data3_new[11]), .BWEB(70'd0), .WEB(we3[11]), .Q(datas3[11]), .REB(read[3]), 
	.AMA(8'd0), .DM(70'd0), .BWEBM(70'd0), .WEBM(1'b1), .AMB(8'd0), .REBM(1'b1),.BIST(1'b0));
	TS6N65LPLLA200X70M2S ram3_12(.CLKW(clk),.CLKR(clk),.AA(write_addr), .AB(spike_addr_counter),.D(data3_new[12]), .BWEB(70'd0), .WEB(we3[12]), .Q(datas3[12]), .REB(read[3]), 
	.AMA(8'd0), .DM(70'd0), .BWEBM(70'd0), .WEBM(1'b1), .AMB(8'd0), .REBM(1'b1),.BIST(1'b0));
	TS6N65LPLLA200X70M2S ram3_13(.CLKW(clk),.CLKR(clk),.AA(write_addr), .AB(spike_addr_counter),.D(data3_new[13]), .BWEB(70'd0), .WEB(we3[13]), .Q(datas3[13]), .REB(read[3]), 
	.AMA(8'd0), .DM(70'd0), .BWEBM(70'd0), .WEBM(1'b1), .AMB(8'd0), .REBM(1'b1),.BIST(1'b0));
	TS6N65LPLLA200X70M2S ram3_14(.CLKW(clk),.CLKR(clk),.AA(write_addr), .AB(spike_addr_counter),.D(data3_new[14]), .BWEB(70'd0), .WEB(we3[14]), .Q(datas3[14]), .REB(read[3]), 
	.AMA(8'd0), .DM(70'd0), .BWEBM(70'd0), .WEBM(1'b1), .AMB(8'd0), .REBM(1'b1),.BIST(1'b0));
	TS6N65LPLLA200X70M2S ram3_15(.CLKW(clk),.CLKR(clk),.AA(write_addr), .AB(spike_addr_counter),.D(data3_new[15]), .BWEB(70'd0), .WEB(we3[15]), .Q(datas3[15]), .REB(read[3]), 
	.AMA(8'd0), .DM(70'd0), .BWEBM(70'd0), .WEBM(1'b1), .AMB(8'd0), .REBM(1'b1),.BIST(1'b0));
	TS6N65LPLLA200X70M2S ram3_16(.CLKW(clk),.CLKR(clk),.AA(write_addr), .AB(spike_addr_counter),.D(data3_new[16]), .BWEB(70'd0), .WEB(we3[16]), .Q(datas3[16]), .REB(read[3]), 
	.AMA(8'd0), .DM(70'd0), .BWEBM(70'd0), .WEBM(1'b1), .AMB(8'd0), .REBM(1'b1),.BIST(1'b0));
	TS6N65LPLLA200X70M2S ram3_17(.CLKW(clk),.CLKR(clk),.AA(write_addr), .AB(spike_addr_counter),.D(data3_new[17]), .BWEB(70'd0), .WEB(we3[17]), .Q(datas3[17]), .REB(read[3]), 
	.AMA(8'd0), .DM(70'd0), .BWEBM(70'd0), .WEBM(1'b1), .AMB(8'd0), .REBM(1'b1),.BIST(1'b0));
	TS6N65LPLLA200X70M2S ram3_18(.CLKW(clk),.CLKR(clk),.AA(write_addr), .AB(spike_addr_counter),.D(data3_new[18]), .BWEB(70'd0), .WEB(we3[18]), .Q(datas3[18]), .REB(read[3]), 
	.AMA(8'd0), .DM(70'd0), .BWEBM(70'd0), .WEBM(1'b1), .AMB(8'd0), .REBM(1'b1),.BIST(1'b0));
	TS6N65LPLLA200X70M2S ram3_19(.CLKW(clk),.CLKR(clk),.AA(write_addr), .AB(spike_addr_counter),.D(data3_new[19]), .BWEB(70'd0), .WEB(we3[19]), .Q(datas3[19]), .REB(read[3]), 
	.AMA(8'd0), .DM(70'd0), .BWEBM(70'd0), .WEBM(1'b1), .AMB(8'd0), .REBM(1'b1),.BIST(1'b0));
	TS6N65LPLLA200X70M2S ram3_20(.CLKW(clk),.CLKR(clk),.AA(write_addr), .AB(spike_addr_counter),.D(data3_new[20]), .BWEB(70'd0), .WEB(we3[20]), .Q(datas3[20]), .REB(read[3]), 
	.AMA(8'd0), .DM(70'd0), .BWEBM(70'd0), .WEBM(1'b1), .AMB(8'd0), .REBM(1'b1),.BIST(1'b0));
	TS6N65LPLLA200X70M2S ram3_21(.CLKW(clk),.CLKR(clk),.AA(write_addr), .AB(spike_addr_counter),.D(data3_new[21]), .BWEB(70'd0), .WEB(we3[21]), .Q(datas3[21]), .REB(read[3]), 
	.AMA(8'd0), .DM(70'd0), .BWEBM(70'd0), .WEBM(1'b1), .AMB(8'd0), .REBM(1'b1),.BIST(1'b0));
	TS6N65LPLLA200X70M2S ram3_22(.CLKW(clk),.CLKR(clk),.AA(write_addr), .AB(spike_addr_counter),.D(data3_new[22]), .BWEB(70'd0), .WEB(we3[22]), .Q(datas3[22]), .REB(read[3]), 
	.AMA(8'd0), .DM(70'd0), .BWEBM(70'd0), .WEBM(1'b1), .AMB(8'd0), .REBM(1'b1),.BIST(1'b0));
	TS6N65LPLLA200X70M2S ram3_23(.CLKW(clk),.CLKR(clk),.AA(write_addr), .AB(spike_addr_counter),.D(data3_new[23]), .BWEB(70'd0), .WEB(we3[23]), .Q(datas3[23]), .REB(read[3]), 
	.AMA(8'd0), .DM(70'd0), .BWEBM(70'd0), .WEBM(1'b1), .AMB(8'd0), .REBM(1'b1),.BIST(1'b0));
	TS6N65LPLLA200X70M2S ram3_24(.CLKW(clk),.CLKR(clk),.AA(write_addr), .AB(spike_addr_counter),.D(data3_new[24]), .BWEB(70'd0), .WEB(we3[24]), .Q(datas3[24]), .REB(read[3]), 
	.AMA(8'd0), .DM(70'd0), .BWEBM(70'd0), .WEBM(1'b1), .AMB(8'd0), .REBM(1'b1),.BIST(1'b0));
	TS6N65LPLLA200X70M2S ram3_25(.CLKW(clk),.CLKR(clk),.AA(write_addr), .AB(spike_addr_counter),.D(data3_new[25]), .BWEB(70'd0), .WEB(we3[25]), .Q(datas3[25]), .REB(read[3]), 
	.AMA(8'd0), .DM(70'd0), .BWEBM(70'd0), .WEBM(1'b1), .AMB(8'd0), .REBM(1'b1),.BIST(1'b0));
	TS6N65LPLLA200X70M2S ram3_26(.CLKW(clk),.CLKR(clk),.AA(write_addr), .AB(spike_addr_counter),.D(data3_new[26]), .BWEB(70'd0), .WEB(we3[26]), .Q(datas3[26]), .REB(read[3]), 
	.AMA(8'd0), .DM(70'd0), .BWEBM(70'd0), .WEBM(1'b1), .AMB(8'd0), .REBM(1'b1),.BIST(1'b0));
	TS6N65LPLLA200X70M2S ram3_27(.CLKW(clk),.CLKR(clk),.AA(write_addr), .AB(spike_addr_counter),.D(data3_new[27]), .BWEB(70'd0), .WEB(we3[27]), .Q(datas3[27]), .REB(read[3]), 
	.AMA(8'd0), .DM(70'd0), .BWEBM(70'd0), .WEBM(1'b1), .AMB(8'd0), .REBM(1'b1),.BIST(1'b0));
	TS6N65LPLLA200X70M2S ram3_28(.CLKW(clk),.CLKR(clk),.AA(write_addr), .AB(spike_addr_counter),.D(data3_new[28]), .BWEB(70'd0), .WEB(we3[28]), .Q(datas3[28]), .REB(read[3]), 
	.AMA(8'd0), .DM(70'd0), .BWEBM(70'd0), .WEBM(1'b1), .AMB(8'd0), .REBM(1'b1),.BIST(1'b0));
	TS6N65LPLLA200X70M2S ram3_29(.CLKW(clk),.CLKR(clk),.AA(write_addr), .AB(spike_addr_counter),.D(data3_new[29]), .BWEB(70'd0), .WEB(we3[29]), .Q(datas3[29]), .REB(read[3]), 
	.AMA(8'd0), .DM(70'd0), .BWEBM(70'd0), .WEBM(1'b1), .AMB(8'd0), .REBM(1'b1),.BIST(1'b0));
	TS6N65LPLLA200X70M2S ram3_30(.CLKW(clk),.CLKR(clk),.AA(write_addr), .AB(spike_addr_counter),.D(data3_new[30]), .BWEB(70'd0), .WEB(we3[30]), .Q(datas3[30]), .REB(read[3]), 
	.AMA(8'd0), .DM(70'd0), .BWEBM(70'd0), .WEBM(1'b1), .AMB(8'd0), .REBM(1'b1),.BIST(1'b0));
	TS6N65LPLLA200X70M2S ram3_31(.CLKW(clk),.CLKR(clk),.AA(write_addr), .AB(spike_addr_counter),.D(data3_new[31]), .BWEB(70'd0), .WEB(we3[31]), .Q(datas3[31]), .REB(read[3]), 
	.AMA(8'd0), .DM(70'd0), .BWEBM(70'd0), .WEBM(1'b1), .AMB(8'd0), .REBM(1'b1),.BIST(1'b0));
	TS6N65LPLLA200X70M2S ram3_32(.CLKW(clk),.CLKR(clk),.AA(write_addr), .AB(spike_addr_counter),.D(data3_new[32]), .BWEB(70'd0), .WEB(we3[32]), .Q(datas3[32]), .REB(read[3]), 
	.AMA(8'd0), .DM(70'd0), .BWEBM(70'd0), .WEBM(1'b1), .AMB(8'd0), .REBM(1'b1),.BIST(1'b0));
	TS6N65LPLLA200X70M2S ram3_33(.CLKW(clk),.CLKR(clk),.AA(write_addr), .AB(spike_addr_counter),.D(data3_new[33]), .BWEB(70'd0), .WEB(we3[33]), .Q(datas3[33]), .REB(read[3]), 
	.AMA(8'd0), .DM(70'd0), .BWEBM(70'd0), .WEBM(1'b1), .AMB(8'd0), .REBM(1'b1),.BIST(1'b0));
	TS6N65LPLLA200X70M2S ram3_34(.CLKW(clk),.CLKR(clk),.AA(write_addr), .AB(spike_addr_counter),.D(data3_new[34]), .BWEB(70'd0), .WEB(we3[34]), .Q(datas3[34]), .REB(read[3]), 
	.AMA(8'd0), .DM(70'd0), .BWEBM(70'd0), .WEBM(1'b1), .AMB(8'd0), .REBM(1'b1),.BIST(1'b0));
	TS6N65LPLLA200X70M2S ram3_35(.CLKW(clk),.CLKR(clk),.AA(write_addr), .AB(spike_addr_counter),.D(data3_new[35]), .BWEB(70'd0), .WEB(we3[35]), .Q(datas3[35]), .REB(read[3]), 
	.AMA(8'd0), .DM(70'd0), .BWEBM(70'd0), .WEBM(1'b1), .AMB(8'd0), .REBM(1'b1),.BIST(1'b0));
	TS6N65LPLLA200X70M2S ram3_36(.CLKW(clk),.CLKR(clk),.AA(write_addr), .AB(spike_addr_counter),.D(data3_new[36]), .BWEB(70'd0), .WEB(we3[36]), .Q(datas3[36]), .REB(read[3]), 
	.AMA(8'd0), .DM(70'd0), .BWEBM(70'd0), .WEBM(1'b1), .AMB(8'd0), .REBM(1'b1),.BIST(1'b0));
	TS6N65LPLLA200X70M2S ram3_37(.CLKW(clk),.CLKR(clk),.AA(write_addr), .AB(spike_addr_counter),.D(data3_new[37]), .BWEB(70'd0), .WEB(we3[37]), .Q(datas3[37]), .REB(read[3]), 
	.AMA(8'd0), .DM(70'd0), .BWEBM(70'd0), .WEBM(1'b1), .AMB(8'd0), .REBM(1'b1),.BIST(1'b0));
	TS6N65LPLLA200X70M2S ram3_38(.CLKW(clk),.CLKR(clk),.AA(write_addr), .AB(spike_addr_counter),.D(data3_new[38]), .BWEB(70'd0), .WEB(we3[38]), .Q(datas3[38]), .REB(read[3]), 
	.AMA(8'd0), .DM(70'd0), .BWEBM(70'd0), .WEBM(1'b1), .AMB(8'd0), .REBM(1'b1),.BIST(1'b0));
	TS6N65LPLLA200X70M2S ram3_39(.CLKW(clk),.CLKR(clk),.AA(write_addr), .AB(spike_addr_counter),.D(data3_new[39]), .BWEB(70'd0), .WEB(we3[39]), .Q(datas3[39]), .REB(read[3]), 
	.AMA(8'd0), .DM(70'd0), .BWEBM(70'd0), .WEBM(1'b1), .AMB(8'd0), .REBM(1'b1),.BIST(1'b0));


    
	stonet_hidden_neuron1_0 hn0 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_a[0]), .weight1(weight1_a[0]), 
.weight2(weight2_a[0]), .weight3(weight3_a[0]) ,.spike(spikes[0]),.fp(fp[0]),.err(err[0]),.true(true[0]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_1 hn1 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_b[0]), .weight1(weight1_b[0]), 
.weight2(weight2_b[0]), .weight3(weight3_b[0]) ,.spike(spikes[1]),.fp(fp[1]),.err(err[1]),.true(true[1]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_2 hn2 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_c[0]), .weight1(weight1_c[0]), 
.weight2(weight2_c[0]), .weight3(weight3_c[0]) ,.spike(spikes[2]),.fp(fp[2]),.err(err[2]),.true(true[2]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_3 hn3 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_d[0]), .weight1(weight1_d[0]), 
.weight2(weight2_d[0]), .weight3(weight3_d[0]) ,.spike(spikes[3]),.fp(fp[3]),.err(err[3]),.true(true[3]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_4 hn4 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_e[0]), .weight1(weight1_e[0]), 
.weight2(weight2_e[0]), .weight3(weight3_e[0]) ,.spike(spikes[4]),.fp(fp[4]),.err(err[4]),.true(true[4]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_5 hn5 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_a[1]), .weight1(weight1_a[1]), 
.weight2(weight2_a[1]), .weight3(weight3_a[1]) ,.spike(spikes[5]),.fp(fp[5]),.err(err[5]),.true(true[5]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_6 hn6 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_b[1]), .weight1(weight1_b[1]), 
.weight2(weight2_b[1]), .weight3(weight3_b[1]) ,.spike(spikes[6]),.fp(fp[6]),.err(err[6]),.true(true[6]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_7 hn7 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_c[1]), .weight1(weight1_c[1]), 
.weight2(weight2_c[1]), .weight3(weight3_c[1]) ,.spike(spikes[7]),.fp(fp[7]),.err(err[7]),.true(true[7]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_8 hn8 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_d[1]), .weight1(weight1_d[1]), 
.weight2(weight2_d[1]), .weight3(weight3_d[1]) ,.spike(spikes[8]),.fp(fp[8]),.err(err[8]),.true(true[8]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_9 hn9 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_e[1]), .weight1(weight1_e[1]), 
.weight2(weight2_e[1]), .weight3(weight3_e[1]) ,.spike(spikes[9]),.fp(fp[9]),.err(err[9]),.true(true[9]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_10 hn10 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_a[2]), .weight1(weight1_a[2]), 
.weight2(weight2_a[2]), .weight3(weight3_a[2]) ,.spike(spikes[10]),.fp(fp[10]),.err(err[10]),.true(true[10]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_11 hn11 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_b[2]), .weight1(weight1_b[2]), 
.weight2(weight2_b[2]), .weight3(weight3_b[2]) ,.spike(spikes[11]),.fp(fp[11]),.err(err[11]),.true(true[11]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_12 hn12 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_c[2]), .weight1(weight1_c[2]), 
.weight2(weight2_c[2]), .weight3(weight3_c[2]) ,.spike(spikes[12]),.fp(fp[12]),.err(err[12]),.true(true[12]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_13 hn13 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_d[2]), .weight1(weight1_d[2]), 
.weight2(weight2_d[2]), .weight3(weight3_d[2]) ,.spike(spikes[13]),.fp(fp[13]),.err(err[13]),.true(true[13]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_14 hn14 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_e[2]), .weight1(weight1_e[2]), 
.weight2(weight2_e[2]), .weight3(weight3_e[2]) ,.spike(spikes[14]),.fp(fp[14]),.err(err[14]),.true(true[14]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_15 hn15 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_a[3]), .weight1(weight1_a[3]), 
.weight2(weight2_a[3]), .weight3(weight3_a[3]) ,.spike(spikes[15]),.fp(fp[15]),.err(err[15]),.true(true[15]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_16 hn16 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_b[3]), .weight1(weight1_b[3]), 
.weight2(weight2_b[3]), .weight3(weight3_b[3]) ,.spike(spikes[16]),.fp(fp[16]),.err(err[16]),.true(true[16]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_17 hn17 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_c[3]), .weight1(weight1_c[3]), 
.weight2(weight2_c[3]), .weight3(weight3_c[3]) ,.spike(spikes[17]),.fp(fp[17]),.err(err[17]),.true(true[17]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_18 hn18 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_d[3]), .weight1(weight1_d[3]), 
.weight2(weight2_d[3]), .weight3(weight3_d[3]) ,.spike(spikes[18]),.fp(fp[18]),.err(err[18]),.true(true[18]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_19 hn19 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_e[3]), .weight1(weight1_e[3]), 
.weight2(weight2_e[3]), .weight3(weight3_e[3]) ,.spike(spikes[19]),.fp(fp[19]),.err(err[19]),.true(true[19]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_20 hn20 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_a[4]), .weight1(weight1_a[4]), 
.weight2(weight2_a[4]), .weight3(weight3_a[4]) ,.spike(spikes[20]),.fp(fp[20]),.err(err[20]),.true(true[20]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_21 hn21 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_b[4]), .weight1(weight1_b[4]), 
.weight2(weight2_b[4]), .weight3(weight3_b[4]) ,.spike(spikes[21]),.fp(fp[21]),.err(err[21]),.true(true[21]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_22 hn22 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_c[4]), .weight1(weight1_c[4]), 
.weight2(weight2_c[4]), .weight3(weight3_c[4]) ,.spike(spikes[22]),.fp(fp[22]),.err(err[22]),.true(true[22]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_23 hn23 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_d[4]), .weight1(weight1_d[4]), 
.weight2(weight2_d[4]), .weight3(weight3_d[4]) ,.spike(spikes[23]),.fp(fp[23]),.err(err[23]),.true(true[23]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_24 hn24 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_e[4]), .weight1(weight1_e[4]), 
.weight2(weight2_e[4]), .weight3(weight3_e[4]) ,.spike(spikes[24]),.fp(fp[24]),.err(err[24]),.true(true[24]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_25 hn25 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_a[5]), .weight1(weight1_a[5]), 
.weight2(weight2_a[5]), .weight3(weight3_a[5]) ,.spike(spikes[25]),.fp(fp[25]),.err(err[25]),.true(true[25]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_26 hn26 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_b[5]), .weight1(weight1_b[5]), 
.weight2(weight2_b[5]), .weight3(weight3_b[5]) ,.spike(spikes[26]),.fp(fp[26]),.err(err[26]),.true(true[26]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_27 hn27 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_c[5]), .weight1(weight1_c[5]), 
.weight2(weight2_c[5]), .weight3(weight3_c[5]) ,.spike(spikes[27]),.fp(fp[27]),.err(err[27]),.true(true[27]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_28 hn28 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_d[5]), .weight1(weight1_d[5]), 
.weight2(weight2_d[5]), .weight3(weight3_d[5]) ,.spike(spikes[28]),.fp(fp[28]),.err(err[28]),.true(true[28]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_29 hn29 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_e[5]), .weight1(weight1_e[5]), 
.weight2(weight2_e[5]), .weight3(weight3_e[5]) ,.spike(spikes[29]),.fp(fp[29]),.err(err[29]),.true(true[29]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_30 hn30 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_a[6]), .weight1(weight1_a[6]), 
.weight2(weight2_a[6]), .weight3(weight3_a[6]) ,.spike(spikes[30]),.fp(fp[30]),.err(err[30]),.true(true[30]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_31 hn31 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_b[6]), .weight1(weight1_b[6]), 
.weight2(weight2_b[6]), .weight3(weight3_b[6]) ,.spike(spikes[31]),.fp(fp[31]),.err(err[31]),.true(true[31]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_32 hn32 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_c[6]), .weight1(weight1_c[6]), 
.weight2(weight2_c[6]), .weight3(weight3_c[6]) ,.spike(spikes[32]),.fp(fp[32]),.err(err[32]),.true(true[32]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_33 hn33 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_d[6]), .weight1(weight1_d[6]), 
.weight2(weight2_d[6]), .weight3(weight3_d[6]) ,.spike(spikes[33]),.fp(fp[33]),.err(err[33]),.true(true[33]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_34 hn34 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_e[6]), .weight1(weight1_e[6]), 
.weight2(weight2_e[6]), .weight3(weight3_e[6]) ,.spike(spikes[34]),.fp(fp[34]),.err(err[34]),.true(true[34]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_35 hn35 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_a[7]), .weight1(weight1_a[7]), 
.weight2(weight2_a[7]), .weight3(weight3_a[7]) ,.spike(spikes[35]),.fp(fp[35]),.err(err[35]),.true(true[35]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_36 hn36 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_b[7]), .weight1(weight1_b[7]), 
.weight2(weight2_b[7]), .weight3(weight3_b[7]) ,.spike(spikes[36]),.fp(fp[36]),.err(err[36]),.true(true[36]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_37 hn37 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_c[7]), .weight1(weight1_c[7]), 
.weight2(weight2_c[7]), .weight3(weight3_c[7]) ,.spike(spikes[37]),.fp(fp[37]),.err(err[37]),.true(true[37]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_38 hn38 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_d[7]), .weight1(weight1_d[7]), 
.weight2(weight2_d[7]), .weight3(weight3_d[7]) ,.spike(spikes[38]),.fp(fp[38]),.err(err[38]),.true(true[38]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_39 hn39 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_e[7]), .weight1(weight1_e[7]), 
.weight2(weight2_e[7]), .weight3(weight3_e[7]) ,.spike(spikes[39]),.fp(fp[39]),.err(err[39]),.true(true[39]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_40 hn40 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_a[8]), .weight1(weight1_a[8]), 
.weight2(weight2_a[8]), .weight3(weight3_a[8]) ,.spike(spikes[40]),.fp(fp[40]),.err(err[40]),.true(true[40]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_41 hn41 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_b[8]), .weight1(weight1_b[8]), 
.weight2(weight2_b[8]), .weight3(weight3_b[8]) ,.spike(spikes[41]),.fp(fp[41]),.err(err[41]),.true(true[41]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_42 hn42 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_c[8]), .weight1(weight1_c[8]), 
.weight2(weight2_c[8]), .weight3(weight3_c[8]) ,.spike(spikes[42]),.fp(fp[42]),.err(err[42]),.true(true[42]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_43 hn43 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_d[8]), .weight1(weight1_d[8]), 
.weight2(weight2_d[8]), .weight3(weight3_d[8]) ,.spike(spikes[43]),.fp(fp[43]),.err(err[43]),.true(true[43]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_44 hn44 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_e[8]), .weight1(weight1_e[8]), 
.weight2(weight2_e[8]), .weight3(weight3_e[8]) ,.spike(spikes[44]),.fp(fp[44]),.err(err[44]),.true(true[44]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_45 hn45 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_a[9]), .weight1(weight1_a[9]), 
.weight2(weight2_a[9]), .weight3(weight3_a[9]) ,.spike(spikes[45]),.fp(fp[45]),.err(err[45]),.true(true[45]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_46 hn46 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_b[9]), .weight1(weight1_b[9]), 
.weight2(weight2_b[9]), .weight3(weight3_b[9]) ,.spike(spikes[46]),.fp(fp[46]),.err(err[46]),.true(true[46]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_47 hn47 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_c[9]), .weight1(weight1_c[9]), 
.weight2(weight2_c[9]), .weight3(weight3_c[9]) ,.spike(spikes[47]),.fp(fp[47]),.err(err[47]),.true(true[47]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_48 hn48 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_d[9]), .weight1(weight1_d[9]), 
.weight2(weight2_d[9]), .weight3(weight3_d[9]) ,.spike(spikes[48]),.fp(fp[48]),.err(err[48]),.true(true[48]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_49 hn49 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_e[9]), .weight1(weight1_e[9]), 
.weight2(weight2_e[9]), .weight3(weight3_e[9]) ,.spike(spikes[49]),.fp(fp[49]),.err(err[49]),.true(true[49]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_50 hn50 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_a[10]), .weight1(weight1_a[10]), 
.weight2(weight2_a[10]), .weight3(weight3_a[10]) ,.spike(spikes[50]),.fp(fp[50]),.err(err[50]),.true(true[50]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_51 hn51 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_b[10]), .weight1(weight1_b[10]), 
.weight2(weight2_b[10]), .weight3(weight3_b[10]) ,.spike(spikes[51]),.fp(fp[51]),.err(err[51]),.true(true[51]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_52 hn52 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_c[10]), .weight1(weight1_c[10]), 
.weight2(weight2_c[10]), .weight3(weight3_c[10]) ,.spike(spikes[52]),.fp(fp[52]),.err(err[52]),.true(true[52]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_53 hn53 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_d[10]), .weight1(weight1_d[10]), 
.weight2(weight2_d[10]), .weight3(weight3_d[10]) ,.spike(spikes[53]),.fp(fp[53]),.err(err[53]),.true(true[53]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_54 hn54 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_e[10]), .weight1(weight1_e[10]), 
.weight2(weight2_e[10]), .weight3(weight3_e[10]) ,.spike(spikes[54]),.fp(fp[54]),.err(err[54]),.true(true[54]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_55 hn55 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_a[11]), .weight1(weight1_a[11]), 
.weight2(weight2_a[11]), .weight3(weight3_a[11]) ,.spike(spikes[55]),.fp(fp[55]),.err(err[55]),.true(true[55]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_56 hn56 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_b[11]), .weight1(weight1_b[11]), 
.weight2(weight2_b[11]), .weight3(weight3_b[11]) ,.spike(spikes[56]),.fp(fp[56]),.err(err[56]),.true(true[56]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_57 hn57 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_c[11]), .weight1(weight1_c[11]), 
.weight2(weight2_c[11]), .weight3(weight3_c[11]) ,.spike(spikes[57]),.fp(fp[57]),.err(err[57]),.true(true[57]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_58 hn58 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_d[11]), .weight1(weight1_d[11]), 
.weight2(weight2_d[11]), .weight3(weight3_d[11]) ,.spike(spikes[58]),.fp(fp[58]),.err(err[58]),.true(true[58]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_59 hn59 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_e[11]), .weight1(weight1_e[11]), 
.weight2(weight2_e[11]), .weight3(weight3_e[11]) ,.spike(spikes[59]),.fp(fp[59]),.err(err[59]),.true(true[59]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_60 hn60 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_a[12]), .weight1(weight1_a[12]), 
.weight2(weight2_a[12]), .weight3(weight3_a[12]) ,.spike(spikes[60]),.fp(fp[60]),.err(err[60]),.true(true[60]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_61 hn61 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_b[12]), .weight1(weight1_b[12]), 
.weight2(weight2_b[12]), .weight3(weight3_b[12]) ,.spike(spikes[61]),.fp(fp[61]),.err(err[61]),.true(true[61]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_62 hn62 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_c[12]), .weight1(weight1_c[12]), 
.weight2(weight2_c[12]), .weight3(weight3_c[12]) ,.spike(spikes[62]),.fp(fp[62]),.err(err[62]),.true(true[62]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_63 hn63 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_d[12]), .weight1(weight1_d[12]), 
.weight2(weight2_d[12]), .weight3(weight3_d[12]) ,.spike(spikes[63]),.fp(fp[63]),.err(err[63]),.true(true[63]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_64 hn64 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_e[12]), .weight1(weight1_e[12]), 
.weight2(weight2_e[12]), .weight3(weight3_e[12]) ,.spike(spikes[64]),.fp(fp[64]),.err(err[64]),.true(true[64]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_65 hn65 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_a[13]), .weight1(weight1_a[13]), 
.weight2(weight2_a[13]), .weight3(weight3_a[13]) ,.spike(spikes[65]),.fp(fp[65]),.err(err[65]),.true(true[65]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_66 hn66 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_b[13]), .weight1(weight1_b[13]), 
.weight2(weight2_b[13]), .weight3(weight3_b[13]) ,.spike(spikes[66]),.fp(fp[66]),.err(err[66]),.true(true[66]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_67 hn67 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_c[13]), .weight1(weight1_c[13]), 
.weight2(weight2_c[13]), .weight3(weight3_c[13]) ,.spike(spikes[67]),.fp(fp[67]),.err(err[67]),.true(true[67]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_68 hn68 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_d[13]), .weight1(weight1_d[13]), 
.weight2(weight2_d[13]), .weight3(weight3_d[13]) ,.spike(spikes[68]),.fp(fp[68]),.err(err[68]),.true(true[68]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_69 hn69 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_e[13]), .weight1(weight1_e[13]), 
.weight2(weight2_e[13]), .weight3(weight3_e[13]) ,.spike(spikes[69]),.fp(fp[69]),.err(err[69]),.true(true[69]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_70 hn70 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_a[14]), .weight1(weight1_a[14]), 
.weight2(weight2_a[14]), .weight3(weight3_a[14]) ,.spike(spikes[70]),.fp(fp[70]),.err(err[70]),.true(true[70]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_71 hn71 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_b[14]), .weight1(weight1_b[14]), 
.weight2(weight2_b[14]), .weight3(weight3_b[14]) ,.spike(spikes[71]),.fp(fp[71]),.err(err[71]),.true(true[71]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_72 hn72 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_c[14]), .weight1(weight1_c[14]), 
.weight2(weight2_c[14]), .weight3(weight3_c[14]) ,.spike(spikes[72]),.fp(fp[72]),.err(err[72]),.true(true[72]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_73 hn73 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_d[14]), .weight1(weight1_d[14]), 
.weight2(weight2_d[14]), .weight3(weight3_d[14]) ,.spike(spikes[73]),.fp(fp[73]),.err(err[73]),.true(true[73]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_74 hn74 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_e[14]), .weight1(weight1_e[14]), 
.weight2(weight2_e[14]), .weight3(weight3_e[14]) ,.spike(spikes[74]),.fp(fp[74]),.err(err[74]),.true(true[74]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_75 hn75 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_a[15]), .weight1(weight1_a[15]), 
.weight2(weight2_a[15]), .weight3(weight3_a[15]) ,.spike(spikes[75]),.fp(fp[75]),.err(err[75]),.true(true[75]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_76 hn76 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_b[15]), .weight1(weight1_b[15]), 
.weight2(weight2_b[15]), .weight3(weight3_b[15]) ,.spike(spikes[76]),.fp(fp[76]),.err(err[76]),.true(true[76]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_77 hn77 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_c[15]), .weight1(weight1_c[15]), 
.weight2(weight2_c[15]), .weight3(weight3_c[15]) ,.spike(spikes[77]),.fp(fp[77]),.err(err[77]),.true(true[77]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_78 hn78 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_d[15]), .weight1(weight1_d[15]), 
.weight2(weight2_d[15]), .weight3(weight3_d[15]) ,.spike(spikes[78]),.fp(fp[78]),.err(err[78]),.true(true[78]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_79 hn79 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_e[15]), .weight1(weight1_e[15]), 
.weight2(weight2_e[15]), .weight3(weight3_e[15]) ,.spike(spikes[79]),.fp(fp[79]),.err(err[79]),.true(true[79]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_80 hn80 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_a[16]), .weight1(weight1_a[16]), 
.weight2(weight2_a[16]), .weight3(weight3_a[16]) ,.spike(spikes[80]),.fp(fp[80]),.err(err[80]),.true(true[80]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_81 hn81 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_b[16]), .weight1(weight1_b[16]), 
.weight2(weight2_b[16]), .weight3(weight3_b[16]) ,.spike(spikes[81]),.fp(fp[81]),.err(err[81]),.true(true[81]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_82 hn82 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_c[16]), .weight1(weight1_c[16]), 
.weight2(weight2_c[16]), .weight3(weight3_c[16]) ,.spike(spikes[82]),.fp(fp[82]),.err(err[82]),.true(true[82]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_83 hn83 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_d[16]), .weight1(weight1_d[16]), 
.weight2(weight2_d[16]), .weight3(weight3_d[16]) ,.spike(spikes[83]),.fp(fp[83]),.err(err[83]),.true(true[83]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_84 hn84 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_e[16]), .weight1(weight1_e[16]), 
.weight2(weight2_e[16]), .weight3(weight3_e[16]) ,.spike(spikes[84]),.fp(fp[84]),.err(err[84]),.true(true[84]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_85 hn85 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_a[17]), .weight1(weight1_a[17]), 
.weight2(weight2_a[17]), .weight3(weight3_a[17]) ,.spike(spikes[85]),.fp(fp[85]),.err(err[85]),.true(true[85]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_86 hn86 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_b[17]), .weight1(weight1_b[17]), 
.weight2(weight2_b[17]), .weight3(weight3_b[17]) ,.spike(spikes[86]),.fp(fp[86]),.err(err[86]),.true(true[86]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_87 hn87 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_c[17]), .weight1(weight1_c[17]), 
.weight2(weight2_c[17]), .weight3(weight3_c[17]) ,.spike(spikes[87]),.fp(fp[87]),.err(err[87]),.true(true[87]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_88 hn88 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_d[17]), .weight1(weight1_d[17]), 
.weight2(weight2_d[17]), .weight3(weight3_d[17]) ,.spike(spikes[88]),.fp(fp[88]),.err(err[88]),.true(true[88]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_89 hn89 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_e[17]), .weight1(weight1_e[17]), 
.weight2(weight2_e[17]), .weight3(weight3_e[17]) ,.spike(spikes[89]),.fp(fp[89]),.err(err[89]),.true(true[89]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_90 hn90 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_a[18]), .weight1(weight1_a[18]), 
.weight2(weight2_a[18]), .weight3(weight3_a[18]) ,.spike(spikes[90]),.fp(fp[90]),.err(err[90]),.true(true[90]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_91 hn91 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_b[18]), .weight1(weight1_b[18]), 
.weight2(weight2_b[18]), .weight3(weight3_b[18]) ,.spike(spikes[91]),.fp(fp[91]),.err(err[91]),.true(true[91]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_92 hn92 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_c[18]), .weight1(weight1_c[18]), 
.weight2(weight2_c[18]), .weight3(weight3_c[18]) ,.spike(spikes[92]),.fp(fp[92]),.err(err[92]),.true(true[92]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_93 hn93 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_d[18]), .weight1(weight1_d[18]), 
.weight2(weight2_d[18]), .weight3(weight3_d[18]) ,.spike(spikes[93]),.fp(fp[93]),.err(err[93]),.true(true[93]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_94 hn94 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_e[18]), .weight1(weight1_e[18]), 
.weight2(weight2_e[18]), .weight3(weight3_e[18]) ,.spike(spikes[94]),.fp(fp[94]),.err(err[94]),.true(true[94]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_95 hn95 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_a[19]), .weight1(weight1_a[19]), 
.weight2(weight2_a[19]), .weight3(weight3_a[19]) ,.spike(spikes[95]),.fp(fp[95]),.err(err[95]),.true(true[95]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_96 hn96 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_b[19]), .weight1(weight1_b[19]), 
.weight2(weight2_b[19]), .weight3(weight3_b[19]) ,.spike(spikes[96]),.fp(fp[96]),.err(err[96]),.true(true[96]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_97 hn97 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_c[19]), .weight1(weight1_c[19]), 
.weight2(weight2_c[19]), .weight3(weight3_c[19]) ,.spike(spikes[97]),.fp(fp[97]),.err(err[97]),.true(true[97]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_98 hn98 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_d[19]), .weight1(weight1_d[19]), 
.weight2(weight2_d[19]), .weight3(weight3_d[19]) ,.spike(spikes[98]),.fp(fp[98]),.err(err[98]),.true(true[98]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_99 hn99 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_e[19]), .weight1(weight1_e[19]), 
.weight2(weight2_e[19]), .weight3(weight3_e[19]) ,.spike(spikes[99]),.fp(fp[99]),.err(err[99]),.true(true[99]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_100 hn100 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_a[20]), .weight1(weight1_a[20]), 
.weight2(weight2_a[20]), .weight3(weight3_a[20]) ,.spike(spikes[100]),.fp(fp[100]),.err(err[100]),.true(true[100]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_101 hn101 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_b[20]), .weight1(weight1_b[20]), 
.weight2(weight2_b[20]), .weight3(weight3_b[20]) ,.spike(spikes[101]),.fp(fp[101]),.err(err[101]),.true(true[101]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_102 hn102 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_c[20]), .weight1(weight1_c[20]), 
.weight2(weight2_c[20]), .weight3(weight3_c[20]) ,.spike(spikes[102]),.fp(fp[102]),.err(err[102]),.true(true[102]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_103 hn103 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_d[20]), .weight1(weight1_d[20]), 
.weight2(weight2_d[20]), .weight3(weight3_d[20]) ,.spike(spikes[103]),.fp(fp[103]),.err(err[103]),.true(true[103]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_104 hn104 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_e[20]), .weight1(weight1_e[20]), 
.weight2(weight2_e[20]), .weight3(weight3_e[20]) ,.spike(spikes[104]),.fp(fp[104]),.err(err[104]),.true(true[104]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_105 hn105 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_a[21]), .weight1(weight1_a[21]), 
.weight2(weight2_a[21]), .weight3(weight3_a[21]) ,.spike(spikes[105]),.fp(fp[105]),.err(err[105]),.true(true[105]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_106 hn106 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_b[21]), .weight1(weight1_b[21]), 
.weight2(weight2_b[21]), .weight3(weight3_b[21]) ,.spike(spikes[106]),.fp(fp[106]),.err(err[106]),.true(true[106]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_107 hn107 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_c[21]), .weight1(weight1_c[21]), 
.weight2(weight2_c[21]), .weight3(weight3_c[21]) ,.spike(spikes[107]),.fp(fp[107]),.err(err[107]),.true(true[107]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_108 hn108 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_d[21]), .weight1(weight1_d[21]), 
.weight2(weight2_d[21]), .weight3(weight3_d[21]) ,.spike(spikes[108]),.fp(fp[108]),.err(err[108]),.true(true[108]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_109 hn109 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_e[21]), .weight1(weight1_e[21]), 
.weight2(weight2_e[21]), .weight3(weight3_e[21]) ,.spike(spikes[109]),.fp(fp[109]),.err(err[109]),.true(true[109]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_110 hn110 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_a[22]), .weight1(weight1_a[22]), 
.weight2(weight2_a[22]), .weight3(weight3_a[22]) ,.spike(spikes[110]),.fp(fp[110]),.err(err[110]),.true(true[110]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_111 hn111 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_b[22]), .weight1(weight1_b[22]), 
.weight2(weight2_b[22]), .weight3(weight3_b[22]) ,.spike(spikes[111]),.fp(fp[111]),.err(err[111]),.true(true[111]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_112 hn112 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_c[22]), .weight1(weight1_c[22]), 
.weight2(weight2_c[22]), .weight3(weight3_c[22]) ,.spike(spikes[112]),.fp(fp[112]),.err(err[112]),.true(true[112]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_113 hn113 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_d[22]), .weight1(weight1_d[22]), 
.weight2(weight2_d[22]), .weight3(weight3_d[22]) ,.spike(spikes[113]),.fp(fp[113]),.err(err[113]),.true(true[113]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_114 hn114 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_e[22]), .weight1(weight1_e[22]), 
.weight2(weight2_e[22]), .weight3(weight3_e[22]) ,.spike(spikes[114]),.fp(fp[114]),.err(err[114]),.true(true[114]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_115 hn115 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_a[23]), .weight1(weight1_a[23]), 
.weight2(weight2_a[23]), .weight3(weight3_a[23]) ,.spike(spikes[115]),.fp(fp[115]),.err(err[115]),.true(true[115]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_116 hn116 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_b[23]), .weight1(weight1_b[23]), 
.weight2(weight2_b[23]), .weight3(weight3_b[23]) ,.spike(spikes[116]),.fp(fp[116]),.err(err[116]),.true(true[116]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_117 hn117 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_c[23]), .weight1(weight1_c[23]), 
.weight2(weight2_c[23]), .weight3(weight3_c[23]) ,.spike(spikes[117]),.fp(fp[117]),.err(err[117]),.true(true[117]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_118 hn118 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_d[23]), .weight1(weight1_d[23]), 
.weight2(weight2_d[23]), .weight3(weight3_d[23]) ,.spike(spikes[118]),.fp(fp[118]),.err(err[118]),.true(true[118]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_119 hn119 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_e[23]), .weight1(weight1_e[23]), 
.weight2(weight2_e[23]), .weight3(weight3_e[23]) ,.spike(spikes[119]),.fp(fp[119]),.err(err[119]),.true(true[119]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_120 hn120 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_a[24]), .weight1(weight1_a[24]), 
.weight2(weight2_a[24]), .weight3(weight3_a[24]) ,.spike(spikes[120]),.fp(fp[120]),.err(err[120]),.true(true[120]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_121 hn121 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_b[24]), .weight1(weight1_b[24]), 
.weight2(weight2_b[24]), .weight3(weight3_b[24]) ,.spike(spikes[121]),.fp(fp[121]),.err(err[121]),.true(true[121]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_122 hn122 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_c[24]), .weight1(weight1_c[24]), 
.weight2(weight2_c[24]), .weight3(weight3_c[24]) ,.spike(spikes[122]),.fp(fp[122]),.err(err[122]),.true(true[122]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_123 hn123 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_d[24]), .weight1(weight1_d[24]), 
.weight2(weight2_d[24]), .weight3(weight3_d[24]) ,.spike(spikes[123]),.fp(fp[123]),.err(err[123]),.true(true[123]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_124 hn124 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_e[24]), .weight1(weight1_e[24]), 
.weight2(weight2_e[24]), .weight3(weight3_e[24]) ,.spike(spikes[124]),.fp(fp[124]),.err(err[124]),.true(true[124]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_125 hn125 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_a[25]), .weight1(weight1_a[25]), 
.weight2(weight2_a[25]), .weight3(weight3_a[25]) ,.spike(spikes[125]),.fp(fp[125]),.err(err[125]),.true(true[125]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_126 hn126 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_b[25]), .weight1(weight1_b[25]), 
.weight2(weight2_b[25]), .weight3(weight3_b[25]) ,.spike(spikes[126]),.fp(fp[126]),.err(err[126]),.true(true[126]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_127 hn127 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_c[25]), .weight1(weight1_c[25]), 
.weight2(weight2_c[25]), .weight3(weight3_c[25]) ,.spike(spikes[127]),.fp(fp[127]),.err(err[127]),.true(true[127]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_128 hn128 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_d[25]), .weight1(weight1_d[25]), 
.weight2(weight2_d[25]), .weight3(weight3_d[25]) ,.spike(spikes[128]),.fp(fp[128]),.err(err[128]),.true(true[128]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_129 hn129 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_e[25]), .weight1(weight1_e[25]), 
.weight2(weight2_e[25]), .weight3(weight3_e[25]) ,.spike(spikes[129]),.fp(fp[129]),.err(err[129]),.true(true[129]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_130 hn130 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_a[26]), .weight1(weight1_a[26]), 
.weight2(weight2_a[26]), .weight3(weight3_a[26]) ,.spike(spikes[130]),.fp(fp[130]),.err(err[130]),.true(true[130]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_131 hn131 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_b[26]), .weight1(weight1_b[26]), 
.weight2(weight2_b[26]), .weight3(weight3_b[26]) ,.spike(spikes[131]),.fp(fp[131]),.err(err[131]),.true(true[131]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_132 hn132 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_c[26]), .weight1(weight1_c[26]), 
.weight2(weight2_c[26]), .weight3(weight3_c[26]) ,.spike(spikes[132]),.fp(fp[132]),.err(err[132]),.true(true[132]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_133 hn133 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_d[26]), .weight1(weight1_d[26]), 
.weight2(weight2_d[26]), .weight3(weight3_d[26]) ,.spike(spikes[133]),.fp(fp[133]),.err(err[133]),.true(true[133]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_134 hn134 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_e[26]), .weight1(weight1_e[26]), 
.weight2(weight2_e[26]), .weight3(weight3_e[26]) ,.spike(spikes[134]),.fp(fp[134]),.err(err[134]),.true(true[134]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_135 hn135 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_a[27]), .weight1(weight1_a[27]), 
.weight2(weight2_a[27]), .weight3(weight3_a[27]) ,.spike(spikes[135]),.fp(fp[135]),.err(err[135]),.true(true[135]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_136 hn136 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_b[27]), .weight1(weight1_b[27]), 
.weight2(weight2_b[27]), .weight3(weight3_b[27]) ,.spike(spikes[136]),.fp(fp[136]),.err(err[136]),.true(true[136]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_137 hn137 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_c[27]), .weight1(weight1_c[27]), 
.weight2(weight2_c[27]), .weight3(weight3_c[27]) ,.spike(spikes[137]),.fp(fp[137]),.err(err[137]),.true(true[137]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_138 hn138 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_d[27]), .weight1(weight1_d[27]), 
.weight2(weight2_d[27]), .weight3(weight3_d[27]) ,.spike(spikes[138]),.fp(fp[138]),.err(err[138]),.true(true[138]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_139 hn139 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_e[27]), .weight1(weight1_e[27]), 
.weight2(weight2_e[27]), .weight3(weight3_e[27]) ,.spike(spikes[139]),.fp(fp[139]),.err(err[139]),.true(true[139]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_140 hn140 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_a[28]), .weight1(weight1_a[28]), 
.weight2(weight2_a[28]), .weight3(weight3_a[28]) ,.spike(spikes[140]),.fp(fp[140]),.err(err[140]),.true(true[140]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_141 hn141 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_b[28]), .weight1(weight1_b[28]), 
.weight2(weight2_b[28]), .weight3(weight3_b[28]) ,.spike(spikes[141]),.fp(fp[141]),.err(err[141]),.true(true[141]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_142 hn142 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_c[28]), .weight1(weight1_c[28]), 
.weight2(weight2_c[28]), .weight3(weight3_c[28]) ,.spike(spikes[142]),.fp(fp[142]),.err(err[142]),.true(true[142]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_143 hn143 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_d[28]), .weight1(weight1_d[28]), 
.weight2(weight2_d[28]), .weight3(weight3_d[28]) ,.spike(spikes[143]),.fp(fp[143]),.err(err[143]),.true(true[143]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_144 hn144 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_e[28]), .weight1(weight1_e[28]), 
.weight2(weight2_e[28]), .weight3(weight3_e[28]) ,.spike(spikes[144]),.fp(fp[144]),.err(err[144]),.true(true[144]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_145 hn145 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_a[29]), .weight1(weight1_a[29]), 
.weight2(weight2_a[29]), .weight3(weight3_a[29]) ,.spike(spikes[145]),.fp(fp[145]),.err(err[145]),.true(true[145]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_146 hn146 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_b[29]), .weight1(weight1_b[29]), 
.weight2(weight2_b[29]), .weight3(weight3_b[29]) ,.spike(spikes[146]),.fp(fp[146]),.err(err[146]),.true(true[146]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_147 hn147 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_c[29]), .weight1(weight1_c[29]), 
.weight2(weight2_c[29]), .weight3(weight3_c[29]) ,.spike(spikes[147]),.fp(fp[147]),.err(err[147]),.true(true[147]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_148 hn148 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_d[29]), .weight1(weight1_d[29]), 
.weight2(weight2_d[29]), .weight3(weight3_d[29]) ,.spike(spikes[148]),.fp(fp[148]),.err(err[148]),.true(true[148]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_149 hn149 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_e[29]), .weight1(weight1_e[29]), 
.weight2(weight2_e[29]), .weight3(weight3_e[29]) ,.spike(spikes[149]),.fp(fp[149]),.err(err[149]),.true(true[149]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_150 hn150 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_a[30]), .weight1(weight1_a[30]), 
.weight2(weight2_a[30]), .weight3(weight3_a[30]) ,.spike(spikes[150]),.fp(fp[150]),.err(err[150]),.true(true[150]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_151 hn151 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_b[30]), .weight1(weight1_b[30]), 
.weight2(weight2_b[30]), .weight3(weight3_b[30]) ,.spike(spikes[151]),.fp(fp[151]),.err(err[151]),.true(true[151]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_152 hn152 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_c[30]), .weight1(weight1_c[30]), 
.weight2(weight2_c[30]), .weight3(weight3_c[30]) ,.spike(spikes[152]),.fp(fp[152]),.err(err[152]),.true(true[152]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_153 hn153 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_d[30]), .weight1(weight1_d[30]), 
.weight2(weight2_d[30]), .weight3(weight3_d[30]) ,.spike(spikes[153]),.fp(fp[153]),.err(err[153]),.true(true[153]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_154 hn154 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_e[30]), .weight1(weight1_e[30]), 
.weight2(weight2_e[30]), .weight3(weight3_e[30]) ,.spike(spikes[154]),.fp(fp[154]),.err(err[154]),.true(true[154]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_155 hn155 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_a[31]), .weight1(weight1_a[31]), 
.weight2(weight2_a[31]), .weight3(weight3_a[31]) ,.spike(spikes[155]),.fp(fp[155]),.err(err[155]),.true(true[155]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_156 hn156 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_b[31]), .weight1(weight1_b[31]), 
.weight2(weight2_b[31]), .weight3(weight3_b[31]) ,.spike(spikes[156]),.fp(fp[156]),.err(err[156]),.true(true[156]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_157 hn157 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_c[31]), .weight1(weight1_c[31]), 
.weight2(weight2_c[31]), .weight3(weight3_c[31]) ,.spike(spikes[157]),.fp(fp[157]),.err(err[157]),.true(true[157]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_158 hn158 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_d[31]), .weight1(weight1_d[31]), 
.weight2(weight2_d[31]), .weight3(weight3_d[31]) ,.spike(spikes[158]),.fp(fp[158]),.err(err[158]),.true(true[158]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_159 hn159 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_e[31]), .weight1(weight1_e[31]), 
.weight2(weight2_e[31]), .weight3(weight3_e[31]) ,.spike(spikes[159]),.fp(fp[159]),.err(err[159]),.true(true[159]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_160 hn160 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_a[32]), .weight1(weight1_a[32]), 
.weight2(weight2_a[32]), .weight3(weight3_a[32]) ,.spike(spikes[160]),.fp(fp[160]),.err(err[160]),.true(true[160]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_161 hn161 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_b[32]), .weight1(weight1_b[32]), 
.weight2(weight2_b[32]), .weight3(weight3_b[32]) ,.spike(spikes[161]),.fp(fp[161]),.err(err[161]),.true(true[161]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_162 hn162 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_c[32]), .weight1(weight1_c[32]), 
.weight2(weight2_c[32]), .weight3(weight3_c[32]) ,.spike(spikes[162]),.fp(fp[162]),.err(err[162]),.true(true[162]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_163 hn163 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_d[32]), .weight1(weight1_d[32]), 
.weight2(weight2_d[32]), .weight3(weight3_d[32]) ,.spike(spikes[163]),.fp(fp[163]),.err(err[163]),.true(true[163]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_164 hn164 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_e[32]), .weight1(weight1_e[32]), 
.weight2(weight2_e[32]), .weight3(weight3_e[32]) ,.spike(spikes[164]),.fp(fp[164]),.err(err[164]),.true(true[164]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_165 hn165 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_a[33]), .weight1(weight1_a[33]), 
.weight2(weight2_a[33]), .weight3(weight3_a[33]) ,.spike(spikes[165]),.fp(fp[165]),.err(err[165]),.true(true[165]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_166 hn166 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_b[33]), .weight1(weight1_b[33]), 
.weight2(weight2_b[33]), .weight3(weight3_b[33]) ,.spike(spikes[166]),.fp(fp[166]),.err(err[166]),.true(true[166]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_167 hn167 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_c[33]), .weight1(weight1_c[33]), 
.weight2(weight2_c[33]), .weight3(weight3_c[33]) ,.spike(spikes[167]),.fp(fp[167]),.err(err[167]),.true(true[167]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_168 hn168 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_d[33]), .weight1(weight1_d[33]), 
.weight2(weight2_d[33]), .weight3(weight3_d[33]) ,.spike(spikes[168]),.fp(fp[168]),.err(err[168]),.true(true[168]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_169 hn169 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_e[33]), .weight1(weight1_e[33]), 
.weight2(weight2_e[33]), .weight3(weight3_e[33]) ,.spike(spikes[169]),.fp(fp[169]),.err(err[169]),.true(true[169]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_170 hn170 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_a[34]), .weight1(weight1_a[34]), 
.weight2(weight2_a[34]), .weight3(weight3_a[34]) ,.spike(spikes[170]),.fp(fp[170]),.err(err[170]),.true(true[170]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_171 hn171 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_b[34]), .weight1(weight1_b[34]), 
.weight2(weight2_b[34]), .weight3(weight3_b[34]) ,.spike(spikes[171]),.fp(fp[171]),.err(err[171]),.true(true[171]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_172 hn172 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_c[34]), .weight1(weight1_c[34]), 
.weight2(weight2_c[34]), .weight3(weight3_c[34]) ,.spike(spikes[172]),.fp(fp[172]),.err(err[172]),.true(true[172]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_173 hn173 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_d[34]), .weight1(weight1_d[34]), 
.weight2(weight2_d[34]), .weight3(weight3_d[34]) ,.spike(spikes[173]),.fp(fp[173]),.err(err[173]),.true(true[173]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_174 hn174 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_e[34]), .weight1(weight1_e[34]), 
.weight2(weight2_e[34]), .weight3(weight3_e[34]) ,.spike(spikes[174]),.fp(fp[174]),.err(err[174]),.true(true[174]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_175 hn175 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_a[35]), .weight1(weight1_a[35]), 
.weight2(weight2_a[35]), .weight3(weight3_a[35]) ,.spike(spikes[175]),.fp(fp[175]),.err(err[175]),.true(true[175]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_176 hn176 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_b[35]), .weight1(weight1_b[35]), 
.weight2(weight2_b[35]), .weight3(weight3_b[35]) ,.spike(spikes[176]),.fp(fp[176]),.err(err[176]),.true(true[176]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_177 hn177 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_c[35]), .weight1(weight1_c[35]), 
.weight2(weight2_c[35]), .weight3(weight3_c[35]) ,.spike(spikes[177]),.fp(fp[177]),.err(err[177]),.true(true[177]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_178 hn178 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_d[35]), .weight1(weight1_d[35]), 
.weight2(weight2_d[35]), .weight3(weight3_d[35]) ,.spike(spikes[178]),.fp(fp[178]),.err(err[178]),.true(true[178]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_179 hn179 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_e[35]), .weight1(weight1_e[35]), 
.weight2(weight2_e[35]), .weight3(weight3_e[35]) ,.spike(spikes[179]),.fp(fp[179]),.err(err[179]),.true(true[179]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_180 hn180 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_a[36]), .weight1(weight1_a[36]), 
.weight2(weight2_a[36]), .weight3(weight3_a[36]) ,.spike(spikes[180]),.fp(fp[180]),.err(err[180]),.true(true[180]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_181 hn181 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_b[36]), .weight1(weight1_b[36]), 
.weight2(weight2_b[36]), .weight3(weight3_b[36]) ,.spike(spikes[181]),.fp(fp[181]),.err(err[181]),.true(true[181]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_182 hn182 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_c[36]), .weight1(weight1_c[36]), 
.weight2(weight2_c[36]), .weight3(weight3_c[36]) ,.spike(spikes[182]),.fp(fp[182]),.err(err[182]),.true(true[182]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_183 hn183 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_d[36]), .weight1(weight1_d[36]), 
.weight2(weight2_d[36]), .weight3(weight3_d[36]) ,.spike(spikes[183]),.fp(fp[183]),.err(err[183]),.true(true[183]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_184 hn184 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_e[36]), .weight1(weight1_e[36]), 
.weight2(weight2_e[36]), .weight3(weight3_e[36]) ,.spike(spikes[184]),.fp(fp[184]),.err(err[184]),.true(true[184]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_185 hn185 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_a[37]), .weight1(weight1_a[37]), 
.weight2(weight2_a[37]), .weight3(weight3_a[37]) ,.spike(spikes[185]),.fp(fp[185]),.err(err[185]),.true(true[185]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_186 hn186 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_b[37]), .weight1(weight1_b[37]), 
.weight2(weight2_b[37]), .weight3(weight3_b[37]) ,.spike(spikes[186]),.fp(fp[186]),.err(err[186]),.true(true[186]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_187 hn187 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_c[37]), .weight1(weight1_c[37]), 
.weight2(weight2_c[37]), .weight3(weight3_c[37]) ,.spike(spikes[187]),.fp(fp[187]),.err(err[187]),.true(true[187]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_188 hn188 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_d[37]), .weight1(weight1_d[37]), 
.weight2(weight2_d[37]), .weight3(weight3_d[37]) ,.spike(spikes[188]),.fp(fp[188]),.err(err[188]),.true(true[188]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_189 hn189 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_e[37]), .weight1(weight1_e[37]), 
.weight2(weight2_e[37]), .weight3(weight3_e[37]) ,.spike(spikes[189]),.fp(fp[189]),.err(err[189]),.true(true[189]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_190 hn190 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_a[38]), .weight1(weight1_a[38]), 
.weight2(weight2_a[38]), .weight3(weight3_a[38]) ,.spike(spikes[190]),.fp(fp[190]),.err(err[190]),.true(true[190]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_191 hn191 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_b[38]), .weight1(weight1_b[38]), 
.weight2(weight2_b[38]), .weight3(weight3_b[38]) ,.spike(spikes[191]),.fp(fp[191]),.err(err[191]),.true(true[191]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_192 hn192 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_c[38]), .weight1(weight1_c[38]), 
.weight2(weight2_c[38]), .weight3(weight3_c[38]) ,.spike(spikes[192]),.fp(fp[192]),.err(err[192]),.true(true[192]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_193 hn193 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_d[38]), .weight1(weight1_d[38]), 
.weight2(weight2_d[38]), .weight3(weight3_d[38]) ,.spike(spikes[193]),.fp(fp[193]),.err(err[193]),.true(true[193]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_194 hn194 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_e[38]), .weight1(weight1_e[38]), 
.weight2(weight2_e[38]), .weight3(weight3_e[38]) ,.spike(spikes[194]),.fp(fp[194]),.err(err[194]),.true(true[194]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_195 hn195 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_a[39]), .weight1(weight1_a[39]), 
.weight2(weight2_a[39]), .weight3(weight3_a[39]) ,.spike(spikes[195]),.fp(fp[195]),.err(err[195]),.true(true[195]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_196 hn196 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_b[39]), .weight1(weight1_b[39]), 
.weight2(weight2_b[39]), .weight3(weight3_b[39]) ,.spike(spikes[196]),.fp(fp[196]),.err(err[196]),.true(true[196]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_197 hn197 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_c[39]), .weight1(weight1_c[39]), 
.weight2(weight2_c[39]), .weight3(weight3_c[39]) ,.spike(spikes[197]),.fp(fp[197]),.err(err[197]),.true(true[197]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_198 hn198 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_d[39]), .weight1(weight1_d[39]), 
.weight2(weight2_d[39]), .weight3(weight3_d[39]) ,.spike(spikes[198]),.fp(fp[198]),.err(err[198]),.true(true[198]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));

	stonet_hidden_neuron1_199 hn199 (.clk(clk), .resetn(resetn), .train(train), .infer(infer), .outaddr(outaddr),.new_block(new_block), .weight0(weight0_e[39]), .weight1(weight1_e[39]), 
.weight2(weight2_e[39]), .weight3(weight3_e[39]) ,.spike(spikes[199]),.fp(fp[199]),.err(err[199]),.true(true[199]), .gen_spike(gen_spike), .errspikes(errspike), .truespikes(truespike));


endmodule
	
