module tb_top();
    parameter NUM_IMAGES = 60000;
    //ports
    reg clk, resetn, input_valid, pause, train, infer, initialize;
    reg [13:0] init_val;
    reg [31:0] image;
    reg [3:0] label;
    reg sto_infer;

    wire img_request;
    wire output_valid;
    wire [13:0] neuron_voltages;
    wire init_fin;
    wire label_request;


    reg [1023:0] vpdfile = "tb_top.vpd";
    
    reg [31:0] image_train_data [NUM_IMAGES*196 - 1:0];//5000 train image samples
    reg [31:0] image_test_data [10000*196-1:0];

    reg [3:0] label_data [NUM_IMAGES-1:0];
    reg [3:0] label_test_data [NUM_IMAGES-1:0];

    reg [13:0] init_data [238577 - 1:0];
    
    reg [3:0] tlabel, label_buffer0, label_buffer1, label_buffer2;
    reg report_mem;

    reg img_ready;
    reg start_infer;
    real correct = 0;
    integer pause_counter = 0;
    integer i=0;
    integer j=0;
    integer pixel = 0;
    integer infer_pixel = 0;
    integer infer_img_index = 0;
    integer img_index = 0;
    integer blockcounter = 0;
    integer maxval;
    integer maxindex;
    integer correct = 0;
    integer memfile;
    integer memfile2;
    integer outputfile;
    integer trainingfile;
    integer pause_counter =0;

    top DUT(.sto_infer(sto_infer),.train(train),.label_request(label_request),.neuron_voltages(neuron_voltages),.infer(infer),.pause(pause),.initialize(initialize),.img_request(img_request),.clk(clk),.resetn(resetn),.init_fin(init_fin),.init_val(init_val),.input_valid(input_valid),.image(image),.label0(label),.output_valid(output_valid));

  
 
    //Testing Initialization
    initial begin
        //train = 1'b1;        
        tlabel = 10;
        label_buffer0 = 10;
        label_buffer1 = 10;
        label_buffer2 = 10;
        start_infer = 0;     
        clk = 0;
        resetn = 1;
        input_valid = 0;
        img_ready = 0;
        pause = 0;
        train = 0;
        infer = 0;
        initialize = 0;
        image = 0;
        label = 0;
        report_mem = 0;
        $vcdplusfile(vpdfile);
        $vcdpluson();
        
        #5 resetn = 0;
        #999 resetn = 1;
        //#5 initialize = 1'b0;
        //input_valid = 1'b1;
         
        $readmemh("/home/mmsjw/2018TapeOut/verilog/tb/MNIST_60000.txt",image_train_data);
        $readmemb("/home/mmsjw/2018TapeOut/verilog/tb/MNIST_labels_60000.txt",label_data);
        
        $readmemh("/home/mmsjw/2018TapeOut/verilog/tb/MNIST_TEST.txt",image_test_data);
        $readmemb("/home/mmsjw/2018TapeOut/verilog/tb/MNIST_TEST_labels.txt",label_test_data);

        $readmemb("/home/mmsjw/2018TapeOut/verilog/tb/memory_init/mem_dump.txt.2",init_data);
        outputfile = $fopen("output.txt","w");
        trainingfile = $fopen("training.txt","w");
        
       
        
    end

    always @(posedge clk) begin
        //#5 init_val = $signed($urandom%1024) - 'sd512;
        //i = i+1;
        //Make sure that hold time is not violated in this case (setup delay at input?)
        #0.5;
        //i = i + 1;
        //train = 1'b1;
        if ((init_fin==1'b0) &(resetn==1'b1)) begin
                initialize=1'b1;
                init_val = init_data[i];
                i = i + 1;
            end
        if (train==1'b1) begin
                img_ready=1;
        end 
      if ((init_fin==1'b1)&(img_request)&(img_ready==1'b1)) begin
                
                image = image_train_data[pixel];
                pixel = pixel + 1; 
                input_valid = 1'b1;
            end
            else if ((init_fin==1'b1)&(img_request==1'b1)&(img_ready==1'b0)) begin
                input_valid = 1'b0;
                image = 'dx;
                
            end
            if (output_valid==1'b1) begin
                $fdisplay(outputfile,"%h",neuron_voltages);
            end
            
            if (label_request) begin
              
                maxval = -1023;
                maxindex = -1;
                //Change this mechanism so that I do not need .fp for calculation
                for (integer l=0; l<10; l=l+1) begin
                    if(maxval<$signed(DUT.outputlayer.fp[l])) begin
                        maxval = $signed(DUT.outputlayer.fp[l]);
                        maxindex = l;
                    end
                end
                
                    
                $display("Guess Label:%d",maxindex);
                $display("True Label:\t%d",DUT.outputlayer.label);
                $display("Now processing:%d",img_index);
                if (DUT.outputlayer.label==maxindex) begin
                   correct = correct + 1;
                end
                if ((img_index%100==99)) begin
                    $display("Accuracy: %f",correct/img_index);
                end
                label = label_data[img_index];
                img_index = img_index + 1;
                //label = label_data[img_index]
            end 
        end
           
        
            

    
    always begin
        #5 clk = ~clk;
        if (init_fin==1'b1 & img_index<59000) begin
            initialize=1'b0;
            train = 1'b1; 
        end
        else if (img_index>58999) begin
            train = 1'b0;
            start_infer = 1'b1;
        end



        if (infer_img_index > 9999) begin
            $fclose(outputfile);
            $fclose(trainingfile);
            $vcdplusclose;
            $finish;
        end
    end
endmodule
