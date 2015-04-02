#
# 
# Script for Cadence RTL Compiler synthesis based on Erik Brunvand's
# book.
#
# Script Modified for UCDavis's EEC119
# 
 
set_attribute hdl_search_path {./} 
set_attribute lib_search_path {./}
set_attribute library eec116stdCell.lib
set_attribute information_level 6 

set myFiles detect.v   ;# All your HDL files
set basename detect   ;# name of top level module
set myClk clk                  ;# clock name
set myPeriod_ps 10000            ;# Clock period in ps
set myInDelay_ns 1           ;# delay from clock to inputs valid=clk period-input setup
set myOutDelay_ns 2          ;# delay from clock to output valid=comb. delay at output
set runname results            ;# name appended to output files

#*********************************************************
#*   below here shouldn't need to be changed...          *
#*********************************************************

# Analyze and Elaborate the HDL files
read_hdl ${myFiles}
elaborate ${basename}

# Apply Constraints and generate clocks
set clock [define_clock -period ${myPeriod_ps} -name ${myClk} [clock_ports]]	
external_delay -input $myInDelay_ns -clock ${myClk} [find / -port ports_in/*]
external_delay -output $myOutDelay_ns -clock ${myClk} [find / -port ports_out/*]

# Sets transition to default values for Synopsys SDC format, 
# fall/rise 400ps
dc::set_clock_transition .4 $myClk

# check that the design is OK so far
check_design -unresolved
report timing -lint

# Synthesize the design to the target library
synthesize -to_mapped

# Write out the reports
report gates  > ${basename}_cell.rep
report timing > ./${runname}/${basename}_timing.rep
report power  > ./${runname}/${basename}_power.rep

# Write out the structural Verilog and sdc files
write_hdl -mapped >  ${basename}_structural.v
write_sdc >  ${basename}.sdc
