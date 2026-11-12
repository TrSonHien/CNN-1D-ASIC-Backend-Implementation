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

global STAGE
puts "Save placeOnly dbs"
saveDesign $PROJ_DIR/SAVED/${STAGE}_placeOnly.invs
timeDesign -preCTS -pathReports -slackReports -numPaths 1000 -prefix ${STAGE}_place -outDir $PROJ_DIR/rpt/${STAGE}/${STAGE}_setup_placeOnly
