if {![info exists PROJ_DIR]} {
    if {[info exists env(PROJECT_ROOT)]} {
        set PROJ_DIR [file normalize $env(PROJECT_ROOT)]
    } elseif {[file exists "./input_data"]} {
        set PROJ_DIR [file normalize "."]
    } elseif {[file exists "../input_data"]} {
        set PROJ_DIR [file normalize ".."]
    } else {
        set PROJ_DIR [file normalize ".."]
    }
}

set init_lef_file [list \
    $PROJ_DIR/input_data/lef/rtk-tech.lef \
    $PROJ_DIR/input_data/lef/stdcells.lef \
    $PROJ_DIR/input_data/lef/SRAM_16x1024_1rw.lef \
    $PROJ_DIR/input_data/lef/SRAM_16x256_1rw.lef \
    $PROJ_DIR/input_data/lef/SRAM_16x4096_1rw.lef \
    $PROJ_DIR/input_data/lef/SRAM_32x256_1rw.lef \
]
