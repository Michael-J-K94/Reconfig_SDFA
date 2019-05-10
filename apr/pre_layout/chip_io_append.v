module chip (
        CLK, RST_N, info__write_val, EN_info__write, RDY_info__write, 
        EN_levels__read, levels__read, RDY_levels__read, levels__write_val, 
        EN_levels__write, RDY_levels__write, EN_residues__read, residues__read, 
        RDY_residues__read, initializeCustomScales__write_val, 
        EN_initializeCustomScales__write, RDY_initializeCustomScales__write );
 
  input [45:0] info__write_val;
  output [8:0] levels__read;
  input [63:0] levels__write_val;
  output [35:0] residues__read;
  input [39:0] initializeCustomScales__write_val;
  input CLK, RST_N, EN_info__write, EN_levels__read, EN_levels__write,
         EN_residues__read, EN_initializeCustomScales__write;
  output RDY_info__write, RDY_levels__read, RDY_levels__write,
         RDY_residues__read, RDY_initializeCustomScales__write;

  wire [45:0] w_info__write_val;
  wire  [8:0] w_levels__read;
  wire [63:0] w_levels__write_val;
  wire  [35:0] w_residues__read;
  wire [39:0] w_initializeCustomScales__write_val;

  wire 
    w_CLK, 
    w_RST_N, 
    w_EN_info__write, 
    w_EN_levels__read, 
    w_EN_levels__write,
    w_EN_residues__read, 
    w_EN_initializeCustomScales__write;
  
  wire  
    w_RDY_info__write, 
    w_RDY_levels__read, 
    w_RDY_levels__write,
    w_RDY_residues__read, 
    w_RDY_initializeCustomScales__write;

  mkITTop top ( 
   .CLK                                      (w_CLK),                                       
   .RST_N                                    (w_RST_N), 
                                             
   .info__write_val                          (w_info__write_val), 
   .EN_info__write                           (w_EN_info__write), 
   .RDY_info__write                          (w_RDY_info__write), 
                                             
   .EN_levels__read                          (w_EN_levels__read), 
   .levels__read                             (w_levels__read), 
   .RDY_levels__read                         (w_RDY_levels__read), 
                                             
   .levels__write_val                        (w_levels__write_val), 
   .EN_levels__write                         (w_EN_levels__write), 
   .RDY_levels__write                        (w_RDY_levels__write), 
                                             
   .EN_residues__read                        (w_EN_residues__read), 
   .residues__read                           (w_residues__read), 
   .RDY_residues__read                       (w_RDY_residues__read), 
                                             
   .initializeCustomScales__write_val        (w_initializeCustomScales__write_val), 
   .EN_initializeCustomScales__write         (w_EN_initializeCustomScales__write), 
   .RDY_initializeCustomScales__write        (w_RDY_initializeCustomScales__write) 
  );
  
  
  PDIDGZ   PADIN_CLK          (.PAD(CLK                ), .C(w_CLK                ));
  PDIDGZ   PADIN_RSTN         (.PAD(RST_N              ), .C(w_RST_N              ));
  
  PDIDGZ   PADIN_EN_CONFIG    (.PAD(EN_info__write                        ), .C(w_EN_info__write                        ));
  PDIDGZ   PADIN_EN_CMD       (.PAD(EN_levels__read                       ), .C(w_EN_levels__read                       ));
  PDIDGZ   PADIN_EN_WDATA     (.PAD(EN_levels__write                      ), .C(w_EN_levels__write                      ));
  PDIDGZ   PADIN_EN_RDATA     (.PAD(EN_residues__read                     ), .C(w_EN_residues__read                     ));
  PDIDGZ   PADIN_EN_RDATA     (.PAD(EN_initializeCustomScales__write      ), .C(w_EN_initializeCustomScales__write      ));
  
  PDO08CDG PADOUT_RDY_CONFIG  (.PAD(RDY_info__write                        ), .I(w_RDY_info__write                        ));
  PDO08CDG PADOUT_RDY_CMD     (.PAD(RDY_levels__read                       ), .I(w_RDY_levels__read                       ));
  PDO08CDG PADOUT_RDY_WDATA   (.PAD(RDY_levels__write                      ), .I(w_RDY_levels__write                      ));
  PDO08CDG PADOUT_RDY_RDATA   (.PAD(RDY_residues__read                     ), .I(w_RDY_residues__read                     ));
  PDO08CDG PADOUT_DEQ_RDATA   (.PAD(RDY_initializeCustomScales__write      ), .I(w_RDY_initializeCustomScales__write      ));
  
  PDIDGZ   PADIN_CONFIG0      (.PAD(levels__read[0]), .C(w_levels__read[0]));
  PDIDGZ   PADIN_CONFIG1      (.PAD(levels__read[1]), .C(w_levels__read[1]));
  PDIDGZ   PADIN_CONFIG2      (.PAD(levels__read[2]), .C(w_levels__read[2]));
  PDIDGZ   PADIN_CONFIG3      (.PAD(levels__read[3]), .C(w_levels__read[3]));
  PDIDGZ   PADIN_CONFIG4      (.PAD(levels__read[4]), .C(w_levels__read[4]));
  PDIDGZ   PADIN_CONFIG5      (.PAD(levels__read[5]), .C(w_levels__read[5]));
  PDIDGZ   PADIN_CONFIG6      (.PAD(levels__read[6]), .C(w_levels__read[6]));
  PDIDGZ   PADIN_CONFIG7      (.PAD(levels__read[7]), .C(w_levels__read[7]));
  
  PDIDGZ   PADIN_INFO00      (.PAD(info__write_val[00]), .C(w_info__write_val[00]));
  PDIDGZ   PADIN_INFO01      (.PAD(info__write_val[01]), .C(w_info__write_val[01]));
  PDIDGZ   PADIN_INFO02      (.PAD(info__write_val[02]), .C(w_info__write_val[02]));
  PDIDGZ   PADIN_INFO03      (.PAD(info__write_val[03]), .C(w_info__write_val[03]));
  PDIDGZ   PADIN_INFO04      (.PAD(info__write_val[04]), .C(w_info__write_val[04]));
  PDIDGZ   PADIN_INFO05      (.PAD(info__write_val[05]), .C(w_info__write_val[05]));
  PDIDGZ   PADIN_INFO06      (.PAD(info__write_val[06]), .C(w_info__write_val[06]));
  PDIDGZ   PADIN_INFO07      (.PAD(info__write_val[07]), .C(w_info__write_val[07]));
  PDIDGZ   PADIN_INFO08      (.PAD(info__write_val[08]), .C(w_info__write_val[08]));
  PDIDGZ   PADIN_INFO09      (.PAD(info__write_val[09]), .C(w_info__write_val[09]));
  PDIDGZ   PADIN_INFO10      (.PAD(info__write_val[10]), .C(w_info__write_val[10]));
  PDIDGZ   PADIN_INFO11      (.PAD(info__write_val[11]), .C(w_info__write_val[11]));
  PDIDGZ   PADIN_INFO12      (.PAD(info__write_val[12]), .C(w_info__write_val[12]));
  PDIDGZ   PADIN_INFO13      (.PAD(info__write_val[13]), .C(w_info__write_val[13]));
  PDIDGZ   PADIN_INFO14      (.PAD(info__write_val[14]), .C(w_info__write_val[14]));
  PDIDGZ   PADIN_INFO15      (.PAD(info__write_val[15]), .C(w_info__write_val[15]));
  PDIDGZ   PADIN_INFO16      (.PAD(info__write_val[16]), .C(w_info__write_val[16]));
  PDIDGZ   PADIN_INFO17      (.PAD(info__write_val[17]), .C(w_info__write_val[17]));
  PDIDGZ   PADIN_INFO18      (.PAD(info__write_val[18]), .C(w_info__write_val[18]));
  PDIDGZ   PADIN_INFO19      (.PAD(info__write_val[19]), .C(w_info__write_val[19]));
  PDIDGZ   PADIN_INFO20      (.PAD(info__write_val[20]), .C(w_info__write_val[20]));
  PDIDGZ   PADIN_INFO21      (.PAD(info__write_val[21]), .C(w_info__write_val[21]));
  PDIDGZ   PADIN_INFO22      (.PAD(info__write_val[22]), .C(w_info__write_val[22]));
  PDIDGZ   PADIN_INFO23      (.PAD(info__write_val[23]), .C(w_info__write_val[23]));
  PDIDGZ   PADIN_INFO24      (.PAD(info__write_val[24]), .C(w_info__write_val[24]));
  PDIDGZ   PADIN_INFO25      (.PAD(info__write_val[25]), .C(w_info__write_val[25]));
  PDIDGZ   PADIN_INFO26      (.PAD(info__write_val[26]), .C(w_info__write_val[26]));
  PDIDGZ   PADIN_INFO27      (.PAD(info__write_val[27]), .C(w_info__write_val[27]));
  PDIDGZ   PADIN_INFO28      (.PAD(info__write_val[28]), .C(w_info__write_val[28]));
  PDIDGZ   PADIN_INFO29      (.PAD(info__write_val[29]), .C(w_info__write_val[29]));
  PDIDGZ   PADIN_INFO30      (.PAD(info__write_val[30]), .C(w_info__write_val[30]));
  PDIDGZ   PADIN_INFO31      (.PAD(info__write_val[31]), .C(w_info__write_val[31]));
  PDIDGZ   PADIN_INFO32      (.PAD(info__write_val[32]), .C(w_info__write_val[32]));
  PDIDGZ   PADIN_INFO33      (.PAD(info__write_val[33]), .C(w_info__write_val[33]));
  PDIDGZ   PADIN_INFO34      (.PAD(info__write_val[34]), .C(w_info__write_val[34]));
  PDIDGZ   PADIN_INFO35      (.PAD(info__write_val[35]), .C(w_info__write_val[35]));
  PDIDGZ   PADIN_INFO36      (.PAD(info__write_val[36]), .C(w_info__write_val[36]));
  PDIDGZ   PADIN_INFO37      (.PAD(info__write_val[37]), .C(w_info__write_val[37]));
  PDIDGZ   PADIN_INFO38      (.PAD(info__write_val[38]), .C(w_info__write_val[38]));
  PDIDGZ   PADIN_INFO39      (.PAD(info__write_val[39]), .C(w_info__write_val[39]));
  PDIDGZ   PADIN_INFO40      (.PAD(info__write_val[40]), .C(w_info__write_val[40]));
  PDIDGZ   PADIN_INFO41      (.PAD(info__write_val[41]), .C(w_info__write_val[41]));
  PDIDGZ   PADIN_INFO42      (.PAD(info__write_val[42]), .C(w_info__write_val[42]));
  PDIDGZ   PADIN_INFO43      (.PAD(info__write_val[43]), .C(w_info__write_val[43]));
  PDIDGZ   PADIN_INFO44      (.PAD(info__write_val[44]), .C(w_info__write_val[44]));
  PDIDGZ   PADIN_INFO45      (.PAD(info__write_val[45]), .C(w_info__write_val[45]));
 
  PDIDGZ   PADIN_LEVELS00      (.PAD(levels__write_val[00]), .C(w_levels__write_val[00]));
  PDIDGZ   PADIN_LEVELS01      (.PAD(levels__write_val[01]), .C(w_levels__write_val[01]));
  PDIDGZ   PADIN_LEVELS02      (.PAD(levels__write_val[02]), .C(w_levels__write_val[02]));
  PDIDGZ   PADIN_LEVELS03      (.PAD(levels__write_val[03]), .C(w_levels__write_val[03]));
  PDIDGZ   PADIN_LEVELS04      (.PAD(levels__write_val[04]), .C(w_levels__write_val[04]));
  PDIDGZ   PADIN_LEVELS05      (.PAD(levels__write_val[05]), .C(w_levels__write_val[05]));
  PDIDGZ   PADIN_LEVELS06      (.PAD(levels__write_val[06]), .C(w_levels__write_val[06]));
  PDIDGZ   PADIN_LEVELS07      (.PAD(levels__write_val[07]), .C(w_levels__write_val[07]));
  PDIDGZ   PADIN_LEVELS08      (.PAD(levels__write_val[08]), .C(w_levels__write_val[08]));
  PDIDGZ   PADIN_LEVELS09      (.PAD(levels__write_val[09]), .C(w_levels__write_val[09]));
  PDIDGZ   PADIN_LEVELS10      (.PAD(levels__write_val[10]), .C(w_levels__write_val[10]));
  PDIDGZ   PADIN_LEVELS11      (.PAD(levels__write_val[11]), .C(w_levels__write_val[11]));
  PDIDGZ   PADIN_LEVELS12      (.PAD(levels__write_val[12]), .C(w_levels__write_val[12]));
  PDIDGZ   PADIN_LEVELS13      (.PAD(levels__write_val[13]), .C(w_levels__write_val[13]));
  PDIDGZ   PADIN_LEVELS14      (.PAD(levels__write_val[14]), .C(w_levels__write_val[14]));
  PDIDGZ   PADIN_LEVELS15      (.PAD(levels__write_val[15]), .C(w_levels__write_val[15]));
  PDIDGZ   PADIN_LEVELS16      (.PAD(levels__write_val[16]), .C(w_levels__write_val[16]));
  PDIDGZ   PADIN_LEVELS17      (.PAD(levels__write_val[17]), .C(w_levels__write_val[17]));
  PDIDGZ   PADIN_LEVELS18      (.PAD(levels__write_val[18]), .C(w_levels__write_val[18]));
  PDIDGZ   PADIN_LEVELS19      (.PAD(levels__write_val[19]), .C(w_levels__write_val[19]));
  PDIDGZ   PADIN_LEVELS20      (.PAD(levels__write_val[20]), .C(w_levels__write_val[20]));
  PDIDGZ   PADIN_LEVELS21      (.PAD(levels__write_val[21]), .C(w_levels__write_val[21]));
  PDIDGZ   PADIN_LEVELS22      (.PAD(levels__write_val[22]), .C(w_levels__write_val[22]));
  PDIDGZ   PADIN_LEVELS23      (.PAD(levels__write_val[23]), .C(w_levels__write_val[23]));
  PDIDGZ   PADIN_LEVELS24      (.PAD(levels__write_val[24]), .C(w_levels__write_val[24]));
  PDIDGZ   PADIN_LEVELS25      (.PAD(levels__write_val[25]), .C(w_levels__write_val[25]));
  PDIDGZ   PADIN_LEVELS26      (.PAD(levels__write_val[26]), .C(w_levels__write_val[26]));
  PDIDGZ   PADIN_LEVELS27      (.PAD(levels__write_val[27]), .C(w_levels__write_val[27]));
  PDIDGZ   PADIN_LEVELS28      (.PAD(levels__write_val[28]), .C(w_levels__write_val[28]));
  PDIDGZ   PADIN_LEVELS29      (.PAD(levels__write_val[29]), .C(w_levels__write_val[29]));
  PDIDGZ   PADIN_LEVELS30      (.PAD(levels__write_val[30]), .C(w_levels__write_val[30]));
  PDIDGZ   PADIN_LEVELS31      (.PAD(levels__write_val[31]), .C(w_levels__write_val[31]));
  PDIDGZ   PADIN_LEVELS32      (.PAD(levels__write_val[32]), .C(w_levels__write_val[32]));
  PDIDGZ   PADIN_LEVELS33      (.PAD(levels__write_val[33]), .C(w_levels__write_val[33]));
  PDIDGZ   PADIN_LEVELS34      (.PAD(levels__write_val[34]), .C(w_levels__write_val[34]));
  PDIDGZ   PADIN_LEVELS35      (.PAD(levels__write_val[35]), .C(w_levels__write_val[35]));
  PDIDGZ   PADIN_LEVELS36      (.PAD(levels__write_val[36]), .C(w_levels__write_val[36]));
  PDIDGZ   PADIN_LEVELS37      (.PAD(levels__write_val[37]), .C(w_levels__write_val[37]));
  PDIDGZ   PADIN_LEVELS38      (.PAD(levels__write_val[38]), .C(w_levels__write_val[38]));
  PDIDGZ   PADIN_LEVELS39      (.PAD(levels__write_val[39]), .C(w_levels__write_val[39]));
  PDIDGZ   PADIN_LEVELS40      (.PAD(levels__write_val[40]), .C(w_levels__write_val[40]));
  PDIDGZ   PADIN_LEVELS41      (.PAD(levels__write_val[41]), .C(w_levels__write_val[41]));
  PDIDGZ   PADIN_LEVELS42      (.PAD(levels__write_val[42]), .C(w_levels__write_val[42]));
  PDIDGZ   PADIN_LEVELS43      (.PAD(levels__write_val[43]), .C(w_levels__write_val[43]));
  PDIDGZ   PADIN_LEVELS44      (.PAD(levels__write_val[44]), .C(w_levels__write_val[44]));
  PDIDGZ   PADIN_LEVELS45      (.PAD(levels__write_val[45]), .C(w_levels__write_val[45]));
  PDIDGZ   PADIN_LEVELS46      (.PAD(levels__write_val[46]), .C(w_levels__write_val[46]));
  PDIDGZ   PADIN_LEVELS47      (.PAD(levels__write_val[47]), .C(w_levels__write_val[47]));
  PDIDGZ   PADIN_LEVELS48      (.PAD(levels__write_val[48]), .C(w_levels__write_val[48]));
  PDIDGZ   PADIN_LEVELS49      (.PAD(levels__write_val[49]), .C(w_levels__write_val[49]));
  PDIDGZ   PADIN_LEVELS50      (.PAD(levels__write_val[50]), .C(w_levels__write_val[50]));
  PDIDGZ   PADIN_LEVELS51      (.PAD(levels__write_val[51]), .C(w_levels__write_val[51]));
  PDIDGZ   PADIN_LEVELS52      (.PAD(levels__write_val[52]), .C(w_levels__write_val[52]));
  PDIDGZ   PADIN_LEVELS53      (.PAD(levels__write_val[53]), .C(w_levels__write_val[53]));
  PDIDGZ   PADIN_LEVELS54      (.PAD(levels__write_val[54]), .C(w_levels__write_val[54]));
  PDIDGZ   PADIN_LEVELS55      (.PAD(levels__write_val[55]), .C(w_levels__write_val[55]));
  PDIDGZ   PADIN_LEVELS56      (.PAD(levels__write_val[56]), .C(w_levels__write_val[56]));
  PDIDGZ   PADIN_LEVELS57      (.PAD(levels__write_val[57]), .C(w_levels__write_val[57]));
  PDIDGZ   PADIN_LEVELS58      (.PAD(levels__write_val[58]), .C(w_levels__write_val[58]));
  PDIDGZ   PADIN_LEVELS59      (.PAD(levels__write_val[59]), .C(w_levels__write_val[59]));
  PDIDGZ   PADIN_LEVELS60      (.PAD(levels__write_val[60]), .C(w_levels__write_val[60]));
  PDIDGZ   PADIN_LEVELS61      (.PAD(levels__write_val[61]), .C(w_levels__write_val[61]));
  PDIDGZ   PADIN_LEVELS62      (.PAD(levels__write_val[62]), .C(w_levels__write_val[62]));
  PDIDGZ   PADIN_LEVELS63      (.PAD(levels__write_val[63]), .C(w_levels__write_val[63]));
  
  PDIDGZ   PADIN_SCALES00      (.PAD(initializeCustomScales__write_val[00]), .C(w_initializeCustomScales__write_val[00]));
  PDIDGZ   PADIN_SCALES01      (.PAD(initializeCustomScales__write_val[01]), .C(w_initializeCustomScales__write_val[01]));
  PDIDGZ   PADIN_SCALES02      (.PAD(initializeCustomScales__write_val[02]), .C(w_initializeCustomScales__write_val[02]));
  PDIDGZ   PADIN_SCALES03      (.PAD(initializeCustomScales__write_val[03]), .C(w_initializeCustomScales__write_val[03]));
  PDIDGZ   PADIN_SCALES04      (.PAD(initializeCustomScales__write_val[04]), .C(w_initializeCustomScales__write_val[04]));
  PDIDGZ   PADIN_SCALES05      (.PAD(initializeCustomScales__write_val[05]), .C(w_initializeCustomScales__write_val[05]));
  PDIDGZ   PADIN_SCALES06      (.PAD(initializeCustomScales__write_val[06]), .C(w_initializeCustomScales__write_val[06]));
  PDIDGZ   PADIN_SCALES07      (.PAD(initializeCustomScales__write_val[07]), .C(w_initializeCustomScales__write_val[07]));
  PDIDGZ   PADIN_SCALES08      (.PAD(initializeCustomScales__write_val[08]), .C(w_initializeCustomScales__write_val[08]));
  PDIDGZ   PADIN_SCALES09      (.PAD(initializeCustomScales__write_val[09]), .C(w_initializeCustomScales__write_val[09]));
  PDIDGZ   PADIN_SCALES10      (.PAD(initializeCustomScales__write_val[10]), .C(w_initializeCustomScales__write_val[10]));
  PDIDGZ   PADIN_SCALES11      (.PAD(initializeCustomScales__write_val[11]), .C(w_initializeCustomScales__write_val[11]));
  PDIDGZ   PADIN_SCALES12      (.PAD(initializeCustomScales__write_val[12]), .C(w_initializeCustomScales__write_val[12]));
  PDIDGZ   PADIN_SCALES13      (.PAD(initializeCustomScales__write_val[13]), .C(w_initializeCustomScales__write_val[13]));
  PDIDGZ   PADIN_SCALES14      (.PAD(initializeCustomScales__write_val[14]), .C(w_initializeCustomScales__write_val[14]));
  PDIDGZ   PADIN_SCALES15      (.PAD(initializeCustomScales__write_val[15]), .C(w_initializeCustomScales__write_val[15]));
  PDIDGZ   PADIN_SCALES16      (.PAD(initializeCustomScales__write_val[16]), .C(w_initializeCustomScales__write_val[16]));
  PDIDGZ   PADIN_SCALES17      (.PAD(initializeCustomScales__write_val[17]), .C(w_initializeCustomScales__write_val[17]));
  PDIDGZ   PADIN_SCALES18      (.PAD(initializeCustomScales__write_val[18]), .C(w_initializeCustomScales__write_val[18]));
  PDIDGZ   PADIN_SCALES19      (.PAD(initializeCustomScales__write_val[19]), .C(w_initializeCustomScales__write_val[19]));
  PDIDGZ   PADIN_SCALES20      (.PAD(initializeCustomScales__write_val[20]), .C(w_initializeCustomScales__write_val[20]));
  PDIDGZ   PADIN_SCALES21      (.PAD(initializeCustomScales__write_val[21]), .C(w_initializeCustomScales__write_val[21]));
  PDIDGZ   PADIN_SCALES22      (.PAD(initializeCustomScales__write_val[22]), .C(w_initializeCustomScales__write_val[22]));
  PDIDGZ   PADIN_SCALES23      (.PAD(initializeCustomScales__write_val[23]), .C(w_initializeCustomScales__write_val[23]));
  PDIDGZ   PADIN_SCALES24      (.PAD(initializeCustomScales__write_val[24]), .C(w_initializeCustomScales__write_val[24]));
  PDIDGZ   PADIN_SCALES25      (.PAD(initializeCustomScales__write_val[25]), .C(w_initializeCustomScales__write_val[25]));
  PDIDGZ   PADIN_SCALES26      (.PAD(initializeCustomScales__write_val[26]), .C(w_initializeCustomScales__write_val[26]));
  PDIDGZ   PADIN_SCALES27      (.PAD(initializeCustomScales__write_val[27]), .C(w_initializeCustomScales__write_val[27]));
  PDIDGZ   PADIN_SCALES28      (.PAD(initializeCustomScales__write_val[28]), .C(w_initializeCustomScales__write_val[28]));
  PDIDGZ   PADIN_SCALES29      (.PAD(initializeCustomScales__write_val[29]), .C(w_initializeCustomScales__write_val[29]));
  PDIDGZ   PADIN_SCALES30      (.PAD(initializeCustomScales__write_val[30]), .C(w_initializeCustomScales__write_val[30]));
  PDIDGZ   PADIN_SCALES31      (.PAD(initializeCustomScales__write_val[31]), .C(w_initializeCustomScales__write_val[31]));
  PDIDGZ   PADIN_SCALES32      (.PAD(initializeCustomScales__write_val[32]), .C(w_initializeCustomScales__write_val[32]));
  PDIDGZ   PADIN_SCALES33      (.PAD(initializeCustomScales__write_val[33]), .C(w_initializeCustomScales__write_val[33]));
  PDIDGZ   PADIN_SCALES34      (.PAD(initializeCustomScales__write_val[34]), .C(w_initializeCustomScales__write_val[34]));
  PDIDGZ   PADIN_SCALES35      (.PAD(initializeCustomScales__write_val[35]), .C(w_initializeCustomScales__write_val[35]));
  PDIDGZ   PADIN_SCALES36      (.PAD(initializeCustomScales__write_val[36]), .C(w_initializeCustomScales__write_val[36]));
  PDIDGZ   PADIN_SCALES37      (.PAD(initializeCustomScales__write_val[37]), .C(w_initializeCustomScales__write_val[37]));
  PDIDGZ   PADIN_SCALES38      (.PAD(initializeCustomScales__write_val[38]), .C(w_initializeCustomScales__write_val[38]));
  PDIDGZ   PADIN_SCALES39      (.PAD(initializeCustomScales__write_val[39]), .C(w_initializeCustomScales__write_val[39]));
 
  PDO08CDG PADOUT_RESIDUES_READ00     (.PAD(residues__read[00]      ), .I(w_residues__read[00])      );
  PDO08CDG PADOUT_RESIDUES_READ01     (.PAD(residues__read[01]      ), .I(w_residues__read[01])      );
  PDO08CDG PADOUT_RESIDUES_READ02     (.PAD(residues__read[02]      ), .I(w_residues__read[02])      );
  PDO08CDG PADOUT_RESIDUES_READ03     (.PAD(residues__read[03]      ), .I(w_residues__read[03])      );
  PDO08CDG PADOUT_RESIDUES_READ04     (.PAD(residues__read[04]      ), .I(w_residues__read[04])      );
  PDO08CDG PADOUT_RESIDUES_READ05     (.PAD(residues__read[05]      ), .I(w_residues__read[05])      );
  PDO08CDG PADOUT_RESIDUES_READ06     (.PAD(residues__read[06]      ), .I(w_residues__read[06])      );
  PDO08CDG PADOUT_RESIDUES_READ07     (.PAD(residues__read[07]      ), .I(w_residues__read[07])      );
  PDO08CDG PADOUT_RESIDUES_READ08     (.PAD(residues__read[08]      ), .I(w_residues__read[08])      );
  PDO08CDG PADOUT_RESIDUES_READ09     (.PAD(residues__read[09]      ), .I(w_residues__read[09])      );
  PDO08CDG PADOUT_RESIDUES_READ10     (.PAD(residues__read[10]      ), .I(w_residues__read[10])      );
  PDO08CDG PADOUT_RESIDUES_READ11     (.PAD(residues__read[11]      ), .I(w_residues__read[11])      );
  PDO08CDG PADOUT_RESIDUES_READ12     (.PAD(residues__read[12]      ), .I(w_residues__read[12])      );
  PDO08CDG PADOUT_RESIDUES_READ13     (.PAD(residues__read[13]      ), .I(w_residues__read[13])      );
  PDO08CDG PADOUT_RESIDUES_READ14     (.PAD(residues__read[14]      ), .I(w_residues__read[14])      );
  PDO08CDG PADOUT_RESIDUES_READ15     (.PAD(residues__read[15]      ), .I(w_residues__read[15])      );
  PDO08CDG PADOUT_RESIDUES_READ16     (.PAD(residues__read[16]      ), .I(w_residues__read[16])      );
  PDO08CDG PADOUT_RESIDUES_READ17     (.PAD(residues__read[17]      ), .I(w_residues__read[17])      );
  PDO08CDG PADOUT_RESIDUES_READ18     (.PAD(residues__read[18]      ), .I(w_residues__read[18])      );
  PDO08CDG PADOUT_RESIDUES_READ19     (.PAD(residues__read[19]      ), .I(w_residues__read[19])      );
  PDO08CDG PADOUT_RESIDUES_READ20     (.PAD(residues__read[20]      ), .I(w_residues__read[20])      );
  PDO08CDG PADOUT_RESIDUES_READ21     (.PAD(residues__read[21]      ), .I(w_residues__read[21])      );
  PDO08CDG PADOUT_RESIDUES_READ22     (.PAD(residues__read[22]      ), .I(w_residues__read[22])      );
  PDO08CDG PADOUT_RESIDUES_READ23     (.PAD(residues__read[23]      ), .I(w_residues__read[23])      );
  PDO08CDG PADOUT_RESIDUES_READ24     (.PAD(residues__read[24]      ), .I(w_residues__read[24])      );
  PDO08CDG PADOUT_RESIDUES_READ25     (.PAD(residues__read[25]      ), .I(w_residues__read[25])      );
  PDO08CDG PADOUT_RESIDUES_READ26     (.PAD(residues__read[26]      ), .I(w_residues__read[26])      );
  PDO08CDG PADOUT_RESIDUES_READ27     (.PAD(residues__read[27]      ), .I(w_residues__read[27])      );
  PDO08CDG PADOUT_RESIDUES_READ28     (.PAD(residues__read[28]      ), .I(w_residues__read[28])      );
  PDO08CDG PADOUT_RESIDUES_READ29     (.PAD(residues__read[29]      ), .I(w_residues__read[29])      );
  PDO08CDG PADOUT_RESIDUES_READ30     (.PAD(residues__read[30]      ), .I(w_residues__read[30])      );
  PDO08CDG PADOUT_RESIDUES_READ31     (.PAD(residues__read[31]      ), .I(w_residues__read[31])      );
  PDO08CDG PADOUT_RESIDUES_READ32     (.PAD(residues__read[32]      ), .I(w_residues__read[32])      );
  PDO08CDG PADOUT_RESIDUES_READ33     (.PAD(residues__read[33]      ), .I(w_residues__read[33])      );
  PDO08CDG PADOUT_RESIDUES_READ34     (.PAD(residues__read[34]      ), .I(w_residues__read[34])      );
  PDO08CDG PADOUT_RESIDUES_READ35     (.PAD(residues__read[35]      ), .I(w_residues__read[35])      );
  
  PVSS1DGZ PAD_VSS1(); 
  PVDD1DGZ PAD_VDD1(); 
  PVDD1DGZ PAD_VDD2(); 
  PVSS1DGZ PAD_VSS2(); 
  PVSS1DGZ PAD_VSS3(); 
  PVDD1DGZ PAD_VDD3(); 
  PVDD1DGZ PAD_VDD4(); 
  PVSS1DGZ PAD_VSS4(); 
  PVSS2DGZ PAD_IOVSS1(); 
  PVSS2DGZ PAD_IOVSS2(); 
  PVDD2DGZ PAD_IOVDD1(); 
  PVDD2DGZ PAD_IOVDD2(); 
  PVDD2DGZ PAD_IOVDD3(); 
  PVDD2DGZ PAD_IOVDD4(); 
  PVSS1DGZ PAD_VSS5(); 
  PVDD1DGZ PAD_VDD5(); 
  PVDD1DGZ PAD_VDD6(); 
  PVSS1DGZ PAD_VSS6(); 
  PVSS2DGZ PAD_IOVSS3(); 
  PVSS2DGZ PAD_IOVSS4(); 
  PVDD2DGZ PAD_IOVDD5(); 
  PVDD2DGZ PAD_IOVDD6(); 
  PVSS1DGZ PAD_VSS7(); 
  PVDD1DGZ PAD_VDD7(); 
  PVDD1DGZ PAD_VDD8(); 
  PVSS1DGZ PAD_VSS8(); 
  PVSS2DGZ PAD_IOVSS5(); 
  PVSS2DGZ PAD_IOVSS6(); 
  PVDD2DGZ PAD_IOVDD7(); 
  PVDD2DGZ PAD_IOVDD8(); 
  PVSS2DGZ PAD_IOVSS7(); 
  PVSS2DGZ PAD_IOVSS8(); 
  PVDD2DGZ PAD_IOVDD9(); 
  PVDD2DGZ PAD_IOVDD10(); 
  PVSS2DGZ PAD_IOVSS9 (); 
  PVSS2DGZ PAD_IOVSS10(); 
  PVDD2DGZ PAD_IOVDD11(); 
  PVDD2POC PAD_IOVDD12(); 
endmodule
