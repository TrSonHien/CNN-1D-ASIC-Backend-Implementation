if {![namespace exists ::IMEX]} { namespace eval ::IMEX {} }
set ::IMEX::dataVar [file dirname [file normalize [info script]]]
set ::IMEX::libVar ${::IMEX::dataVar}/libs

create_library_set -name gsclib045_fast\
   -timing\
    [list ${::IMEX::libVar}/mmmc/stdcells-bc.lib\
    ${::IMEX::libVar}/mmmc/SRAM_32x256_1rw_FF_1p0V_25C.lib\
    ${::IMEX::libVar}/mmmc/SRAM_16x1024_1rw_FF_1p0V_25C.lib\
    ${::IMEX::libVar}/mmmc/SRAM_16x4096_1rw_FF_1p0V_25C.lib\
    ${::IMEX::libVar}/mmmc/SRAM_16x256_1rw_FF_1p0V_25C.lib]
create_library_set -name gsclib045_slow\
   -timing\
    [list ${::IMEX::libVar}/mmmc/stdcells-wc.lib\
    ${::IMEX::libVar}/mmmc/SRAM_32x256_1rw_SS_1p0V_25C.lib\
    ${::IMEX::libVar}/mmmc/SRAM_16x1024_1rw_SS_1p0V_25C.lib\
    ${::IMEX::libVar}/mmmc/SRAM_16x4096_1rw_SS_1p0V_25C.lib\
    ${::IMEX::libVar}/mmmc/SRAM_16x256_1rw_SS_1p0V_25C.lib]
create_library_set -name gsclib045_typical\
   -timing\
    [list ${::IMEX::libVar}/mmmc/stdcells.lib\
    ${::IMEX::libVar}/mmmc/SRAM_32x256_1rw_TT_1p0V_25C.lib\
    ${::IMEX::libVar}/mmmc/SRAM_16x1024_1rw_TT_1p0V_25C.lib\
    ${::IMEX::libVar}/mmmc/SRAM_16x4096_1rw_TT_1p0V_25C.lib\
    ${::IMEX::libVar}/mmmc/SRAM_16x256_1rw_TT_1p0V_25C.lib]
create_op_cond -name SLOW -library_file ${::IMEX::libVar}/mmmc/stdcells-wc.lib -P 1 -V 0.95 -T 125
create_op_cond -name TYPICAL -library_file ${::IMEX::libVar}/mmmc/stdcells.lib -P 1 -V 1.1 -T 25
create_op_cond -name FAST -library_file ${::IMEX::libVar}/mmmc/stdcells-bc.lib -P 1 -V 1.25 -T 0
create_rc_corner -name rc_typ\
   -cap_table ${::IMEX::libVar}/mmmc/rtk-typical.captable\
   -preRoute_res 1\
   -postRoute_res 1\
   -preRoute_cap 1\
   -postRoute_cap 1\
   -postRoute_xcap 1\
   -preRoute_clkres 0\
   -preRoute_clkcap 0\
   -T 25
create_rc_corner -name rc_best\
   -cap_table ${::IMEX::libVar}/mmmc/rtk-typical.captable\
   -preRoute_res 1\
   -postRoute_res 1\
   -preRoute_cap 1\
   -postRoute_cap 1\
   -postRoute_xcap 1\
   -preRoute_clkres 0\
   -preRoute_clkcap 0\
   -T 0
create_rc_corner -name rc_worst\
   -cap_table ${::IMEX::libVar}/mmmc/rtk-typical.captable\
   -preRoute_res 1\
   -postRoute_res 1\
   -preRoute_cap 1\
   -postRoute_cap 1\
   -postRoute_xcap 1\
   -preRoute_clkres 0\
   -preRoute_clkcap 0\
   -T 125
create_delay_corner -name delay_fast\
   -library_set gsclib045_fast\
   -opcond FAST\
   -rc_corner rc_best
create_delay_corner -name delay_slow\
   -library_set gsclib045_slow\
   -opcond SLOW\
   -rc_corner rc_worst
create_delay_corner -name delay_typical\
   -library_set gsclib045_typical\
   -opcond TYPICAL\
   -rc_corner rc_typ
create_constraint_mode -name func_mode\
   -sdc_files\
    [list ${::IMEX::dataVar}/mmmc/modes/func_mode/func_mode.sdc]
create_analysis_view -name func_view_setup -constraint_mode func_mode -delay_corner delay_slow -latency_file ${::IMEX::dataVar}/mmmc/views/func_view_setup/latency.sdc
create_analysis_view -name func_view_hold -constraint_mode func_mode -delay_corner delay_fast -latency_file ${::IMEX::dataVar}/mmmc/views/func_view_hold/latency.sdc
create_analysis_view -name func_view_typical -constraint_mode func_mode -delay_corner delay_typical
set_analysis_view -setup [list func_view_setup] -hold [list func_view_hold]
catch {set_interactive_constraint_mode [list func_mode] } 
