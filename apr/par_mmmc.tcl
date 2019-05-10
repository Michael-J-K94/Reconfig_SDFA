set tsmchome /mms/kits/TSMC_mosis/CRN65LP/TSMCHOME
set sramhome /home/mmsjw/2018TapeOut/lib
set synhome /home/mmsjw/2018TapeOut/syn

#------------------------------------------------------------
# Initialize timing (MMMC)
#------------------------------------------------------------
# Load technology variables

# Cap tables
set CAP_DIR $tsmchome/digital/Back_End/lef/tcbn65lp_200a/techfiles/captable
set CAPTABLE_TYP ${CAP_DIR}/cln65lp_1p09m+alrdl_top2_typical.captable
set CAPTABLE_MIN ${CAP_DIR}/cln65lp_1p09m+alrdl_top2_rcbest.captable 
set CAPTABLE_MAX ${CAP_DIR}/cln65lp_1p09m+alrdl_top2_rcworst.captable

# RC extraction
set QX_DIR $tsmchome/digital/Back_End/voltage_storm/tcbn65lp_200b
set QXTECH_TYP ${QX_DIR}/tcbn65lp_9lmT2_tc_dv.cl/rcgenTechFile
set QXTECH_MIN ${QX_DIR}/tcbn65lp_9lmT2_bc_dv.cl/rcgenTechFile
set QXTECH_MAX ${QX_DIR}/tcbn65lp_9lmT2_wc_dv.cl/rcgenTechFile

set TIMELIBS_TYP [list $tsmchome/digital/Front_End/timing_power_noise/NLDM/tcbn65lp_220a/tcbn65lptc.lib \
        $tsmchome/digital/Front_End/timing_power_noise/NLDM/tpan65lpnv2od3_200a/tpan65lpnv2od3tc.lib \
        $tsmchome/digital/Front_End/timing_power_noise/NLDM/tpdn65lpnv2od3_200a/tpdn65lpnv2od3tc.lib \
        $sramhome/ts6n65lplla200x70m2s_210a_tt1p2v25c.lib \
]

set TIMELIBS_MIN [list $tsmchome/digital/Front_End/timing_power_noise/NLDM/tcbn65lp_220a/tcbn65lpbc.lib \
        $tsmchome/digital/Front_End/timing_power_noise/NLDM/tpan65lpnv2od3_200a/tpan65lpnv2od3bc.lib \
        $tsmchome/digital/Front_End/timing_power_noise/NLDM/tpdn65lpnv2od3_200a/tpdn65lpnv2od3bc.lib \
        $sramhome/ts6n65lplla200x70m2s_210a_ff1p32v0c.lib \
]

set TIMELIBS_MAX [list $tsmchome/digital/Front_End/timing_power_noise/NLDM/tcbn65lp_220a/tcbn65lpwc.lib \
        $tsmchome/digital/Front_End/timing_power_noise/NLDM/tpan65lpnv2od3_200a/tpan65lpnv2od3wc.lib \
        $tsmchome/digital/Front_End/timing_power_noise/NLDM/tpdn65lpnv2od3_200a/tpdn65lpnv2od3wc.lib \
        $sramhome/ts6n65lplla200x70m2s_210a_ss1p08v105c.lib \
]


# Create a constraint based on our .sdc file
create_constraint_mode -name sys_con -sdc_file pre_layout/top.syn.sdc

# Create RC corners from captables
#create_rc_corner -name max_rc -cap_table ${CAPTABLE_MAX} -qx_tech_file ${QXTECH_MAX}
#create_rc_corner -name min_rc -cap_table ${CAPTABLE_MIN} -qx_tech_file ${QXTECH_MIN}
#create_rc_corner -name typ_rc -cap_table ${CAPTABLE_TYP} -qx_tech_file ${QXTECH_TYP}
create_rc_corner -name max_rc -cap_table ${CAPTABLE_MAX} -qx_tech_file ${QXTECH_MAX}
create_rc_corner -name min_rc -cap_table ${CAPTABLE_MIN} -qx_tech_file ${QXTECH_MIN}
create_rc_corner -name typ_rc -cap_table ${CAPTABLE_TYP} -qx_tech_file ${QXTECH_TYP}

# Create early and late libraries from .lib files
create_library_set -name late_library -timing ${TIMELIBS_MAX}
create_library_set -name early_library -timing ${TIMELIBS_MIN}
create_library_set -name typ_library -timing ${TIMELIBS_TYP}

# Create delay corners based on library and rc corner
create_delay_corner -name max_rc_late_timing_case -library_set late_library -rc_corner max_rc
create_delay_corner -name max_rc_early_timing_case -library_set early_library -rc_corner max_rc
create_delay_corner -name min_rc_early_timing_case -library_set early_library -rc_corner min_rc
create_delay_corner -name min_rc_late_timing_case -library_set late_library -rc_corner min_rc
create_delay_corner -name typ_rc_typ_timing_case -library_set typ_library -rc_corner typ_rc

# Create best case and worst case analysis views given constraint mode and delay corners
create_analysis_view -name sys_worst_case -constraint_mode sys_con -delay_corner max_rc_late_timing_case
create_analysis_view -name sys_best_case -constraint_mode sys_con -delay_corner min_rc_early_timing_case
create_analysis_view -name sys_medium_case1 -constraint_mode sys_con -delay_corner max_rc_early_timing_case
create_analysis_view -name sys_medium_case2 -constraint_mode sys_con -delay_corner min_rc_late_timing_case
create_analysis_view -name sys_nom_case -constraint_mode sys_con -delay_corner typ_rc_typ_timing_case

# Associate setup and hold analysis with the analysis views
set_analysis_view -setup {sys_worst_case sys_nom_case sys_best_case} -hold {sys_best_case sys_medium_case1 sys_medium_case2 sys_worst_case sys_nom_case}
set_default_view -setup sys_worst_case -hold sys_best_case
