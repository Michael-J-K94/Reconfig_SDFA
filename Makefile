SRC_DIR = verilog/src
STD_CELLS = /mms/kits/TSMC_mosis/CRN65LP/TSMCHOME/digital/Front_End/verilog/tcbn65lp_200a/tcbn65lp.v
DPAD = /mms/kits/TSMC_mosis/CRN65LP/TSMCHOME/digital/Front_End/verilog/tpdn65lpnv2od3_140b/tpdn65lpnv2od3.v
TESTBENCH = verilog/tb/tb_top_init.v


SIM_FILES = verilog/src/*.v


#SIM_SYN_FILES = syn/top.syn.v verilog/src/ts6n65lplla200x70m2s_210a.v
#SIM_APR_FILES = 


#SIM_BLOCK_TEST_FILES = $(addprefix $(SRC_DIR)/, \				 
#)

SIM_DIR = sim
OUT_DIR = outputs
VV         = vcs
VVOPTS     = -j8 -o $@ +v2k +vc +define+DEBUG -debug_pp -sverilog  -timescale=1ns/1ps +vcs+lic+wait +multisource_int_delays                     \
			             +neg_tchk +lint=TFIPC-L +incdir+$(VERIF) +plusarg_save +overlap +sdfverbose -full64 -cc gcc +libext+.v+.vlib+.vh
#VVOPTS     = -j8 -o $@ +v2k +vc +define+DEBUG -debug_pp -sverilog  -timescale=1ns/1ps +vcs+lic+wait +multisource_int_delays                     \
			             +neg_tchk +lint=TFIPC-L +incdir+$(VERIF) +plusarg_save +overlap +warn=noSDFCOM_UHICD,noSDFCOM_IWSBA,noSDFCOM_IANE,noSDFCOM_PONF -full64 -cc gcc +libext+.v+.vlib+.vh
ifdef WAVES
	VVOPTS += +define+DUMP_VCD=1 +memcbk +vcs+dumparrays +sdfverbose
endif

ifdef GUI
	VVOPTS += -gui
endif


sim_top:
	$(VV) $(VVOPTS) $(SIM_FILES) $(TESTBENCH); ./$@
	echo $(SIM_FILES)
	rm -rf sim_top*
	rm -rf csrc
	rm -rf ucli.key
	#mv -f ucli.key outputs/ucli.key
	#mv -f top.vpd outputs/top.vpd
	

sim_syn:
	$(VV) $(VVOPTS) +define+SYN=1 $(STD_CELLS) $(SIM_SYN_FILES) $(TESTTOP); ./$@ 
	rm -rf sim_syn*
	rm -rf csrc
	rename -f top.vpd top_syn.vpd
	mv -f top_syn.vpd outputs/
	renmae -f output.txt output_syn.txt output.txt
	mv -f output_syn.txt Goldenbrick/
	vimdiff Goldenbrick/output_syn.txt Goldenbrick/output_behavioral.txt

run_syn:
	cd syn; dc_shell -tcl_mode -xg_mode -f top.syn.tcl | tee output.txt

report_files:
	echo $(SIM_FILES);

clean:
	rm -rf *csrc 
	rm -rf *.log
	rm -rf *.txt




