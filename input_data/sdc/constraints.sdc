############################################################
# CNN_1D_Core
# Target: GSC045
# Top: CNN_1D_Core
############################################################

set_units -time ns -capacitance pF

set_load 0.020 [all_outputs]

# input clock
set TCK_SYS 4
create_clock -name clk_sys -period $TCK_SYS [get_ports CLK]

# clock uncertainty and transition
set_clock_uncertainty -setup 0.100 [get_clocks clk_sys]
set_clock_uncertainty -hold 0.050 [get_clocks clk_sys]
set_clock_transition 0.050 [get_clocks clk_sys]

# input & output delay
set IO_DELAY 0.05
set DATA_INPUTS [remove_from_collection [all_inputs] [get_ports CLK]]

set_input_delay  -max $IO_DELAY -clock [get_clocks clk_sys] $DATA_INPUTS
set_input_delay  -min 0.0       -clock [get_clocks clk_sys] $DATA_INPUTS

set_output_delay -max $IO_DELAY -clock [get_clocks clk_sys] [all_outputs]
set_output_delay -min 0.0       -clock [get_clocks clk_sys] [all_outputs]

# input transition
set_input_transition 0.05 $DATA_INPUTS
set_max_transition   0.20 [current_design]

# false path
set_false_path -from [get_ports RST]

puts "SDC loaded: period=${TCK_SYS}ns"
