onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /cpu_tb/DUT/datapath_controller/clk
add wave -noupdate /cpu_tb/DUT/datapath_controller/s
add wave -noupdate /cpu_tb/DUT/datapath_controller/reset
add wave -noupdate /cpu_tb/DUT/datapath_controller/opcode
add wave -noupdate /cpu_tb/DUT/datapath_controller/op
add wave -noupdate /cpu_tb/DUT/datapath_controller/w
add wave -noupdate /cpu_tb/DUT/datapath_controller/loada
add wave -noupdate /cpu_tb/DUT/datapath_controller/loadb
add wave -noupdate /cpu_tb/DUT/datapath_controller/loadc
add wave -noupdate /cpu_tb/DUT/datapath_controller/loads
add wave -noupdate /cpu_tb/DUT/datapath_controller/asel
add wave -noupdate /cpu_tb/DUT/datapath_controller/bsel
add wave -noupdate /cpu_tb/DUT/datapath_controller/write
add wave -noupdate /cpu_tb/DUT/datapath_controller/nsel
add wave -noupdate /cpu_tb/DUT/datapath_controller/vsel
add wave -noupdate /cpu_tb/DUT/datapath_controller/present_state
add wave -noupdate /cpu_tb/DUT/datapath_controller/next_state
add wave -noupdate /cpu_tb/DUT/DP/REGFILE/R0
add wave -noupdate /cpu_tb/DUT/DP/REGFILE/R1
add wave -noupdate /cpu_tb/DUT/DP/REGFILE/R2
add wave -noupdate /cpu_tb/DUT/DP/REGFILE/R3
add wave -noupdate /cpu_tb/DUT/DP/REGFILE/R4
add wave -noupdate /cpu_tb/DUT/DP/REGFILE/R5
add wave -noupdate /cpu_tb/DUT/DP/REGFILE/R6
add wave -noupdate /cpu_tb/DUT/DP/REGFILE/R7
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
configure wave -namecolwidth 150
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
WaveRestoreZoom {0 ps} {1118 ps}
