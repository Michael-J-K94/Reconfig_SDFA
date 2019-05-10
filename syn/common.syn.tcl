# common.tcl setup library files

# 65nm TSMC Library
# Set library paths
set STDCELL "/mms/kits/TSMC_mosis/CRN65LP/TSMCHOME/digital/Front_End/timing_power_noise/NLDM/tcbn65lp_220a"
set SYNOPSYS [get_unix_variable SYNOPSYS]
set search_path [list "." $STDCELL ${SYNOPSYS}/libraries/syn ../lib]

#Should link memory db file here
set link_library "* tcbn65lptc.db dw_foundation.sldb ts6n65lplla200x70m2stc.db" 

set target_library "tcbn65lptc.db"

# set_dont_use any *XL* cell
set_dont_use { tcbn65lptc/L* tcbn65lptc/S* tcbn65lptc/G* tcbn65lptc/CK*}

