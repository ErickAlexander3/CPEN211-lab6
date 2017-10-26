onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /cpu_autograder_example_tb/DUT/datapath_controller/clk_state/clk
add wave -noupdate /cpu_autograder_example_tb/DUT/datapath_controller/opcode
add wave -noupdate /cpu_autograder_example_tb/DUT/datapath_controller/op
add wave -noupdate /cpu_autograder_example_tb/DUT/datapath_controller/present_state
add wave -noupdate /cpu_autograder_example_tb/DUT/datapath_controller/next_state
add wave -noupdate /cpu_autograder_example_tb/DUT/datapath_controller/next_state_reset
add wave -noupdate /cpu_autograder_example_tb/DUT/datapath_controller/nsel
add wave -noupdate /cpu_autograder_example_tb/DUT/datapath_controller/vsel
add wave -noupdate /cpu_autograder_example_tb/DUT/datapath_controller/write
add wave -noupdate /cpu_autograder_example_tb/DUT/DP/pipeline_reg_A_out
add wave -noupdate /cpu_autograder_example_tb/DUT/DP/pipeline_reg_B_out_shifted
add wave -noupdate /cpu_autograder_example_tb/DUT/DP/REGFILE/R0
add wave -noupdate /cpu_autograder_example_tb/DUT/DP/REGFILE/R1
add wave -noupdate /cpu_autograder_example_tb/DUT/DP/REGFILE/R2
add wave -noupdate /cpu_autograder_example_tb/DUT/DP/REGFILE/R3
add wave -noupdate /cpu_autograder_example_tb/DUT/DP/REGFILE/R4
add wave -noupdate /cpu_autograder_example_tb/DUT/DP/REGFILE/R5
add wave -noupdate /cpu_autograder_example_tb/DUT/DP/REGFILE/R6
add wave -noupdate /cpu_autograder_example_tb/DUT/DP/REGFILE/R7
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {15 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 193
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {151 ps} {198 ps}
