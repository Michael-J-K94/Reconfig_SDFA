# Setup multi-cpu access
setMultiCpuUsage -acquireLicense 8 -localCpu 8

# Setup
set tsmchome /mms/kits/TSMC_mosis/CRN65LP/TSMCHOME
set sramhome /home/mmsjw/2018TapeOut/lib
set synhome /home/mmsjw/2018TapeOut/syn
set lefhome /home/mmsjw/2018TapeOut/lef


set verilog_toplevel top_padded
set verilog_src [list $synhome/top.resetn.syn.v pre_layout/top_padded.v ]
set lef_files [list $tsmchome/digital/Back_End/lef/tcbn65lp_200a/lef/tcbn65lp_9lmT2.lef \
        $tsmchome/digital/Back_End/lef/tpan65lpnv2od3_200a/mt_2/9lm/lef/antenna_9lm.lef \
        $tsmchome/digital/Back_End/lef/tpan65lpnv2od3_200a/mt_2/9lm/lef/tpan65lpnv2od3_9lm.lef \
        $tsmchome/digital/Back_End/lef/tpdn65lpnv2od3_140b/mt_2/9lm/lef/antenna_9lm.lef \
        $lefhome/tpdn65lpnv2od3_9lm.lef \
		$lefhome/ts6n65lplla200x70m2s_210a_5m.lef \
        $lefhome/ts6n65lplla200x70m2s_210a.alef \
        $lefhome/tpbn65v_9lm.lef \
        $lefhome/ldo.lef      
]

set gnd_net [list VSS]
set pwr_net [list VDD_CORE CVDD DVDD]

set init_import_mode {-treatUndefinedCellAsBbox 0 -keepEmptyModule 1}
set init_top_cell $verilog_toplevel
set init_verilog $verilog_src
set init_design_netlisttype Verilog
set init_design_settop 1
set init_lef_file $lef_files
set init_gnd_net $gnd_net
set init_pwr_net $pwr_net
set init_mmmc_file {par_mmmc.tcl}
set init_io_file {pre_layout/top.io}
set init_assign_buffer 1
set init_design_uniquify 1
set dbgGPSAutoCellFunction 1

init_design



set_interactive_constraint_modes sys_con

setDontUse G* true
setDontUse L* true
setDontUse S* true
#setDontUse CK* true



#set_false_path -setup -from [remove_from_collection [all_inputs] {clk resetn}]
#set_false_path -setup -to [all_outputs]

#Relax constraints on Initialization - this will be run slowyly

#Maybe change this to BD_to_PAD?
#set_dont_touch {LC_to_PAD_*}

# Generate floorplan boundary
setDesignMode -process 65 -addPhysicalCell hier
setDrawView place
floorPlan -site core -d 3780 2865 70 10 70 70

#floorPlan -site core -d 3780 2865 100 100 100 100
#Add bondpads to instances
    


#Fill from big fillers...
#Fill from big fillers...
addIoFiller -cell PFILLER20	 -prefix PAD_FILLER -side w
addIoFiller -cell PFILLER10	 -prefix PAD_FILLER -side w
addIoFiller -cell PFILLER5	 -prefix PAD_FILLER -side w
addIoFiller -cell PFILLER1	 -prefix PAD_FILLER -side w
addIoFiller -cell PFILLER05	 -prefix PAD_FILLER -side w
addIoFiller -cell PFILLER0005	 -prefix PAD_FILLER -side w -fillAnyGap

addIoFiller -cell PFILLER20	 -prefix PAD_FILLER -side n
addIoFiller -cell PFILLER10	 -prefix PAD_FILLER -side n
addIoFiller -cell PFILLER5	 -prefix PAD_FILLER -side n
addIoFiller -cell PFILLER1	 -prefix PAD_FILLER -side n
addIoFiller -cell PFILLER05	 -prefix PAD_FILLER -side n

addIoFiller -cell PFILLER0005	 -prefix PAD_FILLER -side n -fillAnyGap

addIoFiller -cell PFILLER20	 -prefix PAD_FILLER -side e
addIoFiller -cell PFILLER10	 -prefix PAD_FILLER -side e
addIoFiller -cell PFILLER5	 -prefix PAD_FILLER -side e
addIoFiller -cell PFILLER1	 -prefix PAD_FILLER -side e
addIoFiller -cell PFILLER05	 -prefix PAD_FILLER -side e
addIoFiller -cell PFILLER0005	 -prefix PAD_FILLER -side e -fillAnyGap


#staggerBondPad -all -pattern i


globalNetConnect VDD_CORE -type pgpin -pin AVDD -inst PAD_POWER_VDD_CORE* -verbose
globalNetConnect VSS -type pgpin -pin AVSS -inst PAD_POWER_VSS* -verbose
globalNetConnect CVDD -type pgpin -pin CVDD -inst PADRING_CVDD* -verbose
globalNetConnect DVDD -type pgpin -pin DVDD -inst PADRING_DVDD* -verbose
globalNetConnect VSS -type pgpin -pin VSS -inst PADRING_VSS* -verbose

#globalNetConnect CVDD -type pgpin -pin OEN  -inst PAD_IN* -verbose
#globalNetConnect CVDD -type pgpin -pin IE -inst PAD_IN* -verbose
#globalNetConnect VSS -type pgpin -pin DS -inst PAD_IN* -verbose
#globalNetConnect VSS -type pgpin -pin I -inst PAD_IN* -verbose
#globalNetConnect VSS -type pgpin -pin PE -inst PAD_IN* -verbose

#globalNetConnect CVDD -type pgpin -pin DS -inst PAD_OUT* -verbose
#globalNetConnect VSS -type pgpin -pin OEN -inst PAD_OUT* -verbose
#globalNetConnect VSS -type pgpin -pin IE -inst PAD_OUT* -verbose
#globalNetConnect VSS -type pgpin -pin PE -inst PAD_OUT* -verbose

globalNetConnect CVDD -type tiehi -inst PAD_IN* -verbose
globalNetConnect VSS -type tielo -inst PAD_IN* -verbose
globalNetConnect CVDD -type tiehi -inst PAD_OUT* -verbose
globalNetConnect VSS -type tielo -inst PAD_OUT* -verbose

globalNetConnect CVDD -type tiehi -inst GH_CLK -verbose
globalNetConnect CVDD -type tiehi -inst GH_SWITCH -verbose
globalNetConnect VSS -type tielo -inst GH_CLK -verbose
globalNetConnect VSS -type tielo -inst GH_SWITCH -verbose


globalNetConnect VDD_CORE   -type pgpin -pin VDD        -verbose
globalNetConnect VSS        -type pgpin -pin VSS        -verbose
globalNetConnect VDD_CORE   -type tiehi -verbose
globalNetConnect VSS        -type tielo -verbose


applyGlobalNets



# Create power rings
setAddRingMode -stacked_via_top_layer M9 -stacked_via_bottom_layer M1
addRing \
    -around power_domain \
    -center 1 \
    -jog_distance 0.07 \
    -nets {VSS VDD_CORE CVDD } \
    -threshold 0.07 \
    -layer {top M7 bottom M7 left M6 right M6} \
    -width 12 \
    -spacing 5 \
    -offset 0.07

break
#----------------------------------RAM PLACEMENT 2---------------------------

set x_start 240
set y_start 30.50
set x_spacing 266.32
set y_spacing 126
set layer_spacing 270
set middle_spacing 109.8

for {set i 0} {$i < 4} {incr i} {
    for {set j 0} {$j < 10} {incr j} {
        set x [expr {$x_start + $i * $x_spacing }]
        set y [expr {$y_start + $j * $y_spacing }]
        set ram_num $i\_$j
        placeInstance dut/hiddenlayer1/ram$ram_num $x $y R0 
        addHaloToBlock 1 1 1 1 dut/hiddenlayer1/ram$ram_num
        
    }
}

for {set i 0} {$i < 4} {incr i} {
    for {set j 10} {$j < 20} {incr j} {
        set x [expr {$x_start + $i * $x_spacing }]
        set y [expr {$y_start + $j * $y_spacing + $middle_spacing }]
        set ram_num $i\_$j
        placeInstance dut/hiddenlayer1/ram$ram_num $x $y R0 
        addHaloToBlock 1 1 1 1 dut/hiddenlayer1/ram$ram_num
   
    }
}


for {set i 0} {$i < 4} {incr i} {
    for {set j 20} {$j < 30} {incr j} {
        set x [expr {$x_start + $x_spacing + $i * $x_spacing + 3* $x_spacing}]
        set y [expr {$y_start + $j * $y_spacing - 20*$y_spacing }]
        set ram_num $i\_$j
        placeInstance dut/hiddenlayer1/ram$ram_num $x $y R0 
        addHaloToBlock 1 1 1 1 dut/hiddenlayer1/ram$ram_num

    }
}

for {set i 0} {$i < 4} {incr i} {
    for {set j 30} {$j < 40} {incr j} {
        set x [expr {$x_start + $x_spacing + $i * $x_spacing + 3* $x_spacing}]
        set y [expr {$y_start + $j * $y_spacing - 20*$y_spacing + $middle_spacing }]
        set ram_num $i\_$j
        placeInstance dut/hiddenlayer1/ram$ram_num $x $y R0 
        addHaloToBlock 1 1 1 1 dut/hiddenlayer1/ram$ram_num

    }
}


set h2_start [expr {$x_start + $x_spacing * 8 + $layer_spacing}]
for {set i 0} {$i<10} {incr i} {
    set x $h2_start
    set y [expr {$y_start + $i*$y_spacing}]
    placeInstance dut/hiddenlayer2/ram$i $x $y R0
    addHaloToBlock 1 1 1 1 dut/hiddenlayer2/ram$i

}
for {set i 10} {$i<20} {incr i} {
    set x $h2_start
    set y [expr {$y_start + $i*$y_spacing + $middle_spacing} ]
    placeInstance dut/hiddenlayer2/ram$i $x $y R0
    addHaloToBlock 1 1 1 1 dut/hiddenlayer2/ram$i

}

for {set i 20} {$i<30} {incr i} {
    set x [expr {$h2_start + $x_spacing} ]
    set y [expr {$y_start + $i*$y_spacing - 20*$y_spacing} ]
    placeInstance dut/hiddenlayer2/ram$i $x $y R0
    addHaloToBlock 1 1 1 1 dut/hiddenlayer2/ram$i

}
for {set i 30} {$i<40} {incr i} {
    set x [expr {$h2_start + $x_spacing} ]
    set y [expr {$y_start + $i*$y_spacing - 20*$y_spacing + $middle_spacing} ]
    placeInstance dut/hiddenlayer2/ram$i $x $y R0
    addHaloToBlock 1 1 1 1 dut/hiddenlayer2/ram$i

}

set o_start [expr {$h2_start + $x_spacing * 2}]
set oy1 [expr {$y_start + 10*$y_spacing + $middle_spacing}]
set oy2 [expr {$y_start + 11*$y_spacing + $middle_spacing}]
placeInstance dut/outputlayer/ram0 $o_start $oy1 R0
addHaloToBlock 1 1 1 1 dut/outputlayer/ram0

placeInstance dut/outputlayer/ram1 $o_start $oy2 R0
addHaloToBlock 1 1 1 1 dut/outputlayer/ram1



placeInstance ldoblock 3340 240

addHaloToBlock 1 1 1 1 ldoblock





set pad_list [list \
PAD_POWER_VDD_CORE_0 \
PAD_POWER_VDD_CORE_1  \
PAD_POWER_VDD_CORE_2  \
PAD_POWER_VDD_CORE_3  \
PAD_POWER_VSS_1  \
PAD_POWER_VSS_2  \
PAD_POWER_VSS_3  \
PAD_POWER_VSS_0 \
PADRING_CVDD_0  \
PADRING_CVDD_1  \
PADRING_CVDD_2  \
PADRING_CVDD_3  \
]



#createPlaceBlockage -name LDOBLOCKAGE -box {3380 10 3590 420} -type hard




#SROUTE OPTIONS CHANGE? 
#sroute -area {20 0 3760 2845} -connect { padPin }  -layerChangeRange { M1 M8 } -padPinPortConnect { allGeom } -crossoverViaLayerRange { M1 M8 } -allowLayerChange 1 -targetViaLayerRange { M1 M8 } -nets { VSS CVDD VDD_CORE } -padPinLayerRange {1 9}

sroute  -connect { corePin } -layerChangeRange { M1 M8 } -allowJogging 1 -crossoverViaLayerRange { M1 M8 } -allowLayerChange 1 -targetViaLayerRange { M1 M8   } -nets { VSS VDD_CORE }
sroute -area {20 0 3760 2845} -connect { padPin }  -layerChangeRange { M1 M8 } -padPinPortConnect { allGeom } -crossoverViaLayerRange { M1 M8 } -allowLayerChange 1 -targetViaLayerRange { M1 M8 } -nets { VSS CVDD VDD_CORE } -padPinLayerRange {1 9}




#

#----------------------------------Power Stripes for RAM--------------------------------------------------

setAddStripeMode -stacked_via_top_layer M10 -stacked_via_bottom_layer M1 -same_sized_stack_vias true -split_vias true -orthogonal_only false
set VDDh_start [expr {$y_start + 9.22}]
set VSSh_start [expr {$y_start + 13.82}]

set VDDv_start_a_h1 [expr {$x_start + 119.68}]
set VSSv_start_a_h1 [expr {$x_start + 115.08}]

set VDDv_start_b_h1 [expr {$x_start + 142.64}]
set VSSv_start_b_h1 [expr {$x_start + 147.24}]

set VDDv_start_a_h2 [expr {$h2_start + 119.68}]
set VSSv_start_a_h2 [expr {$h2_start + 115.08}]

set VDDv_start_b_h2 [expr {$h2_start + 142.64}]
set VSSv_start_b_h2 [expr {$h2_start + 147.24}]

set h1_end [expr {$x_start + 8*$x_spacing}]
set h2end [expr {$h2_start + 3*$x_spacing}]


#Vertical Stipes for HL1 , part a
addStripe \
    -direction vertical \
    -layer M8 \
    -max_same_layer_jog_length 4 \
    -merge_stripes_value 0.07 \
    -nets {VSS VDD_CORE} \
    -padcore_ring_bottom_layer_limit M7 \
    -padcore_ring_top_layer_limit M8 \
    -set_to_set_distance $x_spacing \
    -spacing 0.6\
    -width 4 \
    -start_x $VSSv_start_a_h1 \
    -stop_x $h1_end

addStripe \
    -direction vertical \
    -layer M8 \
    -max_same_layer_jog_length 4 \
    -merge_stripes_value 0.07 \
    -nets {VDD_CORE VSS} \
    -padcore_ring_bottom_layer_limit M7 \
    -padcore_ring_top_layer_limit M8 \
    -set_to_set_distance $x_spacing \
    -spacing 0.6\
    -width 4 \
    -start_x $VDDv_start_b_h1 \
    -stop_x $h1_end

addStripe \
    -direction vertical \
    -layer M8 \
    -max_same_layer_jog_length 4 \
    -merge_stripes_value 0.07 \
    -nets {VSS VDD_CORE} \
    -padcore_ring_bottom_layer_limit M7 \
    -padcore_ring_top_layer_limit M8 \
    -set_to_set_distance $x_spacing \
    -spacing 0.6\
    -width 4 \
    -start_x $VSSv_start_a_h2 \
    -stop_x 3500

addStripe \
    -direction vertical \
    -layer M8 \
    -max_same_layer_jog_length 4 \
    -merge_stripes_value 0.07 \
    -nets {VDD_CORE VSS} \
    -padcore_ring_bottom_layer_limit M7 \
    -padcore_ring_top_layer_limit M8 \
    -set_to_set_distance $x_spacing \
    -spacing 0.6\
    -width 4 \
    -start_x $VDDv_start_b_h2 \
    -stop_x $h2end


set h1end [expr {$x_start + 8*$x_spacing+100}]
set h2end [expr {$h2_start + 3*$x_spacing}]
set h2s [expr {$h2_start - 50}]
set distance [expr {($h2_start - $h1_end)/2}]
addStripe \
    -direction vertical \
    -layer M8 \
    -max_same_layer_jog_length 4 \
    -merge_stripes_value 0.07 \
    -nets {VDD_CORE VSS} \
    -padcore_ring_bottom_layer_limit M7 \
    -padcore_ring_top_layer_limit M8 \
    -set_to_set_distance $distance \
    -spacing 20 \
    -width 10 \
    -start_x 2500 \
    -stop_x 2600










#Add all horizontal Power Stripes
set VDDh_stop [expr {$y_start + 10 * $y_spacing}]
set VDDh2_start [expr {$VDDh_start + 10 * $y_spacing + $middle_spacing}]

setAddStripeMode -stacked_via_top_layer M10 -stacked_via_bottom_layer M6 -same_sized_stack_vias true -split_vias true -orthogonal_only false


addStripe \
    -direction horizontal \
    -layer M9 \
    -max_same_layer_jog_length 4 \
    -merge_stripes_value 0.07 \
    -nets {VDD_CORE VSS} \
    -padcore_ring_bottom_layer_limit M7 \
    -padcore_ring_top_layer_limit M8 \
    -set_to_set_distance $y_spacing \
    -spacing 20\
    -width 10 \
    -start_y 100 \
    -stop_y 1300


addStripe \
    -direction horizontal \
    -layer M9 \
    -max_same_layer_jog_length 4 \
    -merge_stripes_value 0.07 \
    -nets {VDD_CORE VSS} \
    -padcore_ring_bottom_layer_limit M7 \
    -padcore_ring_top_layer_limit M8 \
    -set_to_set_distance $y_spacing \
    -spacing 20\
    -width 10 \
    -start_y 1486 \
    -stop_y 2700

    
#addHaloToBlock 70 30 0 0 GH_DIN0
addHaloToBlock 70 30 0 0 GH_CLK
addHaloToBlock 70 30 0 0 GH_VDD
addHaloToBlock 70 30 0 0 GH_VREF
addHaloToBlock 70 30 0 0 GH_VB
addHaloToBlock 70 30 0 0 GH_IBIAS
addHaloToBlock 70 30 0 0 GH_VSS
addHaloToBlock 70 30 0 0 GH_VOUT1
addHaloToBlock 70 30 0 0 GH_VOUT2
addHaloToBlock 70 30 0 0 GH_VIN1
addHaloToBlock 70 30 0 0 GH_VIN2
addHaloToBlock 70 30 0 0 GH_VLOAD1
addHaloToBlock 70 30 0 0 GH_VLOAD2
addHaloToBlock 70 30 0 0 GH_VDDH
addHaloToBlock 70 30 0 0 GH_SWITCH
#addHaloToBlock 70 0 0 0 GH_DIN1




verifyGeometry -error 200000 -noOverlap -report floorplan.geom.rpt

#deleteHaloFromBlock -allBlock

saveFPlan floorplan.fp


saveDesign floorplan


# Start Place
set_global report_timing_format {instance arc instance_location cell fanout load slew delay arrival}
set_global timing_report_timing_header_detail_info extended

# Check timing (and generate timing graph for placement)
setDelayCalMode -reportOutBound true
timeDesign -preplace -prefix prePlace -outDir FINAL/prePlace_timingReports
# Sanity check
checkDesign -all
check_timing



setNanoRouteMode -quiet -routeTopRoutingLayer 7

#Place Design
setPlaceMode -timingDriven true -clkGateAware true -powerDriven false -ignoreScan  true -reorderScan true -ignoreSpare true -placeIoPins true -moduleAwareSpare false -checkPinLayerForAccess {1} -preserveRouting false -rmAffectedRouting false -checkRoute false -swapEEQ false -congEffort medium -uniformDensity true -adaptive true -coreEngineEffort high
placeDesign



#addTieHiLo -cell "TIEH TIEL"
setOptMode -fixDRC true -fixFanoutLoad true -effort high
#setOptMode -fixDRC true -fixFanoutLoad true
optDesign -preCTS       -prefix preCTS -outDir FINAL/preCTS_timingReports
#
#addTieHiLo -cell "TIEH TIEL"


refinePlace
checkPlace checkPlace.rpt
queryPlaceDensity

#Save Design
saveDesign FINAL/top_prects -netlist -tcon -rc

#---------------------------------------------------------------------------------------
#Clock Tree Synthesis
#---------------------------------------------------------------------------------------

setCTSMode \
-routeTopPreferredLayer 7 \
-routeBottomPreferredLayer 3 \
-addClockRootProp true \
-routeGuide true \
-opt true \
-optAddBuffer true \
-optLatency true \
-traceBlackBoxPinAsLeaf true \
-traceIOPinAsLeaf true \
-traceDPinAsLeaf true \
-specMultiMode true \
-routeClkNet false \
-engine ck

set_ccopt_property update_io_latency false

#createClockTreeSpec -bufferList $clkbuffers -clkGroup -file Clock.ctstch
clockDesign -specFile Clock.ctstch -skipTimeDesign -outDir FINAL/clockDesign_reports
refinePlace -checkRoute false -preserveRouting false -rmAffectedRouting false -swapEEQ false -checkPinLayerForAccess 1
#CLOCKTREESYN
#------------------------------------------------------------------

#Optimize After clock tree synthesis, repeat until violations are fixed
setOptMode -fixDRC true -fixFanoutLoad true -effort high -holdTargetSlack 0.5
optDesign -postCTS       -prefix postCTS -outDir FINAL/postCTS_timingReports
optDesign -postCTS -hold -prefix postCTS -outDir FINAL/postCTS_timingReports

#timeDesign -postCTS -expandedViews -outDir RPTS/post_cts_CT_report
#report_ccopt_clock_trees -filename clock_trees.rpt



#createClockTreeSpec -bufferList $clkbuffers -clkGroup -file Clock.ctstch
#
##clockDesign -skipTimeDesign -outDir clockDesign_reports
#
#clockDesign -specFile Clock.ctstch -skipTimeDesign -outDir clockDesign_reports

#refinePlace -checkRoute false -preserveRouting false -rmAffectedRouting false -swapEEQ false -checkPinLayerForAccess 1

saveDesign FINAL/top_postcts -netlist -tcon -rc


reportClockTree -num 100 -preRoute -report FINAL/clockTree.rpt
report_clock_timing -type skew    -early -nworst 100 >  FINAL/preroute_clock_skew_setup_and_hold.rpt
report_clock_timing -type latency -early -nworst 100 >  FINAL/preroute_clock_latency_setup_and_hold.rpt
report_clock_timing -type summary -early -nworst 100 >  FINAL/preroute_clock_summary_setup_and_hold.rpt
report_clock_timing -type skew    -late  -nworst 100 >> FINAL/preroute_clock_skew_setup_and_hold.rpt
report_clock_timing -type latency -late  -nworst 100 >> FINAL/preroute_clock_latency_setup_and_hold.rpt
report_clock_timing -type summary -late  -nworst 100 >> FINAL/preroute_clock_summary_setup_and_hold.rpt


report_clocks
report_ports -type fanout_load_limit

#-----------------------------------------------------------------------------------------------
## Preroute reports
##-----------------------------------------------------------------------------------------------

#timeDesign -postCTS       -outDir FINAL/postCTS_timingReports
#timeDesign -postCTS -hold -outDir FINAL/postCTS_timingReports
#reportGateCount -level 5 -limit 100 -stdCellOnly -outfile FINAL/preroute_area.rpt
#reportWire FINAL/preroute_wire.rpt
saveDesign FINAL/postCTS -netlist -tcon -rc
queryPlaceDensity



#-----------------------------------------------------------------------------------------------
## Route design
##-----------------------------------------------------------------------------------------------
#
## Route power grid
##sroute -connect { padPin }         -layerChangeRange { M1 M8 } -padPinPortConnect { allPort oneGeom } -  allowJogging 1 -crossoverViaLayerRange { M1 M9 } -allowLayerChange 1 -targetViaLayerRange { M1 M9 } -nets { VSS VDD }
##
##sroute -connect { floatingStripe } -layerChangeRange { M1 M8 } -padPinPortConnect { allPort oneGeom } -  allowJogging 1 -crossoverViaLayerRange { M1 M9 } -allowLayerChange 1 -targetViaLayerRange { M1 M9 } -nets { VSS VDD }
##
##sroute -connect { corePin }        -layerChangeRange { M1 M8 }                                        -  allowJogging 1 -crossoverViaLayerRange { M1 M9 } -allowLayerChange 1 -targetViaLayerRange { M1 M9 } -nets { VSS VDD }

#Route Design
setMultiCpuUsage -localCpu 5
setNanoRouteMode -envResistanceFromCapTable true
setNanoRouteMode -quiet -routeTopRoutingLayer 8
setNanoRouteMode -quiet -routeBottomRoutingLayer 1
setNanoRouteMode -quiet -drouteEndIteration default
setNanoRouteMode -quiet -routeWithTimingDriven true
setNanoRouteMode -quiet -routeWithSiDriven false
routeDesign -globalDetail

#report_timing -net -late   -max_points 20000 > FINAL/postroute_preopt_setup_timing.rpt
#report_timing -net -early -max_points 20000 > FINAL/postroute_preopt_hold_timing.rpt

#report_clock_timing -type skew    -early -nworst 100 >  debug_reports/postroute_clock_skew_setup_and_hold.rpt
#report_clock_timing -type latency -early -nworst 100 >  debug_reports/postroute_clock_latency_setup_and_hold.rpt
#report_clock_timing -type summary -early -nworst 100 >  debug_reports/postroute_clock_summary_setup_and_hold.rpt
#report_clock_timing -type skew    -late  -nworst 100 >> debug_reports/postroute_clock_skew_setup_and_hold.rpt
#report_clock_timing -type latency -late  -nworst 100 >> debug_reports/postroute_clock_latency_setup_and_hold.rpt
#report_clock_timing -type summary -late  -nworst 100 >> debug_reports/postroute_clock_summary_setup_and_hold.rpt



#timeDesign -postRoute -outdir postRoute_timing
#timeDesign -postRoute -hold -outdir postRoute_timing

saveDesign FINAL/top_postroute -netlist -tcon -rc

#setExtractRCMode -effortlevel high -engine postRoute -coupled true
setAnalysisMode -analysisType onChipVariation

# Repeat until all setup and hold violations and design rule violations are fixed
setOptMode -fixDRC true -fixFanoutLoad true -effort high -holdTargetSlack 0.5
optDesign -postRoute -drv  -prefix postRoute -outDir FINAL/postRoute_timingReports
optDesign -postRoute       -prefix postRoute -outDir FINAL/postRoute_timingReports
optDesign -postRoute -hold -prefix postRoute -outDir FINAL/postRoute_timingReports

#report_noise -bumpy_waveform
#report_clock_timing -type latency -early -nworst 100 >  FINAL/postroute_setupopt_clock_latency_setup_and_hold.rpt
#report_clock_timing -type summary -early -nworst 100 >  FINAL/postroute_setupopt_clock_summary_setup_and_hold.rpt
#report_clock_timing -type skew    -late  -nworst 100 >> FINAL/postroute_setupopt_clock_skew_setup_and_hold.rpt
#report_clock_timing -type latency -late  -nworst 100 >> FINAL/postroute_setupopt_clock_latency_setup_and_hold.rpt
#report_clock_timing -type summary -late  -nworst 100 >> FINAL/postroute_setupopt_clock_summary_setup_and_hold.rpt

#report_timing -net -late   -max_points 20000 > FINAL/postroute_opt_setup_timing.rpt
#report_timing -net -early -max_points 20000 > FINAL/postroute_opt_hold_timing.rpt


setExtractRCMode -effortlevel high -engine postRoute -coupled true
#break
#Repeat until all violations are fixed
optDesign -postRoute -drv  -prefix signoff -outDir FINAL/postroute_timingReports
optDesign -postRoute       -prefix signoff -outDir FINAL/postroute_timingReports
optDesign -postRoute -hold -prefix signoff -outDir FINAL/postroute_timingReports



saveDesign FINAL/top_postroute_opt -netlist -tcon -rc





# Add core fillers
getFillerMode -quiet
setFillerMode -reset
setFillerMode -corePrefix FILLER -createRows true -doDRC true -deleteFixed true -ecoMode false
addFiller -cell DCAP64 -prefix FILLCAP
addFiller -cell FILL64 FILL32 FILL16 FILL8 FILL4 FILL2 FILL1 -prefix FILLER


#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
saveDesign FINAL/top_corefill -netlist -tcon -rc
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

#---------------------------------------------------------------------------------------------
#PostRoute Reports
#---------------------------------------------------------------------------------------------


checkRoute
verifyGeometry -error 200000 -noOverlap -report postroute.geom.rpt
fixVia -minStep
fixVia -minCut

#-----------------------------------------------------------------------------------------------
# Setup
#-----------------------------------------------------------------------------------------------

setAnalysisMode -checkType setup -asyncChecks async -skew true -clockPropagation sdcControl
buildTimingGraph
report_timing -net -late            -max_points 1000 > FINAL/postroute_setup_timing.rpt
report_timing -net -late -from [all_inputs] -max_points 100   > FINAL/postroute_setup_timing_input.rpt
report_timing -net -late -to [all_outputs]  -max_points 100   > FINAL/postroute_setup_timing_output.rpt
report_timing -net   

#-----------------------------------------------------------------------------------------------
# DRVs
#-----------------------------------------------------------------------------------------------

report_constraint -all_violators -drv_violation_type max_capacitance -verbose > FINAL/drv_max_capacitance.rpt
report_constraint -all_violators -drv_violation_type max_transition  -verbose > FINAL/drv_max_transition.rpt




#specifyClockTree -file Clock.ctstch.sys_con
specifyClockTree -file Clock.ctstch
reportClockTree -num 100 -postRoute -report FINAL/clockTree_fin.rpt

setAnalysisMode -checkType hold -asyncChecks async -skew true -clockPropagation sdcControl
buildTimingGraph


#-----------------------------------------------------------------------------------------------
# Hold
#-----------------------------------------------------------------------------------------------

report_timing -net -early           -max_points 1000 > FINAL/postroute_hold_timing.rpt
report_timing -net -early -from [all_inputs]    -max_points 100   > FINAL/postroute_hold_timing_input.rpt
report_timing -net 


#-----------------------------------------------------------------------------------------------
# Report more clock information 
#-----------------------------------------------------------------------------------------------
report_clock_timing -type skew    -early -nworst 100 >  FINAL/postroute_clock_skew_setup_and_hold.rpt
report_clock_timing -type latency -early -nworst 100 >  FINAL/postroute_clock_latency_setup_and_hold.rpt
report_clock_timing -type summary -early -nworst 100 >  FINAL/postroute_clock_summary_setup_and_hold.rpt
report_clock_timing -type skew    -late  -nworst 100 >> FINAL/postroute_clock_skew_setup_and_hold.rpt
report_clock_timing -type latency -late  -nworst 100 >> FINAL/postroute_clock_latency_setup_and_hold.rpt
report_clock_timing -type summary -late  -nworst 100 >> FINAL/postroute_clock_summary_setup_and_hold.rpt


#-----------------------------------------------------------------------------------------------
# Report power consumption
#----------------------------------------------------------------------------------------------
report_power -outfile FINAL/postroute_power_summary.rpt



saveDesign FINAL/top_par -netlist -tcon -rc

streamOut FINAL/par.gds -mapFile gds2.map

saveNetlist FINAL/par.v -includePowerGround -excludeLeafCell -includePhysicalCell {DCAP64} -excludeCellInst PCORNER
saveNetlist FINAL/par_nopg.v -excludeLeafCell -includePhysicalCell {DCAP64} -excludeCellInst PCORNER

setExtractRCMode -effortlevel high -engine postRoute -coupled true
extractRC
rcOut -spef FINAL/rc_max.spef
reportClockTree -postRoute -report FINAL/clkTreeReport_worst.rpt -view sys_worst_case
reportClockTree -postRoute -report FINAL/clkTreeReport_best.rpt  -view sys_best_case
#timeDesign -signoff       -reportOnly -outDir FINAL/signoff_timingReports
#timeDesign -signoff -hold -reportOnly -outDir FINAL/signoff_timingReports

reportGateCount -level 5 -limit 100 -stdCellOnly -outfile FINAL/postroute_area.rpt
reportWire FINAL/postroute_wire.rpt
queryPlaceDensity

# Check timing
check_timing -verbose > FINAL/checktiming.rpt
#-----------------------------------------------------------------------------------------------
## Write SDF timing 
##-----------------------------------------------------------------------------------------------
write_sdf -edges check_edge FINAL/timing.sdf
## Compile the SDF file for use in verilog simulation using 'ncsdfc timing.sdf'from the command line

#-----------------------------------------------------------------------------------------------
# Write simulation netlist
#-----------------------------------------------------------------------------------------------
saveNetlist FINAL/par_sim.v -excludeLeafCell
saveNetlist FINAL/par_sim_PG.v -excludeLeafCell -includePowerGround


#Remap and re-optimize gate level netlist
#runN2NOpt
#
#Create Blockages

#setNanoRouteMode -quiet -routeTopRoutingLayer 7
