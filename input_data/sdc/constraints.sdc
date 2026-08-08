############################################################
# RISC-V CORE Genus SDC
# Target: GSC045
# Top: CORE
############################################################

############################################################
# Global
############################################################
set_units -time ns -capacitance pF

############################################################
# Driving Cells and Loads
############################################################

# For block-level CORE synthesis, do not use pad driving cells.
# Pad cells are only relevant for chip_top/full-chip timing.

# Conservative generic output load for block-level synthesis.
set_load 0.02 [all_outputs]

############################################################
# Input Clock
############################################################

set TCK_SYS 3.334
create_clock -name clk_sys -period $TCK_SYS [get_ports CLK]

############################################################
# Clock Uncertainty and Transition
############################################################

set_clock_uncertainty -setup 0.10 [get_clocks clk_sys]
set_clock_uncertainty -hold  0.05 [get_clocks clk_sys]
set_clock_transition         0.05 [get_clocks clk_sys]

############################################################
# Reset & Asynchronous Inputs
############################################################

# CORE reset is synchronous in RTL, so it must be timed (do not false-path).

# False paths for asynchronous external inputs
if {[sizeof_collection [get_ports -quiet {SW[*]}]] > 0} {
    set_false_path -from [get_ports -quiet {SW[*]}]
}
if {[sizeof_collection [get_ports -quiet GPIO_0]] > 0} {
    set_false_path -from [get_ports -quiet GPIO_0]
}

############################################################
# Input / Output Delays
############################################################

#set IO_DELAY [expr $TCK_SYS * 0.10]
#set IO_DELAY [expr $TCK_SYS * 0.05]
set IO_DELAY 0.05

# Exclude clock from normal data input constraints.
# (Synchronous reset is kept in DATA_INPUTS so it is constrained with input delay)
set DATA_INPUTS [remove_from_collection [all_inputs] [get_ports CLK]]

set_input_delay  -max $IO_DELAY -clock [get_clocks clk_sys] $DATA_INPUTS
set_input_delay  -min 0.0       -clock [get_clocks clk_sys] $DATA_INPUTS

set_output_delay -max $IO_DELAY -clock [get_clocks clk_sys] [all_outputs]
set_output_delay -min 0.0       -clock [get_clocks clk_sys] [all_outputs]

############################################################
# Input Transition
############################################################

set_input_transition 0.05 $DATA_INPUTS

############################################################
# Electrical Constraints
############################################################

# Keep this reasonably tight at CORE level.
set_max_transition 0.3 [current_design]

############################################################
# Info
############################################################

puts "============================================================"
puts "Loaded RISC-V CORE Genus SDC"
puts "Clock period      : $TCK_SYS ns"
puts "Clock name        : clk_sys"
puts "Clock port        : CLK"
puts "IO delay          : $IO_DELAY ns"
puts "Setup uncertainty : 0.10 ns"
puts "Hold uncertainty  : 0.05 ns"
puts "============================================================"
